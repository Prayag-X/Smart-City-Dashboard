import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../constants/constants.dart';
import '../../../constants/theme.dart';
import '../../../providers/settings_providers.dart';

class DashboardContainer extends ConsumerStatefulWidget {
  const DashboardContainer(
      {super.key,
      this.heightMultiplier = 1,
      this.widthMultiplier = 1,
      this.showPercentage = false,
      this.progressColor = Colors.transparent,
      required this.title,
      required this.data,
      this.image,
      this.percentage = 0});

  final double heightMultiplier;
  final double widthMultiplier;
  final bool showPercentage;
  final double percentage;
  final Color progressColor;
  final String title;
  final String data;
  final String? image;

  @override
  ConsumerState<DashboardContainer> createState() =>
      _DashboardContainerConsumerState();
}

class _DashboardContainerConsumerState
    extends ConsumerState<DashboardContainer> {
  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
      width: (screenSize(context).width -
                  screenSize(context).width / Const.tabBarWidthDivider) *
              widget.widthMultiplier /
              4 -
          (widget.widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          widget.heightMultiplier *
          Const.dashboardUIHeightFactor /
          4,
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Const.dashboardTextSize / 2 + 2,
            horizontal: widget.data.length > 7 && widget.widthMultiplier == 1
                ? Const.dashboardTextSize + 5
                : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: textStyleNormal.copyWith(
                  fontSize: Const.dashboardTextSize - 3,
                  color: oppositeColor.withOpacity(0.5)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.showPercentage
                    ? CircularPercentIndicator(
                        radius: Const.dashboardTextSize + 13.0,
                        lineWidth: 8.0,
                        animation: true,
                        percent: widget.percentage,
                        center: AssetLogoShower(
                            logo: widget.image!,
                            size: Const.dashboardTextSize + 13),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: widget.progressColor,
                        backgroundColor: lightenColor(highlightColor, 0.1),
                      )
                    : widget.image != null
                        ? AssetLogoShower(
                            logo: widget.image!,
                            size: Const.dashboardTextSize + 43)
                        : const SizedBox.shrink(),
                widget.image != null
                    ? (Const.dashboardTextSize - 5).pw
                    : const SizedBox.shrink(),
                widget.data.length > 7 && widget.widthMultiplier == 1
                    ? Expanded(
                        child: Text(
                          widget.data,
                          style: textStyleSemiBold.copyWith(
                              color: oppositeColor,
                              fontSize: Const.dashboardTextSize + 5),
                        ),
                      )
                    : Text(
                        widget.data,
                        style: textStyleSemiBold.copyWith(
                            color: oppositeColor,
                            fontSize: Const.dashboardTextSize * 2),
                      ),
              ],
            ),
            const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class AboutContainer extends ConsumerStatefulWidget {
  const AboutContainer({
    super.key,
    this.heightMultiplier = 1,
    this.widthMultiplier = 1,
    this.title,
    this.data,
    this.description,
    this.image,
  });

  final double heightMultiplier;
  final double widthMultiplier;
  final String? title;
  final String? data;
  final String? description;
  final String? image;

  @override
  ConsumerState<AboutContainer> createState() => _AboutContainerConsumerState();
}

class _AboutContainerConsumerState extends ConsumerState<AboutContainer> {
  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
      width: (screenSize(context).width -
                  screenSize(context).width / Const.tabBarWidthDivider) *
              widget.widthMultiplier /
              4 -
          (widget.widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          widget.heightMultiplier *
          Const.dashboardUIHeightFactor /
          4,
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        image: widget.image != null
            ? DecorationImage(
                image: AssetImage(widget.image!), fit: BoxFit.fill)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.title != null
                ? Text(
                    widget.title!,
                    style: textStyleNormal.copyWith(
                        fontSize: Const.dashboardTextSize - 3,
                        color: oppositeColor.withOpacity(0.5)),
                  )
                : const SizedBox.shrink(),
            widget.description != null
                ? Text(
                    widget.description!,
                    style: textStyleNormal.copyWith(
                        color: oppositeColor,
                        fontSize: Const.dashboardTextSize - 1),
                  )
                : widget.data != null
                    ? Text(
                        widget.data!,
                        style: textStyleSemiBold.copyWith(
                            color: oppositeColor,
                            fontSize: Const.dashboardTextSize * 2 - 5),
                      )
                    : const SizedBox.shrink(),
            const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class BlankDashboardContainer extends ConsumerWidget {
  const BlankDashboardContainer(
      {super.key, this.heightMultiplier = 1, this.widthMultiplier = 1});
  final double heightMultiplier;
  final double widthMultiplier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
        width: (screenSize(context).width -
                    screenSize(context).width / Const.tabBarWidthDivider) *
                widthMultiplier /
                4 -
            (widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
        height: (screenSize(context).width -
                screenSize(context).width / Const.tabBarWidthDivider) *
            heightMultiplier *
            Const.dashboardUIHeightFactor /
            4,
        decoration: BoxDecoration(
          color: highlightColor,
          borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        ),
        child: Center(
          child: Text(
            '--',
            style: textStyleNormal.copyWith(
                color: oppositeColor, fontSize: Const.dashboardTextSize + 10),
          ),
        ));
  }
}

class BlankVisualizerContainer extends ConsumerWidget {
  const BlankVisualizerContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
        width: screenSize(context).width -
            screenSize(context).width / Const.tabBarWidthDivider,
        height: (screenSize(context).width -
            screenSize(context).width / Const.tabBarWidthDivider) *
            Const.dashboardUIHeightFactor,
        decoration: BoxDecoration(
          color: highlightColor,
          borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        ),
        child: Center(
          child: Text(
            '--',
            style: textStyleNormal.copyWith(
                color: oppositeColor, fontSize: Const.dashboardTextSize + 10),
          ),
        ));
  }
}
