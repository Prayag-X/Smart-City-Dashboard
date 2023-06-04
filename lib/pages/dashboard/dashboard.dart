import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/pages/dashboard/right_panel.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import '../../constants/constants.dart';
import 'left_panel.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: SizedBox(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox.shrink(),
            Container(
              width: (screenSize(context).width - Const.tabBarWidth) / 2,
              color: Colors.blue,
              child: const LeftPanel(),
            ),
            Container(
                width: (screenSize(context).width - Const.tabBarWidth) / 2 - 40,
                color: Colors.blue,
                child: const RightPanel()),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
