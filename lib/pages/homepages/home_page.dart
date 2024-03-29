import 'dart:math';

import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/city_data.dart';
import '../../models/tab_button.dart';
import '../../pages/panels/feature_tour_widget.dart';
import '../../utils/extensions.dart';
import '../../utils/helper.dart';
import '../../connections/ssh.dart';
import '../../constants/constants.dart';
import '../../constants/images.dart';
import '../../constants/text_styles.dart';
import '../../constants/theme.dart';
import '../../models/city_card.dart';
import '../../providers/data_providers.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/logo_shower.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = false;
      await SSH(ref: ref).cleanBalloon(
        context,
      );
      if (!mounted) {
        return;
      }
      await SSH(ref: ref).cleanKML(context);
      if (!mounted) {
        return;
      }
      if (!ref.read(playingGlobalTourProvider)) {
        await SSH(ref: ref).flyToWithoutSaving(
            context,
            Const.initialMapPosition.target.latitude,
            Const.initialMapPosition.target.longitude,
            Const.initialMapPosition.zoom.zoomLG,
            Const.initialMapPosition.tilt,
            Const.initialMapPosition.bearing);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String search = ref.watch(searchProvider);
    FeaturesTourController featuresTourController =
        ref.watch(featureTourControllerHomepageProvider);
    return AnimationLimiter(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: AnimationConfiguration.toStaggeredList(
              duration: Const.animationDuration,
              childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: Const.animationDistance,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
              children: [
                Const.appBarHeight.ph,
                SizedBox(
                  height: screenSize(context).height - Const.appBarHeight,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: search != ''
                        ? Column(
                            children: AllCityData.availableCities.map((city) {
                            if (city.cityName
                                    .toLowerCase()
                                    .contains(search.toLowerCase()) ||
                                search
                                    .toLowerCase()
                                    .contains(city.cityName.toLowerCase())) {
                              return CityCard(
                                cityData: city,
                              );
                            }
                            for (TabButtonModel tab in city.availableTabs) {
                              if (tab.name!
                                      .toLowerCase()
                                      .contains(search.toLowerCase()) ||
                                  search
                                      .toLowerCase()
                                      .contains(tab.name!.toLowerCase())) {
                                return CityCard(
                                  cityData: city,
                                );
                              }
                            }
                            return Container();
                          }).toList())
                        : Column(
                            children: AllCityData.availableCities.map((city) {
                            if (AllCityData.availableCities.indexOf(city) ==
                                0) {
                              return FeaturesTour(
                                controller: featuresTourController,
                                index: 0,
                                introduce: FeatureTourContainer(
                                  text: translate('tour.0'),
                                ),
                                introduceConfig: IntroduceConfig.copyWith(
                                  quadrantAlignment: QuadrantAlignment.bottom,
                                ),
                                child: CityCard(
                                  cityData: city,
                                  enableFeature: true,
                                ),
                              );
                            }
                            return CityCard(
                              cityData: city,
                            );
                          }).toList()),
                  ),
                ),
              ])),
    );
  }
}

class CityCard extends ConsumerWidget {
  const CityCard({
    Key? key,
    required this.cityData,
    this.enableFeature = false,
  }) : super(key: key);

