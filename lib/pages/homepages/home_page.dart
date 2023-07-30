import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/pages/dashboard/city_data.dart';
import 'package:smart_city_dashboard/models/tab_button.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/constants.dart';
import '../../constants/images.dart';
import '../../constants/text_styles.dart';
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
    String search = ref.watch(searchProvider);
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
                            children: AllCityData.availableCities
                                .map((city) => CityCard(
                                      cityData: city,
                                    ))
                                .toList()),
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
  }) : super(key: key);

  final CityCardModel cityData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    double height = max(min(screenSize(context).height - 600, 200), 150);
    double width = min(screenSize(context).width - 400, 700);
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
                    color: lightenColor(highlightColor, 0.05),
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
                  color: darkenColor(highlightColor, 0.05),
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
                    SizedBox(
                      width: width / 2 - 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('smart_city'),
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize - 6,
                                color: oppositeColor.withOpacity(0.6)),
                          ),
                          Text(
                            cityData.cityName,
                            style: textStyleBold.copyWith(
                                color: oppositeColor,
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
                                    color: oppositeColor,
                                    fontSize: Const.homePageTextSize),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: oppositeColor,
                      indent: 15,
                      endIndent: 15,
                    ),
                    5.pw,
                    SizedBox(
                      height: height - 20,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate('homepage.available_data'),
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize - 5,
                                color: oppositeColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: cityData.availableTabs
                                    .map((tab) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1.0),
                                          child: Row(
                                            children: [
                                              5.pw,
                                              AssetLogoShower(
                                                  logo: tab.logo!,
                                                  size: Const.homePageTextSize -
                                                      5),
                                              9.pw,
                                              Text(
                                                tab.name!,
                                                style: textStyleNormal.copyWith(
                                                    color: oppositeColor,
                                                    fontSize:
                                                        Const.homePageTextSize -
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
