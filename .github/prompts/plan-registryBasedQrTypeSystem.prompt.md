# Plan: Registry-Based QR Type System with Strong Typing

Refactor the generate QR feature to use a registry-based architecture with typed form data models, eliminating switch statements and making new QR types a single configuration entry. This achieves full OCP compliance while maintaining existing BLoC patterns.

## Steps

### 1. Create typed form data models

Define immutable data classes in `lib/core/models/qr_form_data` for each QR type (e.g., `TextQrFormData`, `WifiQrFormData`, `VCardQrFormData`) extending abstract `QrFormDataBase` with `toMap()`, `fromMap()`, and `validate()` methods.

**Files to create:**
- `lib/core/models/qr_form_data/qr_form_data_base.dart` - Abstract base class
- `lib/core/models/qr_form_data/text_qr_form_data.dart`
- `lib/core/models/qr_form_data/url_qr_form_data.dart`
- `lib/core/models/qr_form_data/email_qr_form_data.dart`
- `lib/core/models/qr_form_data/phone_qr_form_data.dart`
- `lib/core/models/qr_form_data/sms_qr_form_data.dart`
- `lib/core/models/qr_form_data/wifi_qr_form_data.dart`
- `lib/core/models/qr_form_data/vcard_qr_form_data.dart`
- `lib/core/models/qr_form_data/business_qr_form_data.dart`
- `lib/core/models/qr_form_data/event_qr_form_data.dart`
- `lib/core/models/qr_form_data/location_qr_form_data.dart`
- `lib/core/models/qr_form_data/twitter_qr_form_data.dart`
- `lib/core/models/qr_form_data/instagram_qr_form_data.dart`

**Example structure:**
```dart
abstract class QrFormDataBase {
  const QrFormDataBase();
  
  /// Convert to map for state management
  Map<String, String> toMap();
  
  /// Validate data and return errors
  Map<String, String> validate();
  
  /// Check if data is valid
  bool get isValid => validate().isEmpty;
}

class TextQrFormData extends QrFormDataBase {
  final String text;
  
  const TextQrFormData({required this.text});
  
  factory TextQrFormData.fromMap(Map<String, String> map) {
    return TextQrFormData(text: map['text'] ?? '');
  }
  
  @override
  Map<String, String> toMap() => {'text': text};
  
  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    if (text.trim().isEmpty) {
      errors['text'] = 'Text is required';
    }
    return errors;
  }
}
```

### 2. Implement QR type definition protocol

Create `lib/core/qr_types/qr_type_definition.dart` with abstract `QrTypeDefinition<T extends QrFormDataBase>` class containing `displayName`, `icon`, `buildForm()`, `generateQrData()`, and `validateData()`. Each QR type gets a concrete implementation in `lib/core/qr_types/definitions`.

**Files to create:**
- `lib/core/qr_types/qr_type_definition.dart` - Abstract base class
- `lib/core/qr_types/definitions/text_qr_definition.dart`
- `lib/core/qr_types/definitions/url_qr_definition.dart`
- `lib/core/qr_types/definitions/email_qr_definition.dart`
- `lib/core/qr_types/definitions/phone_qr_definition.dart`
- `lib/core/qr_types/definitions/sms_qr_definition.dart`
- `lib/core/qr_types/definitions/wifi_qr_definition.dart`
- `lib/core/qr_types/definitions/vcard_qr_definition.dart`
- `lib/core/qr_types/definitions/business_qr_definition.dart`
- `lib/core/qr_types/definitions/event_qr_definition.dart`
- `lib/core/qr_types/definitions/location_qr_definition.dart`
- `lib/core/qr_types/definitions/twitter_qr_definition.dart`
- `lib/core/qr_types/definitions/instagram_qr_definition.dart`

