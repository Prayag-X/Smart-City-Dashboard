import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'downloadable_kml.dart';

class TabButtonModel {
  String? logo;
  String? name;
  int tab;
  ConsumerStatefulWidget? leftTab;
  ConsumerStatefulWidget? rightTab;
  bool? diffRightTab;
  List<DownloadableKML>? rightTabData;

  TabButtonModel({
    this.logo,
    this.name,
    required this.tab,
    this.leftTab,
    this.rightTab,
    this.diffRightTab = false,
    this.rightTabData,
  });
}
