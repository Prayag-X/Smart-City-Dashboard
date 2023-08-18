import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../providers/page_providers.dart';
import '../../../utils/helper.dart';
import '../downloadable_content.dart';
import '../../../constants/images.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';

class ChicagoEthicsTabLeft extends ConsumerStatefulWidget {
  const ChicagoEthicsTabLeft({super.key});

  @override
  ConsumerState createState() => _ChicagoEthicsTabLeftState();
}

class _ChicagoEthicsTabLeftState extends ConsumerState<ChicagoEthicsTabLeft> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? registryData;
  List<List<dynamic>>? clientsData;
  List<List<dynamic>>? lobbyistData;
  List<List<dynamic>>? contributorsData;
  List<List<dynamic>>? expenditure1Data;
  List<List<dynamic>>? expenditure2Data;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Registry']!);
      setState(() {
        registryData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby Clients']!);
      setState(() {
        clientsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby lobbyist']!);
      setState(() {
        lobbyistData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby contributors']!);
      setState(() {
        contributorsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby expenditure 1']!);
      setState(() {
        expenditure1Data = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby expenditure 2']!);
      setState(() {
        expenditure2Data = FileParser.transformer(data!);
      });
      if (!mounted) {
        return;
      }
      await BalloonLoader(ref: ref, mounted: mounted, context: context)
          .loadDashboardBalloon(screenshotController);
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
    return Screenshot(
      controller: screenshotController,
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: Const.animationDuration,
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: -Const.animationDistance,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [],
          ),
        ),
      ),
    );
  }
}