**Example structure:**
```dart
abstract class QrTypeDefinition<T extends QrFormDataBase> {
  /// QR type enum value
  QRCodeType get type;
  
  /// Display name for UI (localized)
  String get displayName;
  
  /// Asset path for icon
  String get icon;
  
  /// Create empty form data
  T createEmpty();
  
  /// Create form data from map
  T fromMap(Map<String, String> map);
  
  /// Build form widget for this type
  Widget buildForm(BuildContext context);
  
  /// Generate QR code data string from form data
  String generateQrData(T formData);
  
  /// Validate form data
  Map<String, String> validateData(T formData);
}

class TextQrDefinition extends QrTypeDefinition<TextQrFormData> {
  @override
  QRCodeType get type => QRCodeType.text;
  
  @override
  String get displayName => LocaleKeys.text.tr();
  
  @override
  String get icon => AppAssets.text;
  
  @override
  TextQrFormData createEmpty() => const TextQrFormData(text: '');
  
  @override
  TextQrFormData fromMap(Map<String, String> map) {
    return TextQrFormData.fromMap(map);
  }
  
  @override
  Widget buildForm(BuildContext context) {
    return TextQrFormScreen();
  }
  
  @override
  String generateQrData(TextQrFormData formData) {
    return formData.text;
  }
  
  @override
  Map<String, String> validateData(TextQrFormData formData) {
    return formData.validate();
  }
}
```

### 3. Build centralized registry

Create `lib/core/qr_types/qr_type_registry.dart` with singleton `QrTypeRegistry` holding `Map<QRCodeType, QrTypeDefinition>`. Replace all switch statements in `QrFormScreenFactory`, `QrContentGenerator`, and `TypeIcon` with registry lookups.

**Files to create:**
- `lib/core/qr_types/qr_type_registry.dart`

**Example structure:**
```dart
class QrTypeRegistry {
  static final QrTypeRegistry _instance = QrTypeRegistry._internal();
  factory QrTypeRegistry() => _instance;
  QrTypeRegistry._internal() {
    _registerTypes();
  }
  
  final Map<QRCodeType, QrTypeDefinition> _registry = {};
  
  void _registerTypes() {
    _register(TextQrDefinition());
    _register(UrlQrDefinition());
    _register(EmailQrDefinition());
    _register(PhoneQrDefinition());
    _register(SmsQrDefinition());
    _register(WifiQrDefinition());
    _register(VCardQrDefinition());
    _register(BusinessQrDefinition());
    _register(EventQrDefinition());
    _register(LocationQrDefinition());
    _register(TwitterQrDefinition());
    _register(InstagramQrDefinition());
  }
  
  void _register(QrTypeDefinition definition) {
    _registry[definition.type] = definition;
  }
  
  QrTypeDefinition? getDefinition(QRCodeType type) {
    return _registry[type];
  }
  
  List<QRCodeType> get supportedTypes => _registry.keys.toList();
  
  String getDisplayName(QRCodeType type) {
    return _registry[type]?.displayName ?? '';
  }
  
  String getIcon(QRCodeType type) {
    return _registry[type]?.icon ?? '';
  }
  
  Widget? buildForm(QRCodeType type, BuildContext context) {
    return _registry[type]?.buildForm(context);
  }
  
  String generateQrData(QRCodeType type, Map<String, String> formDataMap) {
    final definition = _registry[type];
    if (definition == null) throw Exception('Unknown QR type: $type');
    
    final formData = definition.fromMap(formDataMap);
    return definition.generateQrData(formData);
  }
  
  Map<String, String> validateData(QRCodeType type, Map<String, String> formDataMap) {
    final definition = _registry[type];
    if (definition == null) return {'error': 'Unknown QR type'};
    
    final formData = definition.fromMap(formDataMap);
    return definition.validateData(formData);
  }
}
```

**Usage in existing files:**
```dart
// QrFormScreenFactory becomes:
class QrFormScreenFactory {
  static final _registry = QrTypeRegistry();
  
  static Widget? createFormScreen(QRCodeType type, BuildContext context) {
    return _registry.buildForm(type, context);
  }
  
  static String getDisplayName(QRCodeType type) {
    return _registry.getDisplayName(type);
  }
}

// TypeIcon becomes:
abstract class TypeIcon {
  static final _registry = QrTypeRegistry();
  
  static String typeIcon(QRCodeType type) {
    return _registry.getIcon(type);
  }
}

// QrContentGenerator becomes:
class QrContentGenerator {
  static final _registry = QrTypeRegistry();
  
  static String generateQrData(QRCodeType type, Map<String, String> formData) {
    return _registry.generateQrData(type, formData);
  }
  
  static Map<String, String> validateFormData(QRCodeType type, Map<String, String> formData) {
    return _registry.validateData(type, formData);
  }
}
```

