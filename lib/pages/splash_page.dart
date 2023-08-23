import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connections/ssh.dart';
import '../constants/constants.dart';
import '../constants/images.dart';
import '../constants/theme.dart';
import '../providers/settings_providers.dart';
import '../utils/helper.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashPage> {
  initApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.read(ipProvider.notifier).state =
        prefs.getString('ip') ?? '192.168.56.100';
    ref.read(usernameProvider.notifier).state =
        prefs.getString('username') ?? 'lg';
    ref.read(passwordProvider.notifier).state =
        prefs.getString('password') ?? 'lg';
    ref.read(portProvider.notifier).state = prefs.getInt('port') ?? 22;
    ref.read(downloadableContentAvailableProvider.notifier).state =
        prefs.getBool('downloadableContent') ?? false;
    setRigs(prefs.getInt('rigsController') ?? 3, ref);
    ref.read(darkModeOnProvider.notifier).state =
        prefs.getBool('theme') ?? true;
    ref.read(showHomepageTourProvider.notifier).state =
        prefs.getBool('showHomepageTour') ?? true;
    ref.read(showDashboardTourProvider.notifier).state =
        prefs.getBool('showDashboardTour') ?? true;
    ref.read(showVisualizerTourProvider.notifier).state =
        prefs.getBool('showVisualizerTour') ?? true;
    ref.read(languageProvider.notifier).state =
        prefs.getString('language') ?? 'English';
    if (ref.read(darkModeOnProvider) == true) {
      setDarkTheme(ref);
    } else {
      setLightTheme(ref);
    }
    if (!mounted) {
      return;
    }
    SSH(ref: ref).initialConnect();
    changeLocale(
        context,
        Const.availableLanguageCodes[
            Const.availableLanguages.indexOf(ref.read(languageProvider))]);
  }

  @override
  void initState() {
    super.initState();
    initApp();
    Future.delayed(const Duration(seconds: 5), () async {
      await nextScreenReplace(context, 'HomePage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemesDark.normalColor,
        image: const DecorationImage(
            image: AssetImage(ImageConst.splash), fit: BoxFit.fitHeight),
      ),
    );
  }
}
