import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/texts.dart';
import '../../../../constants/theme.dart';
import '../../../../models/city_card_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../connections/ssh.dart';

class NYCEnvironmentTabRight extends ConsumerStatefulWidget {
  const NYCEnvironmentTabRight({super.key});

  @override
  ConsumerState createState() => _NYCEnvironmentTabRightState();
}

class _NYCEnvironmentTabRightState extends ConsumerState<NYCEnvironmentTabRight> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
