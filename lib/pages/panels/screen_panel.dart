import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../homepages/home_page.dart';
import '../../pages/homepages/about_page.dart';
import '../../pages/dashboard/dashboard.dart';
import '../../pages/homepages/help_page.dart';
import '../../pages/homepages/settings_page.dart';
import '../../pages/homepages/visualizer_page.dart';
import '../../pages/panels/app_bar.dart';
import '../../constants/theme.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';

class ScreenPanel extends ConsumerStatefulWidget {
  const ScreenPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ScreenPanelState();
}

class _ScreenPanelState extends ConsumerState<ScreenPanel> {
  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(tabProvider);
    return Stack(
      children: [
        Container(
          color: themes.normalColor,
          child: Center(
            child: isHomePage
                ? (() {
                    switch (homePageTab) {
                      case 0:
                        return const HomePage();
                      case -3:
                        return HelpPage();
                      case -1:
                        return const SettingsPage();
                      case -2:
                        return const AboutPage();
                      case -4:
                        return const VisualizerPage();
                    }
                  }())
                : (() {
                    switch (homePageTab) {
                      case -3:
                        return HelpPage();
                      case -1:
                        return const SettingsPage();
                      case -2:
                        return const AboutPage();
                      default:
                        return const Dashboard();
                    }
                  }()),
          ),
        ),
        const CustomAppBar(),
      ],
    );
  }
}
