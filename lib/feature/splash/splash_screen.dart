import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrty/core/common/widgets/fab.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/extensions/navigator_extensions.dart';
import 'package:qrty/core/routes/routes.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.shrink(),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(context.wp(20)),
                ),
              ),
              child: Image.asset(AppAssets.logo, scale: 5),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(color: AppColors.primary),
                Container(
                  padding: EdgeInsetsDirectional.all(context.wp(4)),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(context.wp(20)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        LocaleKeys.get_started.tr(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: context.sp(32),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        LocaleKeys.get_started_subtitle.tr(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: context.sp(16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Fab(
                        onPressed: () {
                          context.pushReplacementNamed(Routes.appSection);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
