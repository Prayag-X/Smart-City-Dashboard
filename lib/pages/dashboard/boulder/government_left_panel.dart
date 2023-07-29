import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class BoulderGovernmentTabLeft extends ConsumerStatefulWidget {
  const BoulderGovernmentTabLeft({super.key});

  @override
  ConsumerState createState() => _BoulderGovernmentTabLeftState();
}

class _BoulderGovernmentTabLeftState
    extends ConsumerState<BoulderGovernmentTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? boardData;
  List<List<dynamic>>? accountData;
  List<List<dynamic>>? businessData;
  List<List<dynamic>>? licenseData;
  List<List<dynamic>>? bicycleData;
  List<List<dynamic>>? osmpData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Boards Applicants']!);
      setState(() {
        boardData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Account Payable']!);
      setState(() {
        accountData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Active Business Licenses']!);
      setState(() {
        businessData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Licensed Contractors']!);
      setState(() {
        licenseData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Bicyclist and Pedestrians']!);
      setState(() {
        bicycleData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['OSMP']!);
      setState(() {
        osmpData = FileParser.transformer(data!);
      });
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
    return Container();
  }
}
