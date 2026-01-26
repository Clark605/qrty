# How to Add a New QR Type

This guide walks you through adding a new QR code type to the qrty app. The entire process takes ~30-60 minutes and requires creating just 2-3 files.

## Prerequisites

- Basic understanding of Dart/Flutter
- Familiarity with the qrty codebase structure
- Access to design assets (icon SVG)

## Step-by-Step Guide

### 1. Define the Enum Value

Add your QR type to the `QRCodeType` enum:

**File**: `lib/core/enums/qr_code_type_enum.dart`

```dart
enum QRCodeType {
  text,
  url,
  // ... existing types
  yourNewType, // Add here
}
```

**Naming Convention**: Use `camelCase`, descriptive names (e.g., `linkedin`, `spotify`, `paymentLink`)

---

### 2. Add Localization Keys

Add display name translations for your type:

**File**: `assets/translations/en.json`
```json
{
  "yourNewType": "Your Type Name"
}
```

**File**: `assets/translations/ar.json`
```json
{
  "yourNewType": "اسم النوع الخاص بك"
}
```

Then regenerate localization files:
```bash
flutter pub run easy_localization:generate -S assets/translations -O lib/l10n -o locale_keys.g.dart -f keys
```

---

### 3. Add Icon Asset

Place your icon SVG in the assets directory:

**File**: `assets/icons/your_type.svg`

Add the constant:

**File**: `lib/core/constants/app_assets.dart`
```dart
class AppAssets {
  // ... existing icons
  static const String yourType = 'assets/icons/your_type.svg';
}
```

---

### 4. Create Form Data Model

Create a type-safe model for your form data:

**File**: `lib/core/models/qr_form_data/your_type_qr_form_data.dart`

```dart
import 'package:qrty/core/models/qr_form_data/qr_form_data_base.dart';

class YourTypeQrFormData extends QrFormDataBase {
  final String field1;
  final String field2;
  // Add all fields needed for your QR type

  const YourTypeQrFormData({
    required this.field1,
    this.field2 = '',
  });

  factory YourTypeQrFormData.fromMap(Map<String, String> map) {
    return YourTypeQrFormData(
      field1: map['field1'] ?? '',
      field2: map['field2'] ?? '',
    );
  }

  @override
  Map<String, String> toMap() {
    return {
      'field1': field1,
      'field2': field2,
    };
  }

  @override
  Map<String, String> validate() {
    final errors = <String, String>{};
    
    // Add validation rules
    if (field1.trim().isEmpty) {
      errors['field1'] = 'Field 1 is required';
    }
    
    // Add more validation as needed
    
    return errors;
  }
}
```

**Tips**:
- Keep fields immutable (`final`)
- Provide sensible defaults
- Include all validation logic here (single source of truth)
- Use existing validators from `lib/core/utils/qr_data_generators/` when appropriate

---

### 5. Create Type Definition

Implement the QR type definition protocol:

**File**: `lib/core/qr_types/definitions/your_type_qr_definition.dart`

```dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/models/qr_form_data/your_type_qr_form_data.dart';
import 'package:qrty/core/qr_types/qr_type_definition.dart';
import 'package:qrty/l10n/locale_keys.g.dart';
import 'package:qrty/feature/generate_qr/view/forms/simple/your_type_qr_form_screen.dart';

class YourTypeQrDefinition extends QrTypeDefinition<YourTypeQrFormData> {
  @override
  QRCodeType get type => QRCodeType.yourNewType;

  @override
  String get displayName => LocaleKeys.yourNewType.tr();

  @override
  String get icon => AppAssets.yourType;

  @override
  Widget buildForm(BuildContext context) {
    return const YourTypeQrFormScreen();
  }

  @override
  String generateQrData(YourTypeQrFormData formData) {
    // Implement QR data generation
    // Example: Simple text format
    return formData.field1;
    
    // Or use existing generators:
    // return SomeGenerator.generate(formData.field1, formData.field2);
  }

  @override
  Map<String, String> validateData(YourTypeQrFormData formData) {
    return formData.validate();
  }

  @override
  YourTypeQrFormData fromMap(Map<String, String> map) {
    return YourTypeQrFormData.fromMap(map);
  }
}
```

**Key Points**:
- Reuse existing generators when possible (`VCardGenerator`, `WiFiGenerator`, etc.)
- Keep generation logic here, not in the form screen
- Delegate validation to the form data model

---

### 6. Register the Type

Add your type to the central registry:

**File**: `lib/core/qr_types/qr_type_registry.dart`

```dart
// Add import at top
import 'package:qrty/core/qr_types/definitions/your_type_qr_definition.dart';

class QrTypeRegistry {
  // ... existing code
  
  void _registerTypes() {
    // ... existing registrations
    _register(YourTypeQrDefinition());
  }
}
```

---

### 7. Create Form Screen

Create the UI form for your QR type:

**File**: `lib/feature/generate_qr/view/forms/simple/your_type_qr_form_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_form_field.dart';

class YourTypeQrFormScreen extends StatelessWidget {
  const YourTypeQrFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateQrCubit, GenerateQrState>(
      builder: (context, state) {
        final cubit = context.read<GenerateQrCubit>();
        
        return Column(
          children: [
            QrFormField(
              label: 'Field 1',
              hintText: 'Enter field 1',
              value: state.formData['field1'] ?? '',
              errorText: state.formErrors['field1'],
              onChanged: (value) => cubit.updateFormField('field1', value),
            ),
            
            QrFormField(
              label: 'Field 2',
              hintText: 'Enter field 2',
              value: state.formData['field2'] ?? '',
              errorText: state.formErrors['field2'],
              onChanged: (value) => cubit.updateFormField('field2', value),
            ),
            
            // Add more fields as needed
          ],
        );
      },
    );
  }
}
```

