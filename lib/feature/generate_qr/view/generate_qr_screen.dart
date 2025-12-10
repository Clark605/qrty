import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_type_grid.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class GenerateQrScreen extends StatelessWidget {
  const GenerateQrScreen({super.key});
  void _onQrTypeSelected(QRCodeType type) {
    // TODO: Navigate to individual QR form screens based on type
    // This will be implemented in later commits
    print('Selected QR type: $type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox.shrink(),
        title: Text(
          LocaleKeys.generate_qr.tr(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          // App Bar

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.hp(2)),

                  // QR Types Grid
                  QrTypeGrid(onTypeSelected: _onQrTypeSelected),

                  SizedBox(height: context.hp(4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
