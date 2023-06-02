import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/about_page.dart';
import 'package:smart_city_dashboard/pages/homepage/dashboard.dart';
import 'package:smart_city_dashboard/pages/homepage/help_page.dart';
import 'package:smart_city_dashboard/pages/homepage/settings.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../providers/page_providers.dart';
import '../../widgets/helper.dart';
import 'city_home_page.dart';

class ScreenPanel extends ConsumerStatefulWidget {
  const ScreenPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ScreenPanelState();
}

class _ScreenPanelState extends ConsumerState<ScreenPanel> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(homePageTabProvider);
    return Stack(
      children: [
        Container(
          color: Themes.darkColor,
          child: Center(
            child: isHomePage
                ? (() {
                    switch (homePageTab) {
                      case 0:
                        return const CityHomePage();
                      case -3:
                        return const HelpPage();
                      case -1:
                        return const Settings();
                      case -2:
                        return const AboutPage();
                    }
                  }())
                :
            (() {
              switch (homePageTab) {
                case -3:
                  return const HelpPage();
                case -1:
                  return const Settings();
                case -2:
                  return const AboutPage();
                default:
                  return const Dashboard();
              }
            }()),
          ),
        ),
        appBar(),
      ],
    );
  }

  Container appBar() {
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    return Container(
      height: Const.appBarHeight,
      color: Themes.darkColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TextConst.title,
                  style: textStyleBoldWhite.copyWith(fontSize: 30),
                ),
                5.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                          color: isConnectedToLg ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(35.0)),
                    ),
                    5.pw,
                    Text(
                      isConnectedToLg
                          ? TextConst.connected
                          : TextConst.disconnected,
                      style: textStyleBold.copyWith(
                          color: isConnectedToLg ? Colors.green : Colors.red,
                          fontSize: 14),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              width: 350,
              height: 55,
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mic,
                      color: Themes.darkWhiteColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Themes.darkWhiteColor, width: 3),
                        borderRadius: BorderRadius.circular(35.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Themes.darkWhiteColor, width: 1),
                        borderRadius: BorderRadius.circular(35.0)),
                    hintText: TextConst.search,
                    hintStyle: textStyleNormal.copyWith(
                        color: Colors.white.withOpacity(0.5), fontSize: 16)),
                style: textStyleNormalWhite.copyWith(fontSize: 16),
                controller: searchController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
