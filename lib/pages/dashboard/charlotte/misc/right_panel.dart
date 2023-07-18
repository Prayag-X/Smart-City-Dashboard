import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/pages/dashboard/downloadable_content.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/kml_download_button.dart';


class CharlotteMiscTabRight extends ConsumerStatefulWidget {
  const CharlotteMiscTabRight({super.key});

  @override
  ConsumerState createState() => _CharlotteMiscTabRightState();
}

class _CharlotteMiscTabRightState extends ConsumerState<CharlotteMiscTabRight> {
  @override
  Widget build(BuildContext context) {
    return DashboardRightPanel(
        headers: [translate('dashboard.available_kml')],
        headersFlex: const [1],
        centerHeader: true,
        panelList: DownloadableContent.charlotteMiscKml
            .map((data) => KmlDownloaderButton(
            data, DownloadableContent.charlotteMiscKml.indexOf(data)))
            .toList());
  }
}
