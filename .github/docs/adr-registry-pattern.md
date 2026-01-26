# Architecture Decision Record: Registry-Based QR Type System

## Status
**Accepted** - Implemented January 2026

## Context

The qrty app generates QR codes for 12 different types (text, URL, email, WiFi, vCard, etc.). The original implementation used switch statements scattered across multiple files to handle type-specific logic:

- `QrFormScreenFactory`: Switch to create form screens
- `QrContentGenerator`: Switch for QR data generation
- `TypeIcon`: Switch for icon mapping
- `QrTypeGrid`: Hardcoded type list

**Problems with the original approach:**

1. **Violation of Open/Closed Principle**: Adding a new QR type required modifying 4-6 files
2. **Maintenance burden**: Switch statements duplicated type logic across codebase
3. **Error-prone**: Easy to forget updating one switch case
4. **Lack of type safety**: Map-based form data prone to string-key typos
5. **Poor testability**: Hard to test individual types in isolation
6. **Coupling**: QR type logic scattered across feature and core layers

**Example of the problem:**
```dart
// Had to update this switch in 3+ files for each new type
switch (type) {
  case QRCodeType.text: return TextQrFormScreen();
  case QRCodeType.url: return UrlQrFormScreen();
  // ... 10 more cases
}
```

## Decision

We will refactor to a **registry-based architecture** using the **Strategy Pattern**:

1. **Create typed form data models**: Immutable classes with embedded validation
2. **Define QR type protocol**: Abstract `QrTypeDefinition` interface
3. **Implement concrete definitions**: One class per QR type
4. **Build centralized registry**: Singleton that manages all type definitions
5. **Simplify factories**: Thin wrappers that delegate to registry

**Key principles:**
- **Single source of truth** for each QR type
- **Type safety** through form data models
- **Decoupling** through abstraction
- **Plugin architecture** for easy extension

## Implementation

### Architecture Components

```
┌─────────────────────────────────────────────────┐
│           QrTypeRegistry (Singleton)            │
│  ┌───────────────────────────────────────────┐  │
│  │ Map<QRCodeType, QrTypeDefinition>         │  │
│  │  - text    → TextQrDefinition             │  │
│  │  - url     → UrlQrDefinition              │  │
│  │  - wifi    → WifiQrDefinition             │  │
│  │  - vcard   → VCardQrDefinition            │  │
│  │  ... (12 total types)                     │  │
│  └───────────────────────────────────────────┘  │
│                                                  │
│  Methods:                                        │
│  • getDefinition(type)                           │
│  • buildForm(type)                               │
│  • generateQrData(type, formData)                │
│  • validateData(type, formData)                  │
└─────────────────────────────────────────────────┘
                      ▲
                      │ delegates to
                      │
    ┌─────────────────┴─────────────────┐
    │                                   │
┌───▼──────────────┐        ┌───────────▼─────────┐
│ QrFormScreen     │        │ QrContentGenerator  │
│ Factory          │        │                     │
│                  │        │ • generateQrData()  │
│ • createForm()   │        │ • validateData()    │
└──────────────────┘        └─────────────────────┘
```

### Type Definition Structure

Each QR type consists of 2 files:

**1. Form Data Model** (`lib/core/models/qr_form_data/`)
```dart
class WifiQrFormData extends QrFormDataBase {
  final String ssid;
  final String password;
  final String security;
  
  @override
  Map<String, String> validate() {
    // Validation logic embedded in model
  }
}
```

**2. Type Definition** (`lib/core/qr_types/definitions/`)
```dart
class WifiQrDefinition extends QrTypeDefinition<WifiQrFormData> {
  @override
  String generateQrData(WifiQrFormData formData) {
    return WiFiGenerator.generateWiFi(...);
  }
}
```

### Adding a New Type

Before (6 files to modify):
```dart
// QrFormScreenFactory.dart
case QRCodeType.linkedin: return LinkedInScreen();

// QrContentGenerator.dart  
case QRCodeType.linkedin: return generateLinkedIn(formData);

// TypeIcon.dart
case QRCodeType.linkedin: return AppAssets.linkedin;

// Plus validation switch, display name switch, etc.
```

After (2 new files + 1 registration):
```dart
// 1. linkedin_qr_form_data.dart - NEW
class LinkedInQrFormData extends QrFormDataBase { ... }

// 2. linkedin_qr_definition.dart - NEW
class LinkedInQrDefinition extends QrTypeDefinition { ... }

// 3. qr_type_registry.dart - ONE LINE
_register(LinkedInQrDefinition());
```

## Consequences

### Positive

