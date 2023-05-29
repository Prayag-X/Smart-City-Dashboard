import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/available_data.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/city_card.dart';
import 'package:smart_city_dashboard/pages/homepage/settings.dart';

import '../../providers/page_providers.dart';
import 'city_home_page.dart';

class ScreenBody extends ConsumerWidget {
  const ScreenBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isHomePage = ref.watch(isHomePageProvider);
    int homePageTab = ref.watch(homePageTabProvider);
    return Container(
      color: const Color(0xFF202124),
      child: Center(
        child: (() {
          switch (homePageTab) {
            case 0:
              return const CityHomePage();
              break;
            case 1:
              return const CityHomePage();
              break;
            case 2:
              return Settings();
              break;
            case 3:
              return const CityHomePage();
              break;
          }
        }()),
      ),
    );
  }
}
