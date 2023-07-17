import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/data.dart';
import '../../downloadable_content.dart';
import '../../../../constants/images.dart';
import '../../../../constants/theme.dart';
import '../../../../models/city_card_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../connections/ssh.dart';
import '../../../../utils/csv_parser.dart';
import '../../../../utils/helper.dart';
import '../../widgets/charts/line_chart_parser.dart';
import '../../widgets/dashboard_container.dart';

class CharlotteProductionTabLeft extends ConsumerStatefulWidget {
  const CharlotteProductionTabLeft({super.key});

  @override
  ConsumerState createState() => _CharlotteProductionTabLeftState();
}

class _CharlotteProductionTabLeftState extends ConsumerState<CharlotteProductionTabLeft> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
