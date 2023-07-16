import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/pages/dashboard/downloadable_content.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/kml_download_button.dart';

class NYCHealthTabRight extends ConsumerStatefulWidget {
  const NYCHealthTabRight({super.key});

  @override
  ConsumerState createState() => _NYCHealthTabRightState();
}

class _NYCHealthTabRightState extends ConsumerState<NYCHealthTabRight> {
  @override
  Widget build(BuildContext context) {
    return DashboardRightPanel(
        headers: [translate('dashboard.available_kml')],
        headersFlex: const [1],
        centerHeader: true,
        panelList: DownloadableContent.nycHealthKml
            .map((data) => KmlDownloaderButton(
            data, DownloadableContent.nycHealthKml.indexOf(data)))
            .toList());
  }
}
