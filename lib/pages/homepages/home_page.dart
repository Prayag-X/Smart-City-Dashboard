import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/available_cities.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/constants.dart';
import '../../constants/images.dart';
import '../../constants/text_styles.dart';
import '../../constants/texts.dart';
import '../../constants/theme.dart';
import '../../models/city_card_model.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: SizedBox(
        height: screenSize(context).height,
        child: AnimationLimiter(
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
                children: CityCardData.availableCities
                    .map((city) => CityCard(
                          cityData: city,
                        ))
                    .toList()),
          ),
        ),
      ),
    );
  }
}

class CityCard extends ConsumerWidget {
  const CityCard({
    Key? key,
    required this.cityData,
  }) : super(key: key);

  final CityCardModel cityData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = max(min(screenSize(context).height - 600, 200), 150);
    double width = min(screenSize(context).width - 400, 700);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Const.homePageTextSize+5),
      child: GestureDetector(
        onTap: () {
          ref.read(isHomePageProvider.notifier).state = false;
          ref.read(cityDataProvider.notifier).state = cityData;
        },
        child: SizedBox(
          height: height+15,
          width: width+15,
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
                    color: lightenColor(Themes.darkHighlightColor, 0.05),
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
                  color: darkenColor(Themes.darkHighlightColor, 0.05),
                ),
                child: Row(
                  children: [
                    ImageShower(logo: cityData.image, size: height, curve: BorderRadius.only(
                      topLeft: Radius.circular(Const.dashboardUIRoundness),
                    ),
                    ),
                    Const.homePageTextSize.pw,
                    SizedBox(
                      width: width/2 - 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TextConst.smartCity,
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize-6, color: Colors.white.withOpacity(0.6)),
                          ),
                          Text(
                            cityData.cityName,
                            style: textStyleBoldWhite.copyWith(fontSize: Const.homePageTextSize+10),
                          ),
                          5.ph,
                          Row(
                            children: [
                              AssetLogoShower(logo: ImageConst.marker, size: Const.homePageTextSize+5),
                              Text(
                                cityData.country,
                                style: textStyleNormalWhite.copyWith(fontSize: Const.homePageTextSize),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      indent: 15,
                      endIndent: 15,
                    ),
                    5.pw,
                    SizedBox(
                      height: height-20,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TextConst.availableData,
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize-5, color: Colors.white.withOpacity(0.6)),
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView(
                              children: cityData.availableTabs.map((tab) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Row(
                                    children: [
                                      5.pw,
                                      AssetLogoShower(
                                          logo: tab.logo!,
                                          size: Const.homePageTextSize-5),
                                      9.pw,
                                      Text(
                                        tab.name!,
                                        style: textStyleNormalWhite.copyWith(
                                            fontSize: Const.homePageTextSize-3),
                                      )
                                    ],
                                  ),
                                )).toList()),
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
