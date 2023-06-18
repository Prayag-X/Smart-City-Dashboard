import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
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
    int homePageTab = ref.watch(tabProvider);
    return GestureDetector(
      onTap: () => ref.read(tabProvider.notifier).state = tab,
      child: Container(
        color: homePageTab == tab ? Themes.darkHighlightColor : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Const.tabBarTextSize/2,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 3,
                color: homePageTab == tab ? Colors.white : Colors.transparent,
              ),
              Const.tabBarTextSize.pw,
              AssetLogoShower(logo: logo, size: Const.tabBarTextSize+13),
              Const.tabBarTextSize.pw,
              Text(
                name,
                style: textStyleNormalWhite.copyWith(
                  fontSize: Const.tabBarTextSize+5
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

