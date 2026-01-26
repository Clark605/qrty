# Registry-Based QR Type System Architecture

## Overview

The QR generation feature uses a **registry-based architecture** to manage different QR code types. This design pattern achieves full **Open/Closed Principle (OCP)** compliance - open for extension (adding new QR types) but closed for modification (no changes to existing core code).

## Architecture Components

### 1. Core Abstractions

#### QrFormDataBase (`lib/core/models/qr_form_data/qr_form_data_base.dart`)
Abstract base class for type-safe form data models:
- `toMap()`: Serialize to Map for state management
- `validate()`: Embedded validation logic
- `isValid`: Boolean validation check

#### QrTypeDefinition (`lib/core/qr_types/qr_type_definition.dart`)
Protocol that each QR type implements:
- `type`: Enum identifier
- `displayName`: Localized UI name
- `icon`: Asset path for icon
- `buildForm()`: Creates form widget
- `generateQrData()`: Converts form data to QR string
- `validateData()`: Validates form data

### 2. Central Registry

#### QrTypeRegistry (`lib/core/qr_types/qr_type_registry.dart`)
Singleton that manages all QR type definitions:
- **Registration**: `_registerTypes()` called once at initialization
- **Lookup**: `getDefinition(type)` retrieves definition by enum
- **Delegation**: All operations (validation, generation, forms) delegated to type definitions
- **Supported Types**: 12 QR types registered (100% coverage)

**Registered Types:**
- **Phase 1 (Simple)**: Text, URL, Email
- **Phase 2 (Social/Basic)**: Phone, SMS, Location, Twitter, Instagram
- **Phase 3 (Complex)**: WiFi, vCard, Business, Event

### 3. Type Definitions

Each QR type has two files:

#### Form Data Model (`lib/core/models/qr_form_data/`)
Type-safe immutable data class with:
- Field declarations
- Validation logic (embedded)
- Serialization (toMap/fromMap)

Example: `WifiQrFormData`
```dart
class WifiQrFormData extends QrFormDataBase {
  final String ssid;
  final String password;
  final String security; // 'WPA', 'WEP', 'Open'
  final bool hidden;
  
  @override
  Map<String, String> validate() {
    // Security-specific validation
    // Password required for WPA/WEP
  }
}
```

#### Type Definition (`lib/core/qr_types/definitions/`)
Implementation of QrTypeDefinition protocol:
- Maps enum to form screen
- Delegates to existing generators (WiFiGenerator, VCardGenerator, etc.)
- Handles type-specific parsing (security enums, date formats, etc.)

Example: `WifiQrDefinition`
```dart
class WifiQrDefinition extends QrTypeDefinition<WifiQrFormData> {
  @override
  String generateQrData(WifiQrFormData formData) {
    return WiFiGenerator.generateWiFi(
      ssid: formData.ssid,
      password: formData.password,
      security: _parseSecurityType(formData.security),
      hidden: formData.hidden,
    );
  }
}
```

### 4. Thin Wrapper Classes

These classes provide backward compatibility and cleaner API:

#### QrFormScreenFactory (`lib/feature/generate_qr/utils/qr_form_screen_factory.dart`)
- `createFormScreen(type)`: Returns form widget via registry
- `getDisplayName(type)`: Returns localized name via registry

#### TypeIcon (`lib/core/utils/type_icon.dart`)
- `typeIcon(type)`: Returns asset path via registry

#### QrContentGenerator (`lib/core/utils/qr_content_generator.dart`)
- `generateQrData(type, formData)`: Delegates to registry
- `validateFormData(type, formData)`: Delegates to registry

**Purpose**: These wrappers maintain existing API contracts while delegating all logic to the registry.

## Design Patterns

### Registry Pattern
- **Single source of truth** for QR type metadata
- **Centralized management** of type definitions
- **Runtime lookup** by enum key

### Strategy Pattern
- Each QR type is a **pluggable strategy**
- **Interchangeable** implementations of QrTypeDefinition
- **Behavior selection** based on runtime type

### Template Method Pattern
- QrTypeDefinition defines **abstract template**
- Concrete definitions **fill in specific steps**
- Common workflow with **type-specific customization**

## Benefits

### Maintainability
✅ **Single responsibility**: Each type in its own files  
✅ **Type safety**: Compile-time checking with form data models  
✅ **Testability**: Each component independently testable  
✅ **Locality**: All type logic in 2 adjacent files  

### Extensibility
✅ **No switch statements** to update  
✅ **Plugin-like architecture** - types can be added/removed  
✅ **Zero core modifications** for new types  
✅ **Safe refactoring** - changes isolated to one type  

### OO Design Principles
✅ **Open/Closed**: Add types without modifying existing code  
✅ **Single Responsibility**: One class, one reason to change  
✅ **Dependency Inversion**: Depend on QrTypeDefinition abstraction  
✅ **Interface Segregation**: Clean, focused interfaces  
✅ **DRY**: No duplication across switch statements  

