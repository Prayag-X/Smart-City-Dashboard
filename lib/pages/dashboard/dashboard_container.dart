import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../constants/constants.dart';
import '../../constants/texts.dart';
import '../../constants/theme.dart';
import '../../providers/settings_providers.dart';
import '../../ssh_lg/ssh.dart';

class DashboardContainer extends StatefulWidget {
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
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
              widget.widthMultiplier /
              4 -
          (widget.widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
      height: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
          widget.heightMultiplier *
          Const.dashboardUIHeightFactor /
          4,
      decoration: BoxDecoration(
        color: Themes.darkHighlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Const.dashboardTextSize/2 + 2,
            horizontal:
                widget.data.length > 7 && widget.widthMultiplier == 1 ? Const.dashboardTextSize+5 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: textStyleNormal.copyWith(
                  fontSize: Const.dashboardTextSize-3, color: Colors.white.withOpacity(0.5)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.showPercentage
                    ? CircularPercentIndicator(
                        radius: Const.dashboardTextSize+13.0,
                        lineWidth: 8.0,
                        animation: true,
                        percent: widget.percentage,
                        center: AssetLogoShower(logo: widget.image!, size: Const.dashboardTextSize+13),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: widget.progressColor,
                        backgroundColor:
                            lightenColor(Themes.darkHighlightColor, 0.1),
                      )
                    : widget.image != null
                        ? AssetLogoShower(logo: widget.image!, size: Const.dashboardTextSize+43)
                        : const SizedBox.shrink(),
                widget.image != null ? (Const.dashboardTextSize-5).pw : const SizedBox.shrink(),
                widget.data.length > 7 && widget.widthMultiplier == 1
                    ? Expanded(
                        child: Text(
                          widget.data,
                          style: textStyleSemiBoldWhite.copyWith(fontSize: Const.dashboardTextSize+5),
                        ),
                      )
                    : Text(
                        widget.data,
                        style: textStyleSemiBoldWhite.copyWith(fontSize: Const.dashboardTextSize*2),
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

class AboutContainer extends StatefulWidget {
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
  State<AboutContainer> createState() => _AboutContainerState();
}

class _AboutContainerState extends State<AboutContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
              widget.widthMultiplier /
              4 -
          (widget.widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
      height: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
          widget.heightMultiplier *
          Const.dashboardUIHeightFactor /
          4,
      decoration: BoxDecoration(
        color: Themes.darkHighlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        image: widget.image != null
            ? DecorationImage(
                image: AssetImage(widget.image!),
          fit: BoxFit.fill
              )
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
                        fontSize: 17, color: Colors.white.withOpacity(0.5)),
                  )
                : const SizedBox.shrink(),
            widget.description != null
                ? Text(
                  widget.description!,
                  style: textStyleNormalWhite.copyWith(fontSize: 20),
                )
                : widget.data != null
                    ? Text(
                        widget.data!,
                        style: textStyleSemiBoldWhite.copyWith(fontSize: 40),
                      )
                    : const SizedBox.shrink(),
            const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class BlankDashboardContainer extends StatelessWidget {
  const BlankDashboardContainer(
      {super.key, this.heightMultiplier = 1, this.widthMultiplier = 1});
  final double heightMultiplier;
  final double widthMultiplier;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
                widthMultiplier /
                4 -
            (widthMultiplier - 2).abs() * Const.dashboardUISpacing / 2,
        height: (screenSize(context).width - screenSize(context).width/Const.tabBarWidthDivider) *
            heightMultiplier *
            Const.dashboardUIHeightFactor /
            4,
        decoration: BoxDecoration(
          color: Themes.darkHighlightColor,
          borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        ),
        child: Center(
          child: Text(
            '--',
            style: textStyleNormalWhite.copyWith(fontSize: 30),
          ),
        ));
  }
}
