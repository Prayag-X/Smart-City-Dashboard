import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../connections/ssh.dart';
import '../constants/constants.dart';
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
      await SSH(ref: ref).flyToInstantWithoutSaving(context, city.location.latitude,
          city.location.longitude, Const.appZoomScale.zoomLG, 0, 0);
      await Future.delayed(const Duration(milliseconds: 8000));
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
    SSH(ref: ref).flyTo(
        context,
        Const.initialMapPosition.target.latitude,
        Const.initialMapPosition.target.longitude,
        Const.appZoomScale.zoomLG,
        0,
        0);
    ref.read(playingGlobalTourProvider.notifier).state = false;
  }

  orbitStop() async {
    ref.read(playingGlobalTourProvider.notifier).state = false;
    SSH(ref: ref).flyTo(
        context,
        Const.initialMapPosition.target.latitude,
        Const.initialMapPosition.target.longitude,
        Const.appZoomScale.zoomLG,
        0,
        0);
  }

  @override
  initState() {
    super.initState();
    listenInternetConnection();
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
            ? FloatingActionButton.extended(
                onPressed: () async {
                  if (isConnectedToLg) {
                    if (!playingGlobalTour) {
                      ref.read(playingGlobalTourProvider.notifier).state = true;
                      await orbitPlay();
                    } else {
                      ref.read(playingGlobalTourProvider.notifier).state =
                          false;
                      await orbitStop();
                    }
                  } else {
                    showSnackBar(
                        context: context,
                        message: translate('settings.connection_required'));
                  }
                  // Add your onPressed code here!
                },
                label: Text(
                  !playingGlobalTour
                      ? translate('homepage.tour')
                      : translate('homepage.stop_tour'),
                  style: textStyleNormal.copyWith(
                      color: oppositeColor, fontSize: 17),
                ),
                icon: Icon(
                  !playingGlobalTour ? Icons.tour_rounded : Icons.stop_rounded,
                  color: oppositeColor,
                  size: 17,
                ),
                backgroundColor: lightenColor(highlightColor).withOpacity(0.8),
              )
            : null,
      ),
    );
  }
}
