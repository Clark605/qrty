# Plan: Complete QR Generation Feature Implementation

Implement a comprehensive QR code generation system with type selection grid, individual form screens for each QR type, automatic database saving to create history, and seamless integration with existing QR view module.

## Commit Structure

### **Commit 1: Expand QR Type Enum and Assets**
Extend QR type support and add missing assets to match mockup requirements

**Files to modify:**
- `lib/core/enums/qr_code_type_enum.dart` - Add event, business, twitter, instagram types
- `assets/icons/` - Add missing `twitter.svg` icon
- `lib/core/utils/type_icon.dart` - Add icon mappings for new types
- `lib/core/utils/qr_text_formatter.dart` - Add formatting logic for new types

**Scope:** Foundation work to support all QR types shown in mockups

### **Commit 2: Create QR Generation State Management**
Build GenerateQrCubit and GenerateQrState following existing patterns

**Files to create:**
- `lib/feature/generate_qr/cubit/generate_qr_cubit.dart` - Main cubit for form state and QR generation
- `lib/feature/generate_qr/cubit/generate_qr_state.dart` - State classes for form data and validation

**Scope:** State management foundation for form handling and QR data generation

### **Commit 3: Build Main QR Type Selection Screen**
Create responsive grid layout with QR type cards using existing theming patterns

**Files to create:**
- `lib/feature/generate_qr/view/generate_qr_screen.dart` - Main type selection screen
- `lib/feature/generate_qr/widgets/qr_type_grid.dart` - Grid widget for QR types
- `lib/feature/generate_qr/widgets/qr_type_item.dart` - Individual QR type card widget

**Scope:** Main selection screen with navigation to form screens

### **Commit 4: Implement QR Data Generation Logic**
Build formatters and validators for all QR types

**Files to create:**
- `lib/core/utils/qr_data_generators/vcard_generator.dart` - Contact/Business vCard format
- `lib/core/utils/qr_data_generators/ical_generator.dart` - Event iCal format
- `lib/core/utils/qr_data_generators/wifi_generator.dart` - WiFi configuration string
- `lib/core/utils/qr_data_generators/url_validator.dart` - URL format validation
- `lib/core/utils/qr_data_generators/email_validator.dart` - Email format validation
- `lib/core/utils/qr_data_generators/phone_validator.dart` - Phone number validation
- `lib/core/utils/qr_content_generator.dart` - Unified generator that handles all types

**Scope:** Data generation and validation utilities for all QR types

### **Commit 5: Implement Simple QR Form Screens**
Create form screens for simple QR types (Text, Website, Email, Phone, WhatsApp, Twitter, Instagram)

**Files to create:**
- `lib/feature/generate_qr/screens/text_qr_screen.dart` - Simple text input
- `lib/feature/generate_qr/screens/website_qr_screen.dart` - URL input with validation
- `lib/feature/generate_qr/screens/email_qr_screen.dart` - Email input with validation
- `lib/feature/generate_qr/screens/telephone_qr_screen.dart` - Phone number input
- `lib/feature/generate_qr/screens/whatsapp_qr_screen.dart` - WhatsApp phone input
- `lib/feature/generate_qr/screens/twitter_qr_screen.dart` - Twitter handle input
- `lib/feature/generate_qr/screens/instagram_qr_screen.dart` - Instagram handle input
- `lib/feature/generate_qr/screens/location_qr_screen.dart` - Location input

**Scope:** Simple form screens with basic validation

### **Commit 6: Implement Complex QR Form Screens**
Create form screens for complex QR types (Wi-Fi, Contact, Business, Event)

**Files to create:**
- `lib/feature/generate_qr/screens/wifi_qr_screen.dart` - Network name, password, security type
- `lib/feature/generate_qr/screens/contact_qr_screen.dart` - Full contact form (name, company, phone, email, address)
- `lib/feature/generate_qr/screens/business_qr_screen.dart` - Business card form (company, industry, contact info)
- `lib/feature/generate_qr/screens/event_qr_screen.dart` - Event form (name, dates, location, description)

**Scope:** Complex form screens with multiple fields and advanced validation

### **Commit 7: Wire Navigation and History Saving**
Integrate QR generation with app navigation and history system

**Files to modify:**
- `lib/feature/app_section/view/app_section.dart` - Replace blue container with GenerateQrScreen
- `lib/core/routes/app_router.dart` - Add Routes.createQr implementation (if needed for individual forms)
- Form screens - Add HistoryHelper.saveCreatedQr() calls and navigation to QrView

**Scope:** Complete integration with existing app navigation and history system

## Steps (Original Plan Structure)

### 1. **Expand QR Type Enum and Assets**
Add missing QR types (event, business, twitter, instagram) to `QRCodeType` enum and missing `twitter.svg` icon to match mockup requirements

- Extend `lib/core/enums/qr_code_type_enum.dart` with missing types
- Add `twitter.svg` icon to `assets/icons/` directory
- Update `lib/core/utils/type_icon.dart` to handle new types
- Update `lib/core/utils/qr_text_formatter.dart` for new type formatting