✅ **Reduced coupling**: QR type logic isolated in 2 adjacent files  
✅ **Type safety**: Compile-time checking eliminates string-key errors  
✅ **OCP compliance**: Add types without modifying existing code  
✅ **Testability**: Each type independently testable  
✅ **Maintainability**: Changes to one type don't affect others  
✅ **Discoverability**: All types listed in one registry file  
✅ **Consistency**: Enforced structure through abstract base class  
✅ **Extensibility**: Plugin-like architecture for future expansion  

### Negative

⚠️ **More files**: 24 new files (2 per type × 12 types)  
⚠️ **Indirection**: One extra lookup through registry  
⚠️ **Learning curve**: Team must understand pattern  
⚠️ **Boilerplate**: Each type needs similar structure  

### Neutral

➖ **Performance**: Negligible (O(1) map lookup vs O(1) switch)  
➖ **Code volume**: ~150 lines per type (similar to before, but structured)  
➖ **Dependencies**: No new external dependencies  

## Alternatives Considered

### 1. Keep Switch Statements
**Rejected**: Violates OCP, high maintenance burden, error-prone

### 2. Factory Method Pattern
```dart
abstract class QrTypeFactory {
  QRCodeType get type;
  Widget buildForm();
}
```
**Rejected**: Still requires registry to map enum to factory, adds unnecessary layer

### 3. Abstract Factory Pattern
**Rejected**: Overkill for single product family, too much complexity

### 4. Service Locator
**Rejected**: Less explicit than registry, harder to test

### 5. Dependency Injection
**Rejected**: Unnecessary complexity for static type system

## Migration Strategy

Implemented in 4 phases over 2 weeks:

**Phase 1: Foundation** (3 simple types)
- Created base classes
- Implemented Text, URL, Email
- Validated architecture works

**Phase 2: Simple Types** (5 types)
- Phone, SMS, Twitter, Instagram, Location
- Confirmed pattern scales

**Phase 3: Complex Types** (4 types)
- WiFi, vCard, Business, Event
- Tested with complex forms and validation

**Phase 4: Cleanup**
- Removed all switch statements
- Simplified factory classes
- Added comprehensive tests (55 tests)
- Documented architecture

## Validation

### Tests
- ✅ 55 unit tests (all passing)
- ✅ 100% type coverage (12/12 types)
- ✅ Validation tests for all types
- ✅ Generation tests for all types

### Metrics
- **Files modified**: 4 (factories simplified)
- **Files created**: 26 (24 type files + 2 docs)
- **Lines removed**: ~400 (switch statements)
- **Lines added**: ~1800 (structured type definitions)
- **Net complexity**: Lower (better organized)

### Code Quality
- ✅ No errors: `dart analyze`
- ✅ Type safe: Strong typing throughout
- ✅ Formatted: `dart format`
- ✅ Documented: Architecture and guide docs

## Success Criteria

All criteria met:

✅ **Extensibility**: New type in ~150 lines, no core modifications  
✅ **Maintainability**: Each type isolated to 2 files  
✅ **Type Safety**: Form data models prevent errors  
✅ **Testability**: 55 comprehensive tests passing  
✅ **Performance**: No measurable performance impact  
✅ **Documentation**: Complete architecture + how-to guide  

## References

### Design Patterns
- **Registry Pattern**: Martin Fowler's "Patterns of Enterprise Application Architecture"
- **Strategy Pattern**: Gang of Four "Design Patterns"
- **Template Method**: Gang of Four "Design Patterns"

### Principles
- **Open/Closed Principle**: Robert C. Martin's "Clean Architecture"
- **Single Responsibility**: SOLID principles
- **Dependency Inversion**: Depend on abstractions, not concretions

### Related ADRs
- None (first major architectural decision)

### Implementation Files
- Architecture: `.github/docs/registry-based-architecture.md`
- Guide: `.github/docs/how-to-add-qr-type.md`
- Tests: `test/registry_test.dart`
- Registry: `lib/core/qr_types/qr_type_registry.dart`

## Review and Update

**Last reviewed**: January 26, 2026  
**Next review**: Q2 2026 (after 3+ months of usage)  
**Reviewers**: Development team

**Update triggers**:
- Adding 5+ new QR types (evaluate if pattern still scales)
- Performance issues identified
- Team feedback on developer experience
- Major Flutter/Dart version upgrades

## Conclusion

The registry-based architecture successfully addresses all original problems:
- ✅ Achieves OCP compliance
- ✅ Eliminates switch statement duplication
- ✅ Provides type safety
- ✅ Improves testability
- ✅ Reduces coupling

The pattern scales well (12 types working) and provides a clear path for future extension. The minor increase in file count is offset by significantly improved organization and maintainability.

**Recommendation**: Continue using this architecture for all new QR types and similar plugin-style features.
