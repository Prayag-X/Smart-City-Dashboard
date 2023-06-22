import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/google_map.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import '../../constants/constants.dart';
import '../../providers/data_providers.dart';
import '../../providers/page_providers.dart';
import 'about_tab/left_panel.dart';
import 'about_tab/right_panel.dart';
import 'weather_tab/left_panel.dart';
import 'weather_tab/right_panel.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CityCardModel city = ref.watch(cityDataProvider)!;
    int tab = ref.watch(tabProvider);
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: SizedBox(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const SizedBox.shrink(),
            SizedBox(
              width: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) / 2,
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
                  // switch(city.number) {
                  //   case 1:
                  //     sw
                  // }
                }()),
              ),
            ),
            Container(
                width: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) / 2 - Const.dashboardUISpacing*2,
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
                          // switch(city.number) {
                          //   case 1:
                          //     sw
                          // }
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
