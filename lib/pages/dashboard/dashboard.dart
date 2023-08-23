import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/google_map.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/kml_download_button.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';
import '../../connections/ssh.dart';
import '../../constants/constants.dart';
import '../../constants/text_styles.dart';
import '../../providers/data_providers.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import '../panels/feature_tour_widget.dart';
import 'about_tab/left_panel.dart';
import 'about_tab/right_panel.dart';
import 'weather_tab/left_panel.dart';
import 'weather_tab/right_panel.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  showFeatureTour() async {
    if (ref.read(showDashboardTourProvider)) {
      ref.read(featureTourControllerDashboardProvider).start(
            context: context,
            delay: Duration.zero,
            force: true,
          );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showDashboardTour', false);
      ref.read(showDashboardTourProvider.notifier).state = false;
    }
  }

  @override
  void initState() {
    super.initState();
    showFeatureTour();
  }

  @override
  Widget build(BuildContext context) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    CityCardModel city = ref.watch(cityDataProvider)!;
    int tab = ref.watch(tabProvider);
    bool downloadableContentAvailable =
        ref.watch(downloadableContentAvailableProvider);
    FeaturesTourController featuresTourDashboardController =
        ref.watch(featureTourControllerDashboardProvider);
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: SizedBox(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const SizedBox.shrink(),
            FeaturesTour(
              index: 2,
              controller: featuresTourDashboardController,
              introduce: FeatureTourContainer(
                text: translate('tour.d2'),
              ),
              introduceConfig: IntroduceConfig.copyWith(
                quadrantAlignment: QuadrantAlignment.right,
              ),
              child: SizedBox(
                width: (screenSize(context).width -
                        screenSize(context).width / Const.tabBarWidthDivider) /
                    2,
                height: screenSize(context).height - Const.appBarHeight,
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
                      SSH(ref: ref).cleanKML(
                        context,
                      );
                    });
                    if (downloadableContentAvailable) {
                      for (var pageTab in city.availableTabs) {
                        if (pageTab.tab == tab) {
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
            ),
            SizedBox(
                width: (screenSize(context).width -
                            screenSize(context).width /
                                Const.tabBarWidthDivider) /
                        2 -
                    Const.dashboardUISpacing * 2,
                child: Column(
                  children: [
                    const GoogleMapPart(),
                    FeaturesTour(
                      index: 6,
                      controller: featuresTourDashboardController,
                      introduce: FeatureTourContainer(
                        text: translate('tour.d6'),
                      ),
                      introduceConfig: IntroduceConfig.copyWith(
                        quadrantAlignment: QuadrantAlignment.left,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Const.dashboardUIRoundness),
                        child: SizedBox(
                          height: (screenSize(context).height -
                                      Const.appBarHeight) /
                                  2 -
                              25 -
                              Const.dashboardUISpacing,
                          child: (() {
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
                                            fontSize:
                                                Const.dashboardTextSize - 3,
                                            color:
                                                oppositeColor.withOpacity(0.5)),
                                      ),
                                    );
                                  }
                                  Future.delayed(Duration.zero).then((x) async {
                                    ref
                                        .read(kmlClickedProvider.notifier)
                                        .state = -1;
                                    ref.read(kmlPlayProvider.notifier).state =
                                        -1;
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
