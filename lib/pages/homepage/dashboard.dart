import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../models/city_card_model.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: Container(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            Container(
              width: (screenSize(context).width - Const.tabBarWidth) / 2 - 30,
              color: Colors.blue,
              child: Column(),
            ),
            const VerticalDivider(
              color: Colors.white,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              width: (screenSize(context).width - Const.tabBarWidth) / 2 - 30,
              color: Colors.blue,
              child: Column(),
            ),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
