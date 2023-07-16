import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/data.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_container.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class AboutTabLeft extends ConsumerStatefulWidget {
  const AboutTabLeft({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AboutTabLeftState();
}

class _AboutTabLeftState extends ConsumerState<AboutTabLeft> {
  List<List<dynamic>> data = [];
  int cityIndex = -2;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVAssets(DataConst.about);
      for (var row in data) {
        if (row[1].toLowerCase() ==
            ref.read(cityDataProvider)!.cityName.toLowerCase()) {
          setState(() {
            cityIndex = data.indexOf(row);
          });
          ref.read(isLoadingProvider.notifier).state = false;
          return;
        }
      }
      setState(() {
        cityIndex = -1;
      });
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  showBalloon() {
    var initialMapPosition = CameraPosition(
      target: ref.read(cityDataProvider)!.location,
      zoom: 11,
    );
    SSH(ref: ref).renderInSlave(
        ref.read(rightmostRigProvider),
        BalloonMakers.aboutBalloon(
          initialMapPosition,
          ref.read(cityDataProvider)!.cityNameEnglish,
          ref.read(cityDataProvider)!.country,
          ref.read(cityDataProvider)!.image,
          ref.read(cityDataProvider)!.description,
        ));
  }

  @override
  void initState() {
    super.initState();
    loadCSVData();
    showBalloon();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Const.animationDuration,
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: -Const.animationDistance,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            AboutContainer(
                widthMultiplier: 2,
                title: translate('smart_city').toUpperCase(),
                data: ref.read(cityDataProvider)!.cityName),
            Const.dashboardUISpacing.ph,
            AboutContainer(
              widthMultiplier: 2,
              heightMultiplier: 2,
              image: ref.read(cityDataProvider)!.image,
            ),
            Const.dashboardUISpacing.ph,
            AboutContainer(
                widthMultiplier: 2,
                title: translate('dashboard.about.country'),
                data: ref.read(cityDataProvider)!.country),
            Const.dashboardUISpacing.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AboutContainer(
                    title: translate('dashboard.about.latitude'),
                    data: roundDouble(
                            ref.read(cityDataProvider)!.location.latitude, 4)
                        .toString()),
                AboutContainer(
                    title: translate('dashboard.about.longitude'),
                    data: roundDouble(
                            ref.read(cityDataProvider)!.location.longitude, 4)
                        .toString()),
              ],
            ),
            Const.dashboardUISpacing.ph,
            AboutContainer(
                widthMultiplier: 2,
                heightMultiplier: 3,
                title: translate('dashboard.about.description'),
                description: ref.read(cityDataProvider)!.description),
            Const.dashboardUISpacing.ph,
            cityIndex > 0
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardContainer(
                            title: translate('dashboard.about.smart_mobility'),
                            image: ImageConst.mobility,
                            showPercentage: true,
                            progressColor: Colors.white,
                            percentage: data[cityIndex][3] / 10000,
                            data: data[cityIndex][3].toString(),
                          ),
                          DashboardContainer(
                            title:
                                translate('dashboard.about.smart_government'),
                            image: ImageConst.government,
                            showPercentage: true,
                            progressColor: Colors.purple,
                            percentage: data[cityIndex][5] / 10000,
                            data: data[cityIndex][5].toString(),
                          ),
                        ],
                      ),
                      Const.dashboardUISpacing.ph,
                      DashboardContainer(
                        widthMultiplier: 2,
                        title: translate('dashboard.about.smart_city_index'),
                        image: ImageConst.index,
                        showPercentage: true,
                        progressColor: Colors.blue,
                        percentage: data[cityIndex][8] / 10000,
                        data: data[cityIndex][8].toString(),
                      ),
                      Const.dashboardUISpacing.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardContainer(
                            title:
                                translate('dashboard.about.smart_environment'),
                            image: ImageConst.environment,
                            showPercentage: true,
                            progressColor: Colors.green,
                            percentage: data[cityIndex][4] / 10000,
                            data: data[cityIndex][4].toString(),
                          ),
                          DashboardContainer(
                            title: translate('dashboard.about.smart_economy'),
                            image: ImageConst.economy,
                            showPercentage: true,
                            progressColor: Colors.yellow,
                            percentage: data[cityIndex][6] / 10000,
                            data: data[cityIndex][6].toString(),
                          ),
                        ],
                      ),
                      Const.dashboardUISpacing.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DashboardContainer(
                            title: translate('dashboard.about.smart_people'),
                            image: ImageConst.people,
                            showPercentage: true,
                            progressColor: Colors.blueGrey,
                            percentage: data[cityIndex][7] / 10000,
                            data: data[cityIndex][7].toString(),
                          ),
                          DashboardContainer(
                            title: translate('dashboard.about.smart_living'),
                            image: ImageConst.living,
                            showPercentage: true,
                            progressColor: Colors.red,
                            percentage: data[cityIndex][8] / 10000,
                            data: data[cityIndex][8].toString(),
                          ),
                        ],
                      ),
                      Const.dashboardUISpacing.ph,
                    ],
                  )
                : const SizedBox.shrink(),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }
}
