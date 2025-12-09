# Plan: QR Scanner Feature

Implement a QR scanning feature using `mobile_scanner` package with clean architecture and responsive UI following the design mockups.

## Steps

1. **Build Scan QR Screen UI**
   - Implement `scan_qr_screen.dart` (lib/feature/scan_qr/view/scan_qr_screen.dart)
     - MobileScanner widget with custom overlay
     - Yellow corner brackets using CustomPaint
     - Top control bar with gallery/flash/settings icons
     - Zoom slider at bottom
     - Bottom nav bar

2. **Create QR View Screen Module (Shared)**
   - Build `qr_view_screen.dart` (lib/feature/qr_view/view/qr_view_screen.dart)
     - **Shared module** accessible from both scan and generate features
     - Two view modes in single screen (toggled via "Show QR Code" button):
       - **Text Data View**:
         - Display QR data with icon
         - Show timestamp
         - Action buttons (Share/Copy)
       - **QR Code View**:
         - Show generated QR from data using qr_flutter
         - Action buttons (Share/Save)
         - Responsive rounded border
     - Use responsive sizing with context.wp() and context.sp()
     - Smooth transition between views
     - Accept parameters: data, timestamp, source (scan/generate)

3. **Add State Management & Business Logic**
   - Create `scan_qr_cubit.dart` (lib/feature/scan_qr/cubit/scan_qr_cubit.dart)
     - Manage scanner state (flash, camera, zoom)
     - Handle barcode detection
     - Navigate to qr_view screen with scanned data
   - Create `qr_view_cubit.dart` (lib/feature/qr_view/cubit/qr_view_cubit.dart)
     - Toggle between text/QR code view
     - Implement copy/share functionality
     - Handle save to gallery/storage
     - Handle save to gallery/storage

4. **Update Routes & Translations**ib/core/routes/routes.dart)
     - scanQr, qrView
   - Configure in `app_router.dart` (lib/core/routes/app_router.dart)
     - Pass data, timestamp, and source as route arguments
   - Add missing translation keys to translation files
     - data, show_qr_code, qr_code
     - data, show_qr_code, qr_code

## Further Considerations

1. **Camera Permissions**sions gracefully
   - Permission requests and error states for denied/restricted access

