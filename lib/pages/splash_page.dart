import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    ref.read(ipProvider.notifier).state = prefs.getString('ip') ?? '';
    ref.read(usernameProvider.notifier).state =
        prefs.getString('username') ?? '';
    ref.read(passwordProvider.notifier).state =
        prefs.getString('password') ?? '';
    ref.read(portProvider.notifier).state = prefs.getInt('port') ?? 22;
    setRigs(prefs.getInt('rigsController') ?? 3, ref);
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
        color: Themes.darkColor,
        image: const DecorationImage(
            image: AssetImage(ImageConst.splash),
            fit: BoxFit.fitHeight
        ),
      ),
    );
  }
}
