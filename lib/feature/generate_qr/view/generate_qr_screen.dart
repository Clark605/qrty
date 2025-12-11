import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/feature/generate_qr/utils/qr_form_screen_factory.dart';
import 'package:qrty/feature/generate_qr/widgets/qr_type_grid.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class GenerateQrScreen extends StatelessWidget {
  const GenerateQrScreen({super.key});

  void _onQrTypeSelected(BuildContext context, QRCodeType type) {
    final cubit = context.read<GenerateQrCubit>();

    // Set the selected type in cubit
    cubit.selectQrType(type);

    // Check if form screen is available
    final formScreen = QrFormScreenFactory.createFormScreen(type);

    if (formScreen != null) {
      // Navigate to form screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BlocProvider.value(value: cubit, child: formScreen),
        ),
      );
    } else {
      // Show message for unimplemented forms
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${QrFormScreenFactory.getDisplayName(type)} form coming soon!',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
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
                  QrTypeGrid(
                    onTypeSelected: (type) => _onQrTypeSelected(context, type),
                  ),

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
