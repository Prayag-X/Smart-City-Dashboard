import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';

class DashboardRightPanel extends ConsumerWidget {
  const DashboardRightPanel({
    required this.headers,
    required this.headersFlex,
    required this.panelList,
    this.centerHeader = false,
    Key? key,
  }) : super(key: key);

  final List<String> headers;
  final List<int> headersFlex;
  final List<Widget>? panelList;
  final bool centerHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Const.animationDuration,
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: Const.animationDistance,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: headers
                      .map(
                        (header) => Expanded(
                          flex: headersFlex[headers.indexOf(header)],
                          child: centerHeader
                              ? Center(
                                  child: Text(
                                  header,
                                  style: textStyleNormal.copyWith(
                                      fontSize: Const.dashboardTextSize - 3,
                                      color: oppositeColor.withOpacity(0.5)),
                                ))
                              : Text(
                                  header,
                                  style: textStyleNormal.copyWith(
                                      fontSize: Const.dashboardTextSize - 3,
                                      color: oppositeColor.withOpacity(0.5)),
                                ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Divider(
              color: oppositeColor,
            ),
            SizedBox(
              height: (screenSize(context).height - Const.appBarHeight) / 2 -
                  25 -
                  Const.dashboardUISpacing -
                  36,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: panelList != null
                    ? AnimationLimiter(
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: Const.animationDuration,
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: Const.animationDistance,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              Column(children: panelList!),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
