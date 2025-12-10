import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrty/core/common/widgets/fab.dart';
import 'package:qrty/core/constants/app_assets.dart';
import 'package:qrty/core/extensions/media_query_extensions.dart';
import 'package:qrty/core/theme/app_colors.dart';
import 'package:qrty/feature/history/cubit/history_cubit.dart';
import 'package:qrty/feature/history/view/history_screen.dart';
import 'package:qrty/feature/scan_qr/cubit/scan_qr_cubit.dart';
import 'package:qrty/feature/scan_qr/view/scan_qr_screen.dart';
import 'package:qrty/l10n/locale_keys.g.dart';

class AppSection extends StatefulWidget {
  const AppSection({super.key});

  @override
  AppSectionState createState() => AppSectionState();
}

class AppSectionState extends State<AppSection> {
  int _currentIndex = 2;
  final PageController pageController = PageController();

  final List<Widget> screens = [
    Container(color: Colors.blue),
    BlocProvider(
      create: (context) => HistoryCubit(),
      child: const HistoryScreen(),
    ),
    BlocProvider(
      create: (context) => ScanQrCubit(
        scannerController: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
          returnImage: false,
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
      ),
      child: const ScanQrScreen(),
    ),
  ];

  final List<String> icons = [AppAssets.qr, AppAssets.history];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,

      body: screens[_currentIndex],
      floatingActionButton: Fab(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: SvgPicture.asset(AppAssets.qrAppBar),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: icons.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.primary : AppColors.titleGrey;
          return Padding(
            padding: EdgeInsets.only(top: context.hp(0.5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icons[index],
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  height: context.hp(3.3),
                ),
                Text(
                  index == 0
                      ? LocaleKeys.generate.tr()
                      : LocaleKeys.history.tr(),
                  style: TextStyle(color: color, fontSize: context.sp(14)),
                ),
              ],
            ),
          );
        },
        scaleFactor: 0.1,
        splashRadius: 0,
        elevation: 10,
        leftCornerRadius: 30,
        rightCornerRadius: 30,
        backgroundColor: AppColors.secondary,
        height: context.hp(7),
        gapLocation: GapLocation.center,
        activeIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
