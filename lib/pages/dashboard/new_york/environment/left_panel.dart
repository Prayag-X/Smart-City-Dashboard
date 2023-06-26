import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/texts.dart';
import '../../../../constants/theme.dart';
import '../../../../models/city_card_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../connections/ssh.dart';
import '../../../../utils/helper.dart';
import '../../dashboard_container.dart';

class NYCEnvironmentTabLeft extends ConsumerStatefulWidget {
  const NYCEnvironmentTabLeft({super.key});

  @override
  ConsumerState createState() => _NYCEnvironmentTabLeftState();
}

class _NYCEnvironmentTabLeftState extends ConsumerState<NYCEnvironmentTabLeft> {
  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      // data = await FileParser.parseCSV(DataConst.about);
      // for (var row in data) {
      //   if (row[1].toLowerCase() ==
      //       ref.read(cityDataProvider)!.cityName.toLowerCase()) {
      //     setState(() {
      //       cityIndex = data.indexOf(row);
      //     });
      //     ref.read(isLoadingProvider.notifier).state = false;
      //     return;
      //   }
      // }
      // setState(() {
      //   cityIndex = -1;
      // });
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  @override
  Widget build(BuildContext context) {
    bool downloadableContentAvailable =
        ref.watch(downloadableContentAvailableProvider);
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
          children: downloadableContentAvailable
              ? []
              : [
                  Container(
                    height: screenSize(context).height - Const.appBarHeight*2,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.downloading_rounded,
                            size: 70,
                            color: Colors.red,
                          ),
                          5.ph,
                          Text(
                          TextConst.contentUnavailable,
                          textAlign: TextAlign.center,
                          style: textStyleNormalWhite.copyWith(fontSize: 16),
                        ),],
                    ),
                  )
                ],
        ),
      ),
    );
  }
}
