import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../models/city_card_model.dart';
import '../../providers/data_providers.dart';

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
    int homePageTab = ref.watch(tabProvider);
    CityCardModel? cityData = ref.watch(cityDataProvider);
    return Container(
      height: screenSize(context).height,
      width: screenSize(context).width/Const.tabBarWidthDivider,
      color: Themes.darkTabBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(tabProvider.notifier).state = 0;
              ref.read(isHomePageProvider.notifier).state = true;
            },
            child: Container(
              height: 240,
              color: homePageTab == 0 && isHomePage
                  ? Themes.darkHighlightColor
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 240,
                    width: 3,
                    color: homePageTab == 0 && isHomePage
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AssetLogoShower(
                        logo: ImageConst.appLogo,
                        size: 170,
                      ),
                      AnimatedSwitcher(
                          duration: Const.animationDuration,
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: isHomePage
                              ? const TextForAnimation1()
                              : TextForAnimation2(cityData: cityData)),
                      AnimatedSwitcher(
                          duration: Const.animationDuration,
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: isHomePage
                              ? const TextForAnimation3()
                              : const TextForAnimation4()),
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
          isHomePage
              ? Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: Const.animationDuration,
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: -Const.animationDistance,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
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
                  ))
              : AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: Const.animationDuration,
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: -Const.animationDistance,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: ref.read(cityDataProvider)!.availableTabs,
                    ),
                  ),
                ),
          Column(
            children: [
              isHomePage
                  ? AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: Const.animationDuration,
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: -Const.animationDistance,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: <Widget>[
                            TabButton(
                                logo: ImageConst.helpLogo,
                                name: TextConst.help,
                                tab: -3)
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Divider(
                color: Themes.darkWhiteColor,
                indent: 10,
                endIndent: 10,
              ),
              TabButton(
                  logo: ImageConst.settingLogo,
                  name: TextConst.settings,
                  tab: -1),
              TabButton(
                  logo: ImageConst.aboutLogo, name: TextConst.about, tab: -2),
            ],
          ),
        ],
      ),
    );
  }
}

class TextForAnimation4 extends StatelessWidget {
  const TextForAnimation4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(TextConst.goBack,
        style: textStyleNormal.copyWith(
            fontSize: 16, color: Themes.darkWhiteColor.withOpacity(0.7)));
  }
}

class TextForAnimation3 extends StatelessWidget {
  const TextForAnimation3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('',
        style: textStyleNormal.copyWith(
            fontSize: 16, color: Themes.darkWhiteColor.withOpacity(0.7)));
  }
}

class TextForAnimation2 extends StatelessWidget {
  const TextForAnimation2({
    super.key,
    required this.cityData,
  });

  final CityCardModel? cityData;

  @override
  Widget build(BuildContext context) {
    return Text(cityData!.cityName,
        style: textStyleBoldWhite.copyWith(fontSize: 26));
  }
}

class TextForAnimation1 extends StatelessWidget {
  const TextForAnimation1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(TextConst.home,
        style: textStyleBoldWhite.copyWith(fontSize: 26));
  }
}