### 4. Update state management

Modify `GenerateQrState` to use `QrFormDataBase?` instead of `Map<String, String>`, update `GenerateQrCubit` methods to work with typed data, and refactor `BaseQrFormScreen` to accept `QrTypeDefinition` and build forms generically.

**Files to modify:**
- `lib/feature/generate_qr/cubit/generate_qr_state.dart`
- `lib/feature/generate_qr/cubit/generate_qr_cubit.dart`
- `lib/feature/generate_qr/widgets/base_qr_form_screen.dart`

**Key changes:**

```dart
// GenerateQrState
class GenerateQrState extends Equatable {
  final GenerateQrStatus status;
  final QRCodeType? selectedType;
  final String? generatedData;
  final Map<String, String> formData; // Keep for backward compatibility during migration
  final QrFormDataBase? typedFormData; // New typed data
  final Map<String, String?> formErrors;
  final String? errorMessage;
  
  // ... rest of implementation
}

// GenerateQrCubit
class GenerateQrCubit extends Cubit<GenerateQrState> {
  final _registry = QrTypeRegistry();
  
  // ... existing methods remain the same, validation/generation delegated to registry
}
```

### 5. Migrate existing QR types

Move validation logic from `QrContentGenerator` and generation from `qr_data_generators` into individual `QrTypeDefinition` implementations, update all 12 form screens to use new architecture, and register all types in the registry.

**Migration order:**
1. Simple types: Text, URL, Email, Phone (validate architecture)
2. Social types: Twitter, Instagram, SMS, Location (similar patterns)
3. Complex types: WiFi, vCard, Business, Event (test with complex forms)

**For each type:**
- Create `XxxQrFormData` class
- Create `XxxQrDefinition` class
- Move validation from `QrContentGenerator.validateFormData()` to form data model
- Move generation from `QrContentGenerator.generateQrData()` to definition
- Update form screen to use new architecture
- Test thoroughly

### 6. Remove deprecated code

Delete `QrFormScreenFactory`, `QrContentGenerator` switch methods, `TypeIcon` switch, and simplify `QrTypeGrid` to use registry for display names and icons.

**Files to delete/modify:**
- Simplify `lib/feature/generate_qr/utils/qr_form_screen_factory.dart` (keep as thin wrapper or delete)
- Remove switch methods from `lib/core/utils/qr_content_generator.dart`
- Remove switch from `lib/core/utils/type_icon.dart`
- Update `lib/feature/generate_qr/widgets/qr_type_grid.dart` to use registry

## Further Considerations

### 1. Form field builders

Consider creating a `FormFieldBuilder` interface that QR type definitions can use to declaratively define fields (e.g., `TextFieldDef`, `DropdownFieldDef`, `SwitchFieldDef`) reducing boilerplate in form screens. This would make complex forms like WiFi and Event more maintainable.

**Example:**
```dart
abstract class FormFieldDefinition {
  String get fieldName;
  String get label;
  String get hint;
  bool get isRequired;
  Widget build(BuildContext context, GenerateQrCubit cubit, GenerateQrState state);
}

class TextFieldDefinition extends FormFieldDefinition {
  @override
  final String fieldName;
  @override
  final String label;
  @override
  final String hint;
  @override
  final bool isRequired;
  final TextInputType keyboardType;
  final int maxLines;
  
  // ... implementation
}

// In QrTypeDefinition:
abstract class QrTypeDefinition<T extends QrFormDataBase> {
  List<FormFieldDefinition> get fields;
  
  Widget buildForm(BuildContext context) {
    return GenericQrFormScreen(definition: this);
  }
}
```

### 2. Validation approach

Choose between embedded validation in form data models (single source of truth, easier to test) vs. keeping it in QrTypeDefinition (better separation of concerns). Recommend embedded with `Result<T, ValidationError>` pattern for clarity.

