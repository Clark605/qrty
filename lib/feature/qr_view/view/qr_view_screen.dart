import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrty/core/common/widgets/app_background.dart';
import 'package:qrty/core/constants/app_assets.dart';
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

  const QrResultScreen({
    super.key,
    required this.data,
    required this.timestamp,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrViewCubit(),
      child: QrViewView(data: data, timestamp: timestamp, source: source),
    );
  }
}

class QrViewView extends StatelessWidget {
  final String data;
  final DateTime timestamp;
  final String source;

  const QrViewView({
    super.key,
    required this.data,
    required this.timestamp,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            LocaleKeys.result.tr(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: context.sp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<QrViewCubit, QrViewState>(
          builder: (context, state) {
            final cubit = context.read<QrViewCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.all(context.wp(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Content Card
                  Container(
                    padding: EdgeInsets.all(context.wp(5)),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(context.wp(4)),
                    ),
                    child: TextDataView(
                      data: data,
                      timestamp: timestamp,
                      showQrCode: state.showQrCode,
                      onToggleView: () => cubit.toggleView(),
                    ),
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
                            ? AppAssets.copy
                            : AppAssets.save,
                        label: state.showQrCode
                            ? LocaleKeys.copy.tr()
                            : LocaleKeys.save.tr(),
                        onTap: () => state.showQrCode
                            ? cubit.copyToClipboard(data, context)
                            : cubit.saveQrCode(),
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
