import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/common/widgets/app_background.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/generate_qr/cubit/generate_qr_cubit.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

/// Base form screen widget for simple QR types with single or few fields
abstract class BaseQrFormScreen extends StatelessWidget {
  const BaseQrFormScreen({super.key});

  /// Form title displayed in app bar
  String get formTitle;

  /// Build form fields based on QR type
  Widget buildFormFields(
    BuildContext context,
    GenerateQrCubit cubit,
    GenerateQrState state,
  );

  /// Additional validation if needed (optional)
  bool isFormValid(Map<String, String> formData) => true;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            formTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: BlocConsumer<GenerateQrCubit, GenerateQrState>(
          listener: (context, state) {
            if (state.status == GenerateQrStatus.success) {
              // Navigate to QR result screen
              Navigator.pushNamed(
                context,
                Routes.qrView,
                arguments: {
                  'data': state.generatedData,
                  'type': state.selectedType,
                  'timestamp': DateTime.now(),
                  'source': 'generate',
                },
              ).then((_) {
                // Reset state after viewing result
                context.read<GenerateQrCubit>().reset();
              });
            }
          },
          builder: (context, state) {
            final cubit = context.read<GenerateQrCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: context.wp(4),
                  vertical: context.hp(2),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.secondary.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                  border: BorderDirectional(
                    top: BorderSide(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.hp(3)),

                    // Form fields
                    buildFormFields(context, cubit, state),

                    SizedBox(height: context.hp(4)),

                    // Generate button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        minimumSize: Size(double.infinity, context.hp(6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          state.status == GenerateQrStatus.generating ||
                              !_canGenerate(state)
                          ? null
                          : () => cubit.generateQr(),
                      child: state.status == GenerateQrStatus.generating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.secondary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              LocaleKeys.generate_qr_code.tr(),
                              style: TextStyle(
                                fontSize: context.sp(16),
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                    ),

                    SizedBox(height: context.hp(3)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _canGenerate(GenerateQrState state) {
    return state.formErrors.isEmpty &&
        state.formData.values.any((value) => value.trim().isNotEmpty) &&
        isFormValid(state.formData);
  }
}
