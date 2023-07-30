import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';

import '../../constants/constants.dart';
import '../../providers/settings_providers.dart';
import '../../utils/helper.dart';

class VisualizerPage extends ConsumerStatefulWidget {
  const VisualizerPage({super.key});

  @override
  ConsumerState createState() => _VisualizerPageState();
}

class _VisualizerPageState extends ConsumerState<VisualizerPage> {
  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: Const.appBarHeight),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Const.dashboardUIRoundness*3),
                color: highlightColor,
              ),
              child: Center(
                child: Text(
                  translate('visualizer.csv_title'),
                  style: textStyleBold.copyWith(
                      color: oppositeColor, fontSize: 40),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  translate('visualizer.csv_title'),
                  style: textStyleNormal.copyWith(
                      color: oppositeColor, fontSize: 40),
                ),
              ],
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Const.dashboardUIRoundness*3),
                color: highlightColor,
              ),
              child: Center(
                child: Text(
                  translate('visualizer.kml_title'),
                  style: textStyleBold.copyWith(
                      color: oppositeColor, fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormFieldCustom extends ConsumerWidget {
  const TextFormFieldCustom({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: screenSize(context).width / 2 - 200,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: textStyleNormal.copyWith(
                fontSize: 17, color: oppositeColor.withOpacity(0.5)),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: oppositeColor, width: 1),
            ),
          ),
          style: textStyleNormal.copyWith(color: oppositeColor, fontSize: 17),
          controller: controller,
        ),
      ),
    );
  }
}