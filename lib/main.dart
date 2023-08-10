import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/theme.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import 'pages/main_page.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var delegate = await LocalizationDelegate.create(
      basePath: 'assets/i18n/',
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US']);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    FeaturesTour.setGlobalConfig(
      skipConfig: SkipConfig.copyWith(
        text: 'Skip',
        textStyle: textStyleBold.copyWith(fontSize: 25, color: Colors.white),
        buttonStyle: TextButton.styleFrom(
            backgroundColor: ThemesDark.highlightColor,
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
                side: BorderSide(
                    color: lightenColor(ThemesDark.highlightColor), width: 1))),
      ),
      nextConfig: NextConfig.copyWith(
        text: 'Next',
        textStyle: textStyleBold.copyWith(fontSize: 25, color: Colors.white),
        buttonStyle: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
            backgroundColor: ThemesDark.highlightColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
                side: BorderSide(
                    color: lightenColor(ThemesDark.highlightColor), width: 1))),
      ),
      predialogConfig: PredialogConfig.copyWith(
        enabled: false,
      ),
      debugLog: true,
    );
    runApp(ProviderScope(child: LocalizedApp(delegate, const Routes())));
  });
}

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Smart City Dashboard',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/HomePage': (context) => const MainPage(),
        },
      ),
    );
  }
}
