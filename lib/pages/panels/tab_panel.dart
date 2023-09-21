import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'feature_tour_widget.dart';
import '../../constants/images.dart';
import '../../constants/text_styles.dart';
import '../../pages/panels/tab_button.dart';
import '../../providers/page_providers.dart';
import '../../utils/extensions.dart';
import '../../utils/helper.dart';
import '../../utils/logo_shower.dart';
import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../models/city_card.dart';
import '../../providers/data_providers.dart';
import '../../providers/settings_providers.dart';

class TabPanel extends ConsumerStatefulWidget {
  const TabPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _TabPanelState();
}

class _TabPanelState extends ConsumerState<TabPanel> {
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(tabProvider);
    CityCardModel? cityData = ref.watch(cityDataProvider);
    FeaturesTourController featuresTourController =
        ref.watch(featureTourControllerHomepageProvider);
    FeaturesTourController featuresTourDashboardController =
        ref.watch(featureTourControllerDashboardProvider);
    return Container(
      height: screenSize(context).height,
      width: screenSize(context).width / Const.tabBarWidthDivider,
      color: themes.tabBarColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeaturesTour(
              index: 1,
              controller: featuresTourDashboardController,
              introduce: FeatureTourContainer(
                text: translate('tour.d1'),
              ),
              introduceConfig: IntroduceConfig.copyWith(
                quadrantAlignment: QuadrantAlignment.right,
              ),
              child: GestureDetector(
                onTap: () {
                  ref.read(tabProvider.notifier).state = 0;
                  ref.read(isHomePageProvider.notifier).state = true;
                },
                child: Container(
                  height: screenSize(context).width / Const.tabBarWidthDivider,
                  color: homePageTab == 0 && isHomePage
                      ? themes.highlightColor
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: screenSize(context).width /
                            Const.tabBarWidthDivider,
                        width: 3,
                        color: homePageTab == 0 && isHomePage
                            ? themes.oppositeColor
                            : Colors.transparent,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AssetLogoShower(
                            logo: ImageConst.app,
                            size: screenSize(context).width /
                                    Const.tabBarWidthDivider -
                                70,
                          ),
                          AnimatedSwitcher(
                              duration: Const.animationDuration,
                              switchInCurve: Curves.easeIn,
                              switchOutCurve: Curves.easeOut,
                              child: isHomePage
                                  ? Text(translate('homepage.home'),
                                      key: key1,
                                      style: textStyleBold.copyWith(
                                          color: themes.oppositeColor,
                                          fontSize: Const.tabBarTextSize + 6))
                                  : Text(cityData!.cityName,
                                      key: key2,
                                      style: textStyleBold.copyWith(
                                          color: themes.oppositeColor,
                                          fontSize: Const.tabBarTextSize + 6))),
                          AnimatedSwitcher(
                              duration: Const.animationDuration,
                              switchInCurve: Curves.easeIn,
                              switchOutCurve: Curves.easeOut,
                              child: isHomePage
                                  ? Text('',
                                      key: key3,
                                      style: textStyleNormal.copyWith(
                                          fontSize: Const.tabBarTextSize - 4,
                                          color: themes.oppositeColor
                                              .withOpacity(0.7)))
                                  : Text(translate('city_page.go_back'),
                                      key: key4,
                                      style: textStyleNormal.copyWith(
                                          fontSize: Const.tabBarTextSize - 4,
                                          color: themes.oppositeColor
                                              .withOpacity(0.7)))),
                        ],
                      ),
                      Container(
                        height: screenSize(context).width /
                            Const.tabBarWidthDivider,
                        width: 3,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isHomePage
                ? homePageTab != -3 && homePageTab != -4
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
                                  translate('homepage.welcome'),
                                  style: textStyleNormal.copyWith(
                                      color: themes.oppositeColor,
                                      fontSize: Const.tabBarTextSize + 1),
                                ),
                                Const.tabBarTextSize.ph,
                                Text(
                                  translate('homepage.description'),
                                  textAlign: TextAlign.center,
                                  style: textStyleNormal.copyWith(
                                      color: themes.oppositeColor,
                                      fontSize: Const.tabBarTextSize),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : homePageTab == -3
                        ? AnimationLimiter(
                            child: Column(
                              children: AnimationConfiguration.toStaggeredList(
                                duration: Const.animationDuration,
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  horizontalOffset: -Const.animationDistance,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: [
                                  Text(translate('help_page.section'),
                                      style: textStyleNormal.copyWith(
                                          fontSize: Const.tabBarTextSize - 3,
                                          color: themes.oppositeColor)),
                                  Divider(
                                    color: themes.oppositeColor,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  SubTabButton(
                                    name: translate('help_page.nav_title'),
                                    tab: 0,
                                    provider: helpPageKeysProvider,
                                  ),
                                  SubTabButton(
                                    name: translate('help_page.app_bar_title'),
                                    tab: 1,
                                    provider: helpPageKeysProvider,
                                  ),
                                  SubTabButton(
                                    name: translate(
                                        'help_page.settings_title_short'),
                                    tab: 2,
                                    provider: helpPageKeysProvider,
                                  ),
                                  SubTabButton(
                                    name:
                                        translate('help_page.city_page_title'),
                                    tab: 3,
                                    provider: helpPageKeysProvider,
                                  ),
                                  SubTabButton(
                                    name: translate(
                                        'help_page.visualizer_page_title_short'),
                                    tab: 4,
                                    provider: helpPageKeysProvider,
                                  ),
                                  Divider(
                                    color: themes.oppositeColor,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : AnimationLimiter(
                            child: Column(
                              children: AnimationConfiguration.toStaggeredList(
                                duration: Const.animationDuration,
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  horizontalOffset: -Const.animationDistance,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: [
                                  Text(translate('visualizer.section'),
                                      style: textStyleNormal.copyWith(
                                          fontSize: Const.tabBarTextSize - 3,
                                          color: themes.oppositeColor)),
                                  Divider(
                                    color: themes.oppositeColor,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  SubTabButton(
                                    name:
                                        translate('visualizer.csv_title_short'),
                                    tab: 0,
                                    provider: visualizerPageKeysProvider,
                                  ),
                                  SubTabButton(
                                    name:
                                        translate('visualizer.kml_title_short'),
                                    tab: 1,
                                    provider: visualizerPageKeysProvider,
                                  ),
                                  Divider(
                                    color: themes.oppositeColor,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ],
                              ),
                            ),
                          )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text(translate('city_page.available_data'),
                                style: textStyleNormal.copyWith(
                                    fontSize: Const.tabBarTextSize - 3,
                                    color: themes.oppositeColor)),
                            Divider(
                              color: themes.oppositeColor,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      ),
                      FeaturesTour(
                        index: 0,
                        controller: featuresTourDashboardController,
                        introduce: FeatureTourContainer(
                          text: translate('tour.d0'),
                        ),
                        introduceConfig: IntroduceConfig.copyWith(
                          quadrantAlignment: QuadrantAlignment.right,
                        ),
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
                              children: ref
                                  .read(cityDataProvider)!
                                  .availableTabs
                                  .map((tab) => TabButton(
                                      logo: tab.logo!,
                                      name: tab.name!,
                                      tab: tab.tab))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                              FeaturesTour(
                                index: 6,
                                controller: featuresTourController,
                                introduce: FeatureTourContainer(
                                  text: translate('tour.6'),
                                ),
                                introduceConfig: IntroduceConfig.copyWith(
                                  quadrantAlignment: QuadrantAlignment.right,
                                ),
                                child: TabButton(
                                    logo: ImageConst.visualizer,
                                    name: translate('visualizer.visualizer'),
                                    tab: -4),
                              ),
                              FeaturesTour(
                                index: 7,
                                controller: featuresTourController,
                                introduce: FeatureTourContainer(
                                  text: translate('tour.7'),
                                ),
                                introduceConfig: IntroduceConfig.copyWith(
                                  quadrantAlignment: QuadrantAlignment.right,
                                ),
                                child: TabButton(
                                    logo: ImageConst.help,
                                    name: translate('homepage.help'),
                                    tab: -3),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Divider(
                  color: themes.oppositeColor,
                  indent: 10,
                  endIndent: 10,
                ),
                FeaturesTour(
                  index: 8,
                  controller: featuresTourController,
                  introduce: FeatureTourContainer(
                    text: translate('tour.8'),
                  ),
                  introduceConfig: IntroduceConfig.copyWith(
                    quadrantAlignment: QuadrantAlignment.right,
                  ),
                  child: TabButton(
                      logo: ImageConst.setting,
                      name: translate('homepage.settings'),
                      tab: -1),
                ),
                FeaturesTour(
                  index: 9,
                  controller: featuresTourController,
                  introduce: FeatureTourContainer(
                    text: translate('tour.9'),
                  ),
                  introduceConfig: IntroduceConfig.copyWith(
                    quadrantAlignment: QuadrantAlignment.right,
                  ),
                  child: TabButton(
                      logo: ImageConst.about,
                      name: translate('homepage.about_normal'),
                      tab: -2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