  final CityCardModel cityData;
  final bool enableFeature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes themes = ref.watch(themesProvider);
    double height = max(min(screenSize(context).height - 600, 200), 150);
    double width = min(screenSize(context).width - 400, 700);
    FeaturesTourController featuresTourController =
        ref.watch(featureTourControllerHomepageProvider);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Const.homePageTextSize + 5),
      child: GestureDetector(
        onTap: () {
          ref.read(isHomePageProvider.notifier).state = false;
          ref.read(cityDataProvider.notifier).state = cityData;
        },
        child: SizedBox(
          height: height + 15,
          width: width + 15,
          child: Stack(
            children: [
              Positioned(
                top: 15.0,
                left: 15.0,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Const.dashboardUIRoundness),
                    ),
                    color: lightenColor(themes.highlightColor, 0.05),
                  ),
                ),
              ),
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Const.dashboardUIRoundness),
                    bottomRight: Radius.circular(Const.dashboardUIRoundness),
                  ),
                  color: darkenColor(themes.highlightColor, 0.05),
                ),
                child: Row(
                  children: [
                    ImageShower(
                      logo: cityData.image,
                      size: height,
                      curve: BorderRadius.only(
                        topLeft: Radius.circular(Const.dashboardUIRoundness),
                      ),
                    ),
                    Const.homePageTextSize.pw,
                    enableFeature
                        ? FeaturesTour(
                            index: 1,
                            introduce: FeatureTourContainer(
                              text: translate('tour.1'),
                            ),
                            introduceConfig: IntroduceConfig.copyWith(
                              quadrantAlignment: QuadrantAlignment.bottom,
                            ),
                            controller: featuresTourController,
                            child: SizedBox(
                              width: width / 2 - 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('smart_city'),
                                    style: textStyleNormal.copyWith(
                                        fontSize: Const.homePageTextSize - 6,
                                        color: themes.oppositeColor.withOpacity(0.6)),
                                  ),
                                  Text(
                                    cityData.cityName,
                                    style: textStyleBold.copyWith(
                                        color: themes.oppositeColor,
                                        fontSize: Const.homePageTextSize + 10),
                                  ),
                                  5.ph,
                                  Row(
                                    children: [
                                      AssetLogoShower(
                                          logo: ImageConst.marker,
                                          size: Const.homePageTextSize + 5),
                                      Text(
                                        cityData.country,
                                        style: textStyleNormal.copyWith(
                                            color: themes.oppositeColor,
                                            fontSize: Const.homePageTextSize),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: width / 2 - 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('smart_city'),
                                  style: textStyleNormal.copyWith(
                                      fontSize: Const.homePageTextSize - 6,
                                      color: themes.oppositeColor.withOpacity(0.6)),
                                ),
                                Text(
                                  cityData.cityName,
                                  style: textStyleBold.copyWith(
                                      color: themes.oppositeColor,
                                      fontSize: Const.homePageTextSize + 10),
                                ),
                                5.ph,
                                Row(
                                  children: [
                                    AssetLogoShower(
                                        logo: ImageConst.marker,
                                        size: Const.homePageTextSize + 5),
                                    Text(
                                      cityData.country,
                                      style: textStyleNormal.copyWith(
                                          color: themes.oppositeColor,
                                          fontSize: Const.homePageTextSize),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                    VerticalDivider(
                      color: themes.oppositeColor,
                      indent: 15,
                      endIndent: 15,
                    ),
                    5.pw,
                    enableFeature
                        ? FeaturesTour(
                            index: 2,
                            introduce: FeatureTourContainer(
                              text: translate('tour.2'),
                            ),
                            introduceConfig: IntroduceConfig.copyWith(
                              quadrantAlignment: QuadrantAlignment.bottom,
                            ),
                            controller: featuresTourController,
                            child: SizedBox(
                              height: height - 20,
                              width: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    translate('homepage.available_data'),
                                    style: textStyleNormal.copyWith(
                                        fontSize: Const.homePageTextSize - 5,
                                        color: themes.oppositeColor.withOpacity(0.6)),
                                  ),
                                  SizedBox(
                                    height: 90,
                                    child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: cityData.availableTabs
                                            .map((tab) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 1.0),
                                                  child: Row(
                                                    children: [
                                                      5.pw,
                                                      AssetLogoShower(
                                                          logo: tab.logo!,
                                                          size: Const
                                                                  .homePageTextSize -
                                                              5),
                                                      9.pw,
                                                      Text(
                                                        tab.name!,
                                                        style: textStyleNormal
                                                            .copyWith(
                                                                color:
                                                                    themes.oppositeColor,
                                                                fontSize: Const
                                                                        .homePageTextSize -
                                                                    3),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                            .toList()),
                                  ),
                                  const SizedBox.shrink()
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: height - 20,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  translate('homepage.available_data'),
                                  style: textStyleNormal.copyWith(
                                      fontSize: Const.homePageTextSize - 5,
                                      color: themes.oppositeColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  height: 90,
                                  child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: cityData.availableTabs
                                          .map((tab) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 1.0),
                                                child: Row(
                                                  children: [
                                                    5.pw,
                                                    AssetLogoShower(
                                                        logo: tab.logo!,
                                                        size: Const
                                                                .homePageTextSize -
                                                            5),
                                                    9.pw,
                                                    Text(
                                                      tab.name!,
                                                      style: textStyleNormal
                                                          .copyWith(
                                                              color:
                                                                  themes.oppositeColor,
                                                              fontSize: Const
                                                                      .homePageTextSize -
                                                                  3),
                                                    )
                                                  ],
                                                ),
                                              ))
                                          .toList()),
                                ),
                                const SizedBox.shrink()
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
