import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../providers/page_providers.dart';
import '../providers/settings_providers.dart';
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
                onPressed: () {
                  if (isConnectedToLg) {
                  } else {
                    showSnackBar(
                        context: context,
                        message: translate('settings.connection_required'));
                  }
                  // Add your onPressed code here!
                },
                label: Text(
                  translate('homepage.tour'),
                  style: textStyleNormal.copyWith(
                      color: oppositeColor, fontSize: 17),
                ),
                icon: Icon(
                  Icons.tour_rounded,
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
