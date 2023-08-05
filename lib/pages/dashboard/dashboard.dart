import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/google_map.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/kml_download_button.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';
import '../../connections/ssh.dart';
import '../../constants/constants.dart';
import '../../constants/text_styles.dart';
import '../../kml_makers/balloon_makers.dart';
import '../../providers/data_providers.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import 'about_tab/left_panel.dart';
import 'about_tab/right_panel.dart';
import 'weather_tab/left_panel.dart';
import 'weather_tab/right_panel.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
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
                  Future.delayed(Duration.zero).then((x) async {
                    ref.read(isLoadingProvider.notifier).state = false;
                    SSH(ref: ref).cleanBalloon(
                      context,
                    );
                    SSH(ref: ref).cleanKML(
                      context,
                    );
                  });
                  if (downloadableContentAvailable) {
                    for (var pageTab in city.availableTabs) {
                      if (pageTab.tab == tab) {
                        Future.delayed(Duration.zero).then((x) async {
                          var initialMapPosition = CameraPosition(
                            target: city.location,
                            zoom: Const.appZoomScale,
                          );
                          await SSH(ref: ref).renderInSlave(
                              context,
                              ref.read(rightmostRigProvider),
                              BalloonMakers.dashboardBalloon(
                                initialMapPosition,
                                pageTab.name!,
                                pageTab.nameForUrl!,
                                city.cityNameEnglish,
                                pageTab.tabWidgetNumbers!,
                              ));
                        });
                        return pageTab.leftTab!;
                      }
                    }
                  }
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
                          SizedBox(
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
                                  translate(
                                      'dashboard.downloadable_content_unavailable'),
                                  textAlign: TextAlign.center,
                                  style: textStyleNormal.copyWith(
                                      color: oppositeColor, fontSize: 16),
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
            SizedBox(
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
                      child: SizedBox(
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
                          Future.delayed(Duration.zero).then((x) async {
                            SSH(ref: ref).cleanKML(context);
                          });

                          if (tab == 0) {
                            return const WeatherTabRight();
                          }
                          if (tab == city.availableTabs.length - 1) {
                            return const AboutTabRight();
                          }
                          for (var pageTab in city.availableTabs) {
                            if (pageTab.tab == tab) {
                              if (pageTab.diffRightTab!) {
                                return pageTab.rightTab!;
                              } else {
                                if (pageTab.rightTabData!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      translate('city_data.no_kml'),
                                      style: textStyleNormal.copyWith(
                                          fontSize: Const.dashboardTextSize - 3,
                                          color:
                                              oppositeColor.withOpacity(0.5)),
                                    ),
                                  );
                                }
                                Future.delayed(Duration.zero).then((x) async {
                                  ref.read(kmlClickedProvider.notifier).state =
                                      -1;
                                  ref.read(kmlPlayProvider.notifier).state = -1;
                                });
                                return DashboardRightPanel(
                                    headers: [
                                      translate('dashboard.available_kml')
                                    ],
                                    headersFlex: const [
                                      1
                                    ],
                                    centerHeader: true,
                                    panelList: pageTab.rightTabData!
                                        .map((data) => KmlDownloaderButton(
                                            data,
                                            pageTab.rightTabData!
                                                .indexOf(data)))
                                        .toList());
                              }
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
