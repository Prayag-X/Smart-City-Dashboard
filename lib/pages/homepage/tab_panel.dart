import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/tab_button.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';

class TabPanel extends ConsumerStatefulWidget {
  const TabPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TabPanelState();
}

class _TabPanelState extends ConsumerState<TabPanel> {
  @override
  Widget build(BuildContext context) {
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(homePageTabProvider);
    return Container(
      height: screenSize(context).height,
      width: Const.tabBarWidth,
      color: Themes.darkTabBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => ref.read(homePageTabProvider.notifier).state = 0,
            child: Container(
              height: 240,
              color: homePageTab == 0
                  ? Themes.darkHighlightColor
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 240,
                    width: 3,
                    color: homePageTab == 0 ? Colors.white : Colors.transparent,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LogoShower(
                        logo: ImageConst.appLogo,
                        size: 170,
                      ),
                      Text(TextConst.home,
                          style: textStyleBoldWhite.copyWith(fontSize: 26))
                    ],
                  ),
                  Container(
                    height: 240,
                    width: 3,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Text(
                  TextConst.welcome,
                  style: textStyleNormalWhite.copyWith(fontSize: 21),
                ),
                20.ph,
                Text(
                  TextConst.description,
                  textAlign: TextAlign.center,
                  style: textStyleNormalWhite.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                TabButton(
                    logo: ImageConst.helpLogo, name: TextConst.help, tab: 1),
                Divider(
                  color: Themes.darkWhiteColor,
                  indent: 10,
                  endIndent: 10,
                ),
                TabButton(
                    logo: ImageConst.settingLogo,
                    name: TextConst.settings,
                    tab: 2),
                TabButton(
                    logo: ImageConst.lgLogo, name: TextConst.option, tab: 3),
                20.ph
              ],
            ),
          ),
        ],
      ),
    );
  }
}
