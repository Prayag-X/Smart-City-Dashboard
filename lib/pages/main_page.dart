import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Row(
            children: const [
              TabPanel(),
              Expanded(child: ScreenPanel()),
            ],
          )),
    );
  }
}
