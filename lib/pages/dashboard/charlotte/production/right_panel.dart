import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/pages/dashboard/downloadable_content.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/kml_download_button.dart';

class CharlotteProductionTabRight extends ConsumerStatefulWidget {
  const CharlotteProductionTabRight({super.key});

  @override
  ConsumerState createState() => _CharlotteProductionTabRightState();
}

class _CharlotteProductionTabRightState extends ConsumerState<CharlotteProductionTabRight> {
  @override
  Widget build(BuildContext context) {
    return DashboardRightPanel(
        headers: [translate('dashboard.available_kml')],
        headersFlex: const [1],
        centerHeader: true,
        panelList: DownloadableContent.charlotteProductionKml
            .map((data) => KmlDownloaderButton(
            data, DownloadableContent.charlotteProductionKml.indexOf(data)))
            .toList());
  }
}
