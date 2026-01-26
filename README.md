# QRTY - Ultimate QR Code Manager

QRTY is a comprehensive and modern Flutter application designed to handle all your QR code needs. Whether you need to scan a code instantly, generate a new one for your business, or keep a history of your interactions, QRTY provides a seamless and efficient experience.

## 🚀 Why QRTY?

QRTY combines performance with a user-friendly interface to offer the best QR code management experience on mobile.

*   **⚡ Instant Scanning**: Built with `mobile_scanner` for lightning-fast QR code detection.
*   **🛠️ Versatile Generation**: Create QR codes for various data types using `qr_flutter`.
*   **💾 Local History**: Never lose a code again. All scans and generations are saved locally using the high-performance `ObjectBox` database.
*   **🌍 Global Ready**: Fully localized with `easy_localization` to support multiple languages.
*   **🎨 Beautiful Design**: Features a polished UI with `animated_bottom_navigation_bar` and smooth transitions.
*   **⚙️ Customizable Experience**: Toggle vibration, sound effects, and manage app preferences easily.

## 📸 App UI

![QRTY App UI](assets/images/qrty_showcase.png)

## 🎨 Design Credit

The UI design of this application is based on the work of **Atif Nadeem**.
[View the design on Figma](https://www.figma.com/community/file/1214837612730924876)

## 📂 Folder Structure

The project follows MVVM approach, separating concerns for better maintainability

```
lib/
├── core/                             # Shared resources and utilities
│   ├── common/
│   │   └── widgets/                 # Shared UI components
│   │       ├── app_background.dart  # App background widget
│   │       └── fab.dart             # Floating action button
│   ├── constants/
│   │   ├── app_assets.dart          # Asset paths and constants
│   │   ├── app_colors.dart          # Color palette
│   │   └── app_dimensions.dart      # Spacing and sizing
│   ├── dialogs/
│   │   └── app_dialogs.dart         # Reusable dialog components
│   ├── enums/
│   │   └── qr_code_type_enum.dart   # QR code type enumeration
│   ├── extensions/
│   │   ├── media_query_extensions.dart  # Responsive sizing (wp, hp, sp)
│   │   ├── navigator_extensions.dart    # Navigation helpers
│   │   └── string_extensions.dart       # String utilities
│   ├── models/
│   │   ├── qr_history_entity.dart   # ObjectBox history entity
│   │   └── settings_model.dart      # Settings data model
│   ├── routes/
│   │   ├── animation_route.dart     # Custom route animations
│   │   ├── app_router.dart          # Central routing configuration
│   │   └── routes.dart              # Route name constants
│   ├── services/
│   │   ├── feedback_service.dart    # Vibration and audio feedback
│   │   ├── preferences_service.dart # First-launch preferences
│   │   └── settings_service.dart    # App settings persistence
│   ├── storage/
│   │   └── objectbox_service.dart   # ObjectBox database service
│   ├── theme/
│   │   ├── app_colors.dart          # App color theme
│   │   └── app_text_styles.dart     # Text styling
│   └── utils/
│       ├── history_helper.dart      # History save helpers
│       ├── qr_code_image_generator.dart  # QR image generation
│       ├── qr_code_type_detector.dart    # QR type detection
│       ├── qr_content_generator.dart     # QR content creation
│       └── qr_text_formatter.dart        # QR data formatting
├── feature/                          # Feature-based modules
│   ├── app_section/
│   │   └── view/
│   │       └── app_section.dart     # Main app container with bottom nav
│   ├── generate_qr/                 # QR Generation feature (MVVM)
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── generate_service.dart  # Business logic for generation
│   │   ├── view/
│   │   │   ├── forms/               # Dynamic form screens per QR type
│   │   │   ├── widgets/             # Generation UI components
│   │   │   └── generate_qr_screen.dart  # Main generation screen
│   │   └── view_model/
│   │       ├── generate_qr_cubit.dart    # State management
│   │       └── generate_qr_state.dart    # State definition
│   ├── history/                     # History management
│   │   ├── cubit/
│   │   │   ├── history_cubit.dart   # History state management
│   │   │   └── history_state.dart   # History state definition
│   │   ├── view/
│   │   │   └── history_screen.dart  # History display screen
│   │   └── widgets/
│   │       ├── empty_history_state.dart  # Empty state widget
│   │       ├── history_item.dart         # History list item
│   │       └── scan_create_tabs.dart     # Tab switcher
│   ├── qr_view/                     # QR display feature (MVVM)
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── view_service.dart     # QR view business logic
│   │   ├── view/
│   │   │   ├── widgets/             # QR view components
│   │   │   └── qr_view_screen.dart  # QR result display
│   │   └── view_model/
│   │       ├── qr_view_cubit.dart   # View state management
│   │       └── qr_view_state.dart   # View state definition
│   ├── scan_qr/                     # QR Scanning feature (MVVM)
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── scan_service.dart     # Scanner business logic
│   │   ├── view/
│   │   │   ├── widgets/             # Scanner UI components
│   │   │   └── scan_qr_screen.dart  # Camera scanner screen
│   │   └── view_model/
│   │       ├── scan_qr_cubit.dart   # Scanner state management
│   │       └── scan_qr_state.dart   # Scanner state definition
│   ├── settings/                    # App settings
│   │   ├── cubit/
│   │   │   ├── settings_cubit.dart  # Settings state management
│   │   │   └── settings_state.dart  # Settings state definition
│   │   ├── view/
│   │   │   └── settings_screen.dart # Settings UI
│   │   └── widgets/
│   │       ├── settings_navigation_item.dart  # Navigation items
│   │       ├── settings_section_header.dart   # Section headers
│   │       └── settings_toggle_item.dart      # Toggle switches
│   └── splash/
│       └── splash_screen.dart       # Splash screen with first-launch logic
├── l10n/                             # Localization
│   └── locale_keys.g.dart           # Generated translation keys
└── main.dart                         # Application entry point
```

## 🛠️ Technologies Used

This project leverages a robust stack of Flutter packages and tools:

*   **Framework**: [Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)
*   **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (BLoC Pattern)
*   **Database**: [objectbox](https://pub.dev/packages/objectbox) (High-performance NoSQL database)
*   **Scanning**: [mobile_scanner](https://pub.dev/packages/mobile_scanner)
*   **Generation**: [qr_flutter](https://pub.dev/packages/qr_flutter)
*   **Localization**: [easy_localization](https://pub.dev/packages/easy_localization)
*   **Navigation**: Custom Route Generation with Animations
*   **Utilities**: `share_plus`, `url_launcher`, `image_gallery_saver_plus`, `vibration`, `audioplayers`

## 🔄 GitHub Workflow

We follow a structured workflow to ensure code quality and stability:

1.  **`main` Branch**: The stable production-ready code.
2.  **Feature Branches**: New features are developed in separate branches (e.g., `feature/new-scanner`).
3.  **Refactor Branches**: Code improvements and architectural changes (e.g., `refactor/mvvm`).
4.  **Pull Requests**: All changes are reviewed via Pull Requests before merging into `main`.

## 🧠 Skills Learned

Building QRTY involved mastering several key software engineering concepts:

*   **MVVM/BLoC Architecture**: Implementing a scalable and testable app architecture.
*   **Local Data Persistence**: integrating and managing a NoSQL database with ObjectBox.
*   **Hardware Integration**: Handling camera permissions and streams for scanning.
*   **Internationalization**: Setting up a robust localization system.
*   **State Management**: Managing complex app states efficiently with Cubits and Blocs.
*   **Testing**: Writing unit tests to ensure code quality and reliability.

## 🎥 Video Demo

*(Placeholder: Link to a video demonstration of the project in action)*

## 🏁 Getting Started

Follow these steps to run the project locally:

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
*   Android Studio or VS Code configured for Flutter development

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/Clark605/qrty.git
    cd qrty
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Generate code (for ObjectBox and Localization)**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app**
    ```bash
    flutter run
    ```

---
*Built with ❤️ by Clark605*
