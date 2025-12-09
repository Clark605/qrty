import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/common/widgets/app_background.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/enums/qr_code_type_enum.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/qr_view/cubit/qr_view_cubit.dart';
import 'package:qrty/feature/qr_view/widgets/action_button.dart';
import 'package:qrty/feature/qr_view/widgets/text_data_view.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class QrResultScreen extends StatelessWidget {
  final String data;
  final DateTime timestamp;
  final String source;
  final QRCodeType type;

  const QrResultScreen({
    super.key,
    required this.data,
    required this.timestamp,
    required this.source,
    required this.type,
  });

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
            LocaleKeys.result.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: BlocBuilder<QrViewCubit, QrViewState>(
          builder: (context, state) {
            final cubit = context.read<QrViewCubit>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Content Card
                  QrResultView(
                    data: data,
                    type: type,
                    timestamp: timestamp,
                    showQrCode: !state.showQrCode,
                    onToggleView: () => cubit.toggleView(),
                  ),

                  SizedBox(height: context.hp(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionButton(
                        icon: AppAssets.share,
                        label: LocaleKeys.share.tr(),
                        onTap: () => cubit.shareData(data),
                      ),
                      SizedBox(width: context.wp(4)),
                      ActionButton(
                        icon: state.showQrCode
                            ? AppAssets.save
                            : AppAssets.copy,
                        label: state.showQrCode
                            ? LocaleKeys.save.tr()
                            : LocaleKeys.copy.tr(),
                        onTap: () => state.showQrCode
                            ? cubit.saveQrCode()
                            : cubit.copyToClipboard(data, context),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