**Form Guidelines**:
- Use `QrFormField` widget for consistency
- Read state from `GenerateQrCubit`
- Use `updateFormField()` for field changes
- Display error messages from state
- Consider using `QrFormDropdown` for select fields
- Look at existing form screens for patterns

---

### 8. Add to Type Grid (Optional)

If you want your type to appear on the home screen:

**File**: `lib/feature/generate_qr/widgets/qr_type_grid.dart`

```dart
static const List<QRCodeType> _qrTypes = [
  // ... existing types
  QRCodeType.yourNewType, // Add here in desired order
];
```

---

### 9. Write Tests

Add comprehensive tests for your new type:

**File**: `test/registry_test.dart`

```dart
group('Your Type', () {
  test('should validate proper data', () {
    final result = registry.validateData(QRCodeType.yourNewType, {
      'field1': 'valid value',
    });
    
    expect(result, isEmpty);
  });
  
  test('should invalidate missing required field', () {
    final result = registry.validateData(QRCodeType.yourNewType, {
      'field1': '',
    });
    
    expect(result, isNotEmpty);
    expect(result['field1'], isNotNull);
  });
  
  test('should generate QR data', () {
    final result = registry.generateQrData(QRCodeType.yourNewType, {
      'field1': 'test data',
    });
    
    expect(result, equals('test data')); // Or expected format
  });
});
```

Run tests:
```bash
flutter test test/registry_test.dart
```

---

## Testing Your New Type

### 1. Unit Tests
```bash
flutter test test/registry_test.dart
```

### 2. Integration Test
1. Run the app: `flutter run`
2. Navigate to Generate QR screen
3. Select your new type from the grid
4. Fill out the form
5. Verify QR code generates correctly
6. Scan with QR reader to verify content

### 3. Edge Cases to Test
- Empty required fields
- Invalid format data
- Very long strings
- Special characters
- Unicode characters
- Maximum field lengths

---

## Common Patterns

### Using Existing Validators

```dart
import 'package:qrty/core/utils/qr_data_generators/url_validator.dart';

@override
Map<String, String> validate() {
  final errors = <String, String>{};
  
  if (!UrlValidator.isValid(field1)) {
    errors['field1'] = 'Please enter a valid URL';
  }
  
  return errors;
}
```

### Using Existing Generators

```dart
import 'package:qrty/core/utils/qr_data_generators/vcard_generator.dart';

@override
String generateQrData(YourTypeQrFormData formData) {
  return VCardGenerator.generateContact(
    firstName: formData.firstName,
    lastName: formData.lastName,
    // ...
  );
}
```

### Dropdown Fields

```dart
// In form data model
final String dropdownValue; // e.g., 'option1', 'option2'

// In form screen
QrFormDropdown(
  label: 'Select Option',
  value: state.formData['dropdownValue'] ?? 'option1',
  items: [
    DropdownItem(label: 'Option 1', value: 'option1'),
    DropdownItem(label: 'Option 2', value: 'option2'),
  ],
  onChanged: (value) => cubit.updateFormField('dropdownValue', value),
)
```

---

## Troubleshooting

### Type not appearing in grid
- Check that you added it to `_qrTypes` in `qr_type_grid.dart`
- Verify icon asset path is correct
- Check localization keys are generated

### Validation not working
- Ensure `validate()` returns errors map
- Check field names match between form data and form screen
- Verify cubit is calling `validateFormData()`

### QR generation fails
- Add error handling in `generateQrData()`
- Test with various input combinations
- Check existing generators for format requirements

### Icon not displaying
- Verify SVG file is valid
- Check asset path in `app_assets.dart`
- Ensure `pubspec.yaml` includes icons directory
- Run `flutter clean` and rebuild

---

## Best Practices

1. **Keep it simple**: Start with minimal fields, add complexity later
2. **Reuse existing code**: Use validators and generators when possible
3. **Test thoroughly**: Write tests before implementation
4. **Follow conventions**: Match naming patterns of existing types
5. **Document edge cases**: Comment unusual validation rules
6. **Consider UX**: Add helpful hints and error messages
7. **Validate early**: Client-side validation prevents bad QR codes

---

## Example: Adding a Spotify QR Type

```dart
// 1. Enum
enum QRCodeType { spotify }

// 2. Form Data
class SpotifyQrFormData extends QrFormDataBase {
  final String trackUrl;
  
  @override
  Map<String, String> validate() {
    if (!trackUrl.contains('spotify.com')) {
      return {'trackUrl': 'Must be a valid Spotify URL'};
    }
    return {};
  }
}

// 3. Type Definition
class SpotifyQrDefinition extends QrTypeDefinition<SpotifyQrFormData> {
  @override
  String generateQrData(SpotifyQrFormData formData) {
    return formData.trackUrl; // Spotify URLs scan directly
  }
}

// 4. Register
_register(SpotifyQrDefinition());
```

That's it! Your new Spotify QR type is ready to use.

---

## Summary

Adding a new QR type requires:
1. ✅ Enum value (1 line)
2. ✅ Form data model (~30 lines)
3. ✅ Type definition (~40 lines)
4. ✅ Form screen (~50 lines)
5. ✅ Registration (1 line)
6. ✅ Tests (~20 lines)

**Total**: ~150 lines of code, zero modifications to existing files (except registration).

## Questions?

Refer to existing types for patterns:
- **Simple**: `text_qr_definition.dart`
- **With validation**: `email_qr_definition.dart`
- **Complex form**: `wifi_qr_definition.dart`
- **Multi-field**: `vcard_qr_definition.dart`