### 2. **Create QR Generation State Management**
Build `GenerateQrCubit` and `GenerateQrState` following existing patterns for managing form data and generation logic

- Create `lib/feature/generate_qr/cubit/generate_qr_cubit.dart`
- Create `lib/feature/generate_qr/cubit/generate_qr_state.dart`
- Implement state management for form validation and QR data generation
- Follow existing cubit patterns from `scan_qr_cubit` and `history_cubit`

### 3. **Build Main QR Type Selection Screen**
Create responsive grid layout with QR type cards using existing icons and theming patterns

- Implement `lib/feature/generate_qr/view/generate_qr_screen.dart`
- Create `lib/feature/generate_qr/widgets/qr_type_grid.dart`
- Create `lib/feature/generate_qr/widgets/qr_type_item.dart`
- Use existing `AppBackground`, responsive extensions, and app theming
- Navigate to individual form screens on QR type selection

### 4. **Implement Individual QR Form Screens**
Create dedicated form screens for each QR type (Text, Website, Wi-Fi, Event, Contact, Business, etc.) with proper validation

#### Form Screens Structure:
```
lib/feature/generate_qr/screens/
├── text_qr_screen.dart
├── website_qr_screen.dart
├── wifi_qr_screen.dart
├── event_qr_screen.dart
├── contact_qr_screen.dart
├── business_qr_screen.dart
├── location_qr_screen.dart
├── whatsapp_qr_screen.dart
├── email_qr_screen.dart
├── twitter_qr_screen.dart
├── instagram_qr_screen.dart
└── telephone_qr_screen.dart
```

#### Form Field Requirements Based on Mockups:
- **Text**: Simple text input field
- **Website**: URL input with validation
- **Wi-Fi**: Network name, password, security type dropdown
- **Event**: Name, start/end date/time, location, description
- **Contact**: First/last name, company, job, phone, email, website, address, city, country
- **Business**: Company name, industry, phone, email, website, address, city, country
- **Location**: Location picker/input field
- **WhatsApp**: Phone number input
- **Email**: Email address input with validation
- **Twitter**: Twitter handle input
- **Instagram**: Instagram handle input
- **Telephone**: Phone number input with validation

### 5. **Integrate QR Data Generation Logic**
Build formatters for complex types (vCard, iCal, WiFi config) and validation for URLs, emails, phone numbers

- Create `lib/core/utils/qr_data_generators/` directory
- Implement data generators for each QR type:
  - `vcard_generator.dart` - Contact/Business vCard format
  - `ical_generator.dart` - Event iCal format
  - `wifi_generator.dart` - WiFi configuration string
  - `url_validator.dart` - URL format validation
  - `email_validator.dart` - Email format validation
  - `phone_validator.dart` - Phone number validation
- Create unified `lib/core/utils/qr_content_generator.dart` that handles all types

### 6. **Wire Navigation and History Saving**
Replace blue container placeholder in `app_section.dart`, add `createQr` route to app router, integrate `HistoryHelper.saveCreatedQr()` calls

- Replace `Container(color: Colors.blue)` in `lib/feature/app_section/view/app_section.dart`
- Add `Routes.createQr` implementation to `lib/core/routes/app_router.dart`
- Integrate `HistoryHelper.saveCreatedQr()` calls after successful QR generation
- Navigate to existing `QrView` screen with generated data and `source: 'create'`
- Update navigation flow: Type Selection → Form Screen → QR View Screen

## Technical Architecture

### State Management Flow:
1. **GenerateQrCubit** manages overall QR generation state
2. Individual form screens update cubit state
3. Validation occurs on form submission
4. QR data generation happens in cubit
5. Success triggers navigation to QR view + history save

### Navigation Flow:
```
App Section (Generate Tab) 
    ↓ 
Main QR Type Grid 
    ↓ 
Individual QR Form Screen 
    ↓ 
QR View Screen (shared with scan feature)
```

### Data Generation Standards:
- **vCard 3.0** for contacts and business cards
- **iCal format** for events  
- **WiFi Config String**: `WIFI:T:{security};S:{ssid};P:{password};;`
- **URL validation** with protocol checking
- **Email validation** with RFC 5322 compliance
- **Phone formatting** with international support

### Integration Points:
- Use existing `QrImageView` from qr_flutter package
- Leverage existing `HistoryHelper.saveCreatedQr()` method
- Navigate to shared `QrView` screen after generation
- Follow existing responsive design patterns with context extensions
- Use existing localization keys and add new ones as needed
- Maintain consistency with existing app theming and UI patterns

## Further Considerations

### Form Validation Strategy
- **Final validation** on "Generate QR Code" button press
- **Required field indicators** with visual feedback

### QR Data Format Standards
- **vCard 3.0** for maximum compatibility with QR scanners
- **iCal format** following RFC 5545 standard for events
- **WiFi configuration** following standard QR WiFi format
- **URL protocols** - auto-add https:// if missing
- **Social media formats** - proper URL generation for Twitter/Instagram