**Recommended: Embedded validation in form data models**
- Single source of truth
- Easier to unit test
- Immutable form data enforces consistency
- Validation errors are part of the model

**Alternative: Validation in QrTypeDefinition**
- Better separation of concerns
- Validation logic closer to business rules
- Easier to swap validation strategies

### 3. Migration strategy

Start with 2-3 simple types (Text, URL, Email) to validate the new architecture, then migrate complex types (WiFi, vCard, Event), then remove old code. This minimizes risk and allows rollback if issues arise.

**Phase 1: Foundation (Week 1)**
- Create base classes and registry
- Implement Text, URL, Email definitions
- Update cubit to support both old and new approaches
- Test thoroughly

**Phase 2: Simple types (Week 2)**
- Migrate Phone, SMS, Twitter, Instagram, Location
- Validate patterns work consistently
- Refine base classes if needed

**Phase 3: Complex types (Week 3)**
- Migrate WiFi, vCard, Business, Event
- Handle complex form fields (dropdowns, date pickers, switches)
- Consider form field builder pattern if too much duplication

**Phase 4: Cleanup (Week 4)**
- Remove old switch-based code
- Remove backward compatibility layers
- Update documentation
- Final testing

## Benefits of This Approach

### Maintainability
- **Single source of truth** for each QR type
- **Type-safe** form data eliminates string-key mismatches
- **Centralized** validation logic per type
- **Testable** - each definition can be unit tested independently

### Flexibility
- Easy to **modify existing types** without touching other code
- **Swap implementations** without changing consumers
- **Add validation rules** in one place
- **Change generation logic** without affecting UI

### Extensibility
- **Add new QR type** in ~3 files (model, definition, registration)
- **No switch statements** to update
- **No risk** of forgetting to update a switch case
- **Plugin-like architecture** - types can be added/removed easily

### OO Design Principles
- **Open/Closed Principle** - Open for extension (add new types), closed for modification (no changes to existing code)
- **Single Responsibility** - Each class has one reason to change
- **Dependency Inversion** - Depend on abstractions (QrTypeDefinition) not concrete types
- **Interface Segregation** - Clients only know about QrTypeDefinition interface
- **DRY** - No duplication across switch statements

## Example: Adding a New QR Type

To add a new "LinkedIn" QR type:

1. Add enum value to `QRCodeType.linkedin`
2. Create `lib/core/models/qr_form_data/linkedin_qr_form_data.dart`:
   ```dart
   class LinkedInQrFormData extends QrFormDataBase {
     final String profileUrl;
     // ... implementation
   }
   ```
3. Create `lib/core/qr_types/definitions/linkedin_qr_definition.dart`:
   ```dart
   class LinkedInQrDefinition extends QrTypeDefinition<LinkedInQrFormData> {
     // ... implementation
   }
   ```
4. Register in `QrTypeRegistry._registerTypes()`:
   ```dart
   _register(LinkedInQrDefinition());
   ```

**That's it!** No other files need to be touched. The new type automatically works with:
- Form screen factory
- QR generation
- Validation
- Type grid display
- Icon mapping
- All existing UI/state management

## Testing Strategy

### Unit Tests
- Test each `QrFormData.validate()` method
- Test each `QrTypeDefinition.generateQrData()` method
- Test registry registration and lookup
- Test form data `toMap()` / `fromMap()` serialization

### Integration Tests
- Test cubit with new typed data
- Test form screen generation for each type
- Test end-to-end QR generation flow
- Test error handling and validation display

### Widget Tests
- Test form screens render correctly
- Test validation errors display properly
- Test form field interactions
- Test generate button enablement logic

## Performance Considerations

- Registry initialization happens once at app startup
- No performance impact from registry lookups vs. switch statements
- Typed form data reduces runtime errors
- Validation happens on-demand, not continuously

## Backward Compatibility

During migration, keep both systems running:
- Old switch-based code for unmigrated types
- New registry-based code for migrated types
- Gradually migrate types one by one
- Remove old code only after all types migrated and tested

## Documentation Needs

- Architecture decision record (ADR) for registry pattern
- Developer guide: "How to add a new QR type"
- Update inline documentation
- Add examples for common patterns
- Document migration notes for team
