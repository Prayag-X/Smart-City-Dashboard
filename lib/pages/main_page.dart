import 'dart:async';
import 'dart:ui';

import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/panels/feature_tour_widget.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../connections/ssh.dart';
import '../constants/constants.dart';
import '../kml_makers/balloon_makers.dart';
import '../providers/data_providers.dart';
import '../providers/page_providers.dart';
import '../providers/settings_providers.dart';
import 'dashboard/city_data.dart';
import 'panels/screen_panel.dart';
import 'panels/tab_panel.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late StreamSubscription<ConnectivityResult> subscription;
  final double padding = 10;

  listenInternetConnection() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        Future.delayed(Duration.zero).then((x) async {
          ref.read(isConnectedToInternetProvider.notifier).state = true;
        });
      } else {
        Future.delayed(Duration.zero).then((x) async {
          ref.read(isConnectedToInternetProvider.notifier).state = false;
        });
      }
    });
  }

  orbitPlay() async {
    ref.read(playingGlobalTourProvider.notifier).state = true;
    for (CityCardModel city in AllCityData.availableCities) {
      if (!ref.read(playingGlobalTourProvider)) {
        break;
      }
      await SSH(ref: ref).flyToInstantWithoutSaving(
          context,
          city.location.latitude,
          city.location.longitude,
          Const.appZoomScale.zoomLG,
          0,
          0);
      if (!mounted) {
        return;
      }
      await SSH(ref: ref).cleanBalloon(context);
      await Future.delayed(const Duration(milliseconds: 8000));
      if (!mounted) {
        return;
      }
      await SSH(ref: ref).renderInSlave(
          context,
          ref.read(rightmostRigProvider),
          BalloonMakers.orbitBalloon(
              CameraPosition(
                target: LatLng(
                  city.location.latitude,
                  city.location.longitude,
                ),
                zoom: Const.orbitZoomScale.zoomLG,
              ),
              city.image,
              city.cityNameEnglish));
      for (int i = 0; i <= 180; i += 17) {
        if (!mounted) {
          return;
        }
        if (!ref.read(playingGlobalTourProvider)) {
          break;
        }
        SSH(ref: ref).flyToOrbit(
            context,
            city.location.latitude,
            city.location.longitude,
            Const.orbitZoomScale.zoomLG,
            60,
            i.toDouble());
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }
    if (!mounted) {
      return;
    }
    await SSH(ref: ref).flyToWithoutSaving(
        context,
        Const.initialMapPosition.target.latitude,
        Const.initialMapPosition.target.longitude,
        Const.initialMapPosition.zoom.zoomLG,
        Const.initialMapPosition.tilt,
        Const.initialMapPosition.bearing);
    ref.read(playingGlobalTourProvider.notifier).state = false;
  }

  orbitStop() async {
    ref.read(playingGlobalTourProvider.notifier).state = false;
    await SSH(ref: ref).cleanBalloon(context);
    if (!mounted) {
      return;
    }
    await SSH(ref: ref).flyToWithoutSaving(
        context,
        Const.initialMapPosition.target.latitude,
        Const.initialMapPosition.target.longitude,
        Const.initialMapPosition.zoom.zoomLG,
        Const.initialMapPosition.tilt,
        Const.initialMapPosition.bearing);
  }

  showFeatureTour() async {
    if (ref.read(showHomepageTourProvider)) {
      ref.read(featureTourControllerHomepageProvider).start(
            context: context,
            delay: Duration.zero,
            force: true,
          );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showHomepageTour', false);
      ref.read(showHomepageTourProvider.notifier).state = false;
    }
  }

  @override
  initState() {
    super.initState();
    listenInternetConnection();
    showFeatureTour();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(tabProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    bool playingGlobalTour = ref.watch(playingGlobalTourProvider);
    FeaturesTourController featuresTourController =
        ref.watch(featureTourControllerHomepageProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Row(
          children: const [
            TabPanel(),
            Expanded(child: ScreenPanel()),
          ],
        ),
        floatingActionButton: isHomePage && homePageTab == 0
            ? FeaturesTour(
                index: 3,
                introduce: FeatureTourContainer(
                  text: translate('tour.3'),
                ),
                introduceConfig: IntroduceConfig.copyWith(
                  quadrantAlignment: QuadrantAlignment.top,
                ),
                controller: featuresTourController,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness * 3),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          if (!playingGlobalTour) {
                            ref.read(playingGlobalTourProvider.notifier).state =
                                true;
                            await orbitPlay();
                          } else {
                            ref.read(playingGlobalTourProvider.notifier).state =
                                false;
                            await orbitStop();
                          }
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'),
                              color: Colors.red);
                        }
                        // Add your onPressed code here!
                      },
                      label: Padding(
                        padding: EdgeInsets.only(
                            top: padding, bottom: padding, right: padding),
                        child: Text(
                          !playingGlobalTour
                              ? translate('homepage.tour')
                              : translate('homepage.stop_tour'),
                          style: textStyleNormal.copyWith(
                              color: oppositeColor, fontSize: 17),
                        ),
                      ),
                      icon: Padding(
                        padding: EdgeInsets.only(
                            top: padding, bottom: padding, left: padding),
                        child: Icon(
                          !playingGlobalTour
                              ? Icons.tour_rounded
                              : Icons.stop_rounded,
                          color: !playingGlobalTour ? Colors.green : Colors.red,
                          size: 17,
                        ),
                      ),
                      backgroundColor:
                          lightenColor(highlightColor).withOpacity(0.5),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