## How to Add a New QR Type

### Step 1: Add Enum Value
```dart
// lib/core/enums/qr_code_type_enum.dart
enum QRCodeType {
  // ... existing types
  linkedin,
}
```

### Step 2: Create Form Data Model
```dart
// lib/core/models/qr_form_data/linkedin_qr_form_data.dart
class LinkedInQrFormData extends QrFormDataBase {
  final String profileUrl;
  
  const LinkedInQrFormData({required this.profileUrl});
  
  @override
  Map<String, String> toMap() => {'profileUrl': profileUrl};
  
  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (profileUrl.trim().isEmpty) {
      errors['profileUrl'] = 'Profile URL is required';
    }
    return errors;
  }
  
  factory LinkedInQrFormData.fromMap(Map<String, String> map) {
    return LinkedInQrFormData(profileUrl: map['profileUrl'] ?? '');
  }
}
```

### Step 3: Create Type Definition
```dart
// lib/core/qr_types/definitions/linkedin_qr_definition.dart
class LinkedInQrDefinition extends QrTypeDefinition<LinkedInQrFormData> {
  @override
  QRCodeType get type => QRCodeType.linkedin;
  
  @override
  String get displayName => LocaleKeys.linkedin.tr();
  
  @override
  String get icon => AppAssets.linkedin;
  
  @override
  Widget buildForm(BuildContext context) {
    return const LinkedInQrFormScreen();
  }
  
  @override
  String generateQrData(LinkedInQrFormData formData) {
    return formData.profileUrl; // Or format as needed
  }
  
  @override
  Map<String, String> validateData(LinkedInQrFormData formData) {
    return formData.validate();
  }
  
  @override
  LinkedInQrFormData fromMap(Map<String, String> map) {
    return LinkedInQrFormData.fromMap(map);
  }
}
```

### Step 4: Register in Registry
```dart
// lib/core/qr_types/qr_type_registry.dart
void _registerTypes() {
  // ... existing registrations
  _register(LinkedInQrDefinition());
}
```

### Step 5: Create Form Screen (Optional)
```dart
// lib/feature/generate_qr/view/forms/simple/linkedin_qr_form_screen.dart
class LinkedInQrFormScreen extends StatelessWidget {
  // Standard form implementation
}
```

**That's it!** The new type automatically works with:
- Form screen factory
- QR generation
- Validation
- Type grid display
- Icon mapping
- All existing UI/state management

## Testing Strategy

### Unit Tests (`test/registry_test.dart`)
- **Registration**: All 12 types registered
- **Type Support**: `isSupported()` for all types
- **Validation**: 40+ tests covering all form data validation rules
- **Generation**: QR data generation for all types
- **Display Names**: Localization integration
- **Icons**: Asset path mapping

### Example Test
```dart
test('should validate WiFi with WPA security', () {
  final result = registry.validateData(QRCodeType.wifi, {
    'ssid': 'MyNetwork',
    'password': 'password123',
    'security': 'WPA',
  });
  
  expect(result, isEmpty);
});
```

## Migration History

### Phase 1: Foundation + Simple Types (Complete)
- Created base classes and registry
- Implemented Text, URL, Email definitions
- Updated cubit for backward compatibility

### Phase 2: Social/Basic Types (Complete)
- Migrated Phone, SMS, Twitter, Instagram, Location
- Validated patterns work consistently
- Tested with existing form screens

### Phase 3: Complex Types (Complete)
- Migrated WiFi, vCard, Business, Event
- Handled complex forms (dropdowns, multi-field, date pickers)
- Integrated with existing generators

### Phase 4: Cleanup (Complete)
- Removed all switch statements from factory classes
- Simplified TypeIcon, QrContentGenerator, QrFormScreenFactory
- Updated QrTypeItem to use registry
- All 55 tests passing

## Performance

- **Registry initialization**: One-time at app startup
- **Lookup cost**: O(1) hash map lookup (equivalent to switch)
- **Memory overhead**: Negligible (~12 singleton instances)
- **No performance degradation** vs. switch statements

## Future Enhancements

### Form Field Builders (Optional)
Consider declarative form field definitions:
```dart
abstract class QrTypeDefinition<T> {
  List<FormFieldDefinition> get fields;
}
```

This would reduce boilerplate for complex forms by defining fields declaratively rather than imperatively building widgets.

### Dynamic Type Loading (Future)
The registry pattern supports:
- Loading types from plugins
- Enabling/disabling types at runtime
- Feature flags for A/B testing
- Third-party type extensions

## Conclusion

The registry-based architecture provides a **clean, maintainable, and extensible** solution for managing QR types. By eliminating switch statements and using the **Strategy + Registry** patterns, we achieve true OCP compliance while maintaining type safety and testability.

**Key Achievement**: Adding a new QR type requires creating just 2 files and 1 registration line - no modifications to existing code.
