import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';

import '../../constants/constants.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';

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
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    int homePageTab = ref.watch(tabProvider);
    return GestureDetector(
      onTap: () => ref.read(tabProvider.notifier).state = tab,
      child: Container(
        color: homePageTab == tab ? highlightColor : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Const.tabBarTextSize / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 3,
                color: homePageTab == tab ? oppositeColor : Colors.transparent,
              ),
              Const.tabBarTextSize.pw,
              AssetLogoShower(logo: logo, size: Const.tabBarTextSize + 13),
              Const.tabBarTextSize.pw,
              Text(
                name,
                style: textStyleNormal.copyWith(
                    color: oppositeColor, fontSize: Const.tabBarTextSize + 5),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubTabButton extends ConsumerWidget {
  const SubTabButton({
    Key? key,
    required this.name,
    required this.tab,
    required this.provider,
  }) : super(key: key);

  final String name;
  final int tab;
  final StateProvider<List<GlobalKey<State<StatefulWidget>>>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    int homePageTab = ref.watch(subTabProvider);
    return GestureDetector(
      onTap: () {
        ref.read(subTabProvider.notifier).state = tab;
        Scrollable.ensureVisible(ref.read(provider)[tab].currentContext!);
      },
      child: Container(
        color: homePageTab == tab ? highlightColor : Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Const.tabBarTextSize / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Const.tabBarTextSize.pw,
              Text(
                homePageTab != tab ? '--' : '>',
                style: textStyleNormal.copyWith(
                    color: oppositeColor, fontSize: Const.tabBarTextSize + 5),
              ),
              Const.tabBarTextSize.pw,
              Text(
                name,
                style: textStyleNormal.copyWith(
                    color: oppositeColor, fontSize: Const.tabBarTextSize + 5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
