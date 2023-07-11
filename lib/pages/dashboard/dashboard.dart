import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/google_map.dart';
import 'package:smart_city_dashboard/pages/dashboard/new_york/environment/right_panel.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';
import '../../constants/constants.dart';
import '../../constants/text_styles.dart';
import '../../constants/texts.dart';
import '../../providers/data_providers.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import 'about_tab/left_panel.dart';
import 'about_tab/right_panel.dart';
import 'new_york/environment/left_panel.dart';
import 'weather_tab/left_panel.dart';
import 'weather_tab/right_panel.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CityCardModel city = ref.watch(cityDataProvider)!;
    int tab = ref.watch(tabProvider);
    bool downloadableContentAvailable =
        ref.watch(downloadableContentAvailableProvider);
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: SizedBox(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const SizedBox.shrink(),
            SizedBox(
              width: (screenSize(context).width -
                      screenSize(context).width / Const.tabBarWidthDivider) /
                  2,
              height: screenSize(context).height - Const.appBarHeight,
              // color: Colors.blue,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: (() {
                  if (tab == 0) {
                    return const WeatherTabLeft();
                  }
                  if (tab == city.availableTabs.length - 1) {
                    return const AboutTabLeft();
                  }
                  if (downloadableContentAvailable) {
                    for(var pageTab in city.availableTabs) {
                      if(pageTab.tab == tab) {
                        return pageTab.leftTab!;
                      }
                    }
                  }
                  Future.delayed(Duration.zero).then((x) async {
                    ref.read(isLoadingProvider.notifier).state = false;
                  });
                  return AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: Const.animationDuration,
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: -Const.animationDistance,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          Container(
                            height: screenSize(context).height -
                                Const.appBarHeight * 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.downloading_rounded,
                                  size: 70,
                                  color: Colors.red,
                                ),
                                5.ph,
                                Text(
                                  TextConst.contentUnavailable,
                                  textAlign: TextAlign.center,
                                  style: textStyleNormalWhite.copyWith(
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }()),
              ),
            ),
            Container(
                width: (screenSize(context).width -
                            screenSize(context).width /
                                Const.tabBarWidthDivider) /
                        2 -
                    Const.dashboardUISpacing * 2,
                // color: Colors.blue,
                child: Column(
                  children: [
                    const GoogleMapPart(),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Const.dashboardUIRoundness),
                      child: Container(
                        height:
                            (screenSize(context).height - Const.appBarHeight) /
                                    2 -
                                25 -
                                Const.dashboardUISpacing,
                        // color: Themes.darkHighlightColor,
                        child: (() {
                          // return Container(
                          //   color: Themes.darkHighlightColor,
                          //   height: (screenSize(context).height -
                          //               Const.appBarHeight) /
                          //           2 -
                          //       40,
                          // );
                          if (tab == 0) {
                            return const WeatherTabRight();
                          }
                          if (tab == city.availableTabs.length - 1) {
                            return const AboutTabRight();
                          }
                          for(var pageTab in city.availableTabs) {
                            if(pageTab.tab == tab) {
                              return pageTab.rightTab!;
                            }
                          }
                        }()),
                      ),
                    ),
                  ],
                )),
            // const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
