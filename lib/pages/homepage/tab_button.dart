import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../providers/page_providers.dart';

class TabButton extends ConsumerWidget {
  const TabButton({
    Key? key,
    required this.logo,
    required this.name,
    required this.tab,
  }) : super(key: key);
  
  final String logo;
  final String name;
  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int homePageTab = ref.watch(homePageTabProvider);
    return GestureDetector(
      onTap: () => ref.read(homePageTabProvider.notifier).state = tab,
      child: Container(
        color: homePageTab == tab ? const Color(0xFF3F475C) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 3,
                color: homePageTab == tab ? Colors.white : Colors.transparent,
              ),
              15.pw,
              LogoShower(logo: logo, size: 28),
              10.pw,
              Text(
                name,
                style: textStyleNormalWhite.copyWith(
                  fontSize: 19
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

