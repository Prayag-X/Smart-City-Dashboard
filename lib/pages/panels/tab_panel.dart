import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';

import '../../constants/constants.dart';
import '../../models/city_card.dart';
import '../../providers/data_providers.dart';
import '../../providers/settings_providers.dart';
import 'feature_tour_widget.dart';

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
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
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
      color: tabBarColor,
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
                      ? highlightColor
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: screenSize(context).width /
                            Const.tabBarWidthDivider,
                        width: 3,
                        color: homePageTab == 0 && isHomePage
                            ? oppositeColor
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
                                      color: oppositeColor,
                                      fontSize: Const.tabBarTextSize + 1),
                                ),
                                Const.tabBarTextSize.ph,
                                Text(
                                  translate('homepage.description'),
                                  textAlign: TextAlign.center,
                                  style: textStyleNormal.copyWith(
                                      color: oppositeColor,
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
                                          color: oppositeColor)),
                                  Divider(
                                    color: oppositeColor,
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
                                    color: oppositeColor,
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
                                          color: oppositeColor)),
                                  Divider(
                                    color: oppositeColor,
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
                                    color: oppositeColor,
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
                                    color: oppositeColor)),
                            Divider(
                              color: oppositeColor,
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
                  color: oppositeColor,
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

class TextForAnimation4 extends ConsumerWidget {
  const TextForAnimation4({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return Text(translate('city_page.go_back'),
        style: textStyleNormal.copyWith(
            fontSize: Const.tabBarTextSize - 4,
            color: oppositeColor.withOpacity(0.7)));
  }
}

class TextForAnimation3 extends ConsumerWidget {
  const TextForAnimation3({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return Text('',
        style: textStyleNormal.copyWith(
            fontSize: Const.tabBarTextSize - 4,
            color: oppositeColor.withOpacity(0.7)));
  }
}

class TextForAnimation2 extends ConsumerWidget {
  const TextForAnimation2({
    super.key,
    required this.cityData,
  });

  final CityCardModel? cityData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return Text(cityData!.cityName,
        style: textStyleBold.copyWith(
            color: oppositeColor, fontSize: Const.tabBarTextSize + 6));
  }
}

class TextForAnimation1 extends ConsumerWidget {
  const TextForAnimation1({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return Text(translate('homepage.home'),
        style: textStyleBold.copyWith(
            color: oppositeColor, fontSize: Const.tabBarTextSize + 6));
  }
}
