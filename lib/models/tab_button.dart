import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabButtonModel {
  String? logo;
  String? name;
  int tab;
  ConsumerStatefulWidget? leftTab;
  ConsumerStatefulWidget? rightTab;

  TabButtonModel({
    this.logo,
    this.name,
    required this.tab,
    this.leftTab,
    this.rightTab,
  });
}
