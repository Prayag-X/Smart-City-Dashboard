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
  int chartType = 0;

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
                borderRadius:
                    BorderRadius.circular(Const.dashboardUIRoundness * 3),
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
            (Const.dashboardUISpacing * 6).ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    '${translate('visualizer.url')}:  ',
                    style: textStyleNormal.copyWith(
                        color: oppositeColor, fontSize: 25),
                  ),
                  TextFormFieldCustom(
                    controller: TextEditingController(),
                    hintText: 'hola',
                  ),
                ]),
                Container(
                  height: 50,
                  width: screenSize(context).width / 2 - 150,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Const.dashboardUIRoundness),
                    border: Border.all(
                      color: highlightColor,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            chartType = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: chartType == 0
                                ? highlightColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    Const.dashboardUIRoundness - 3),
                                bottomLeft: Radius.circular(
                                    Const.dashboardUIRoundness - 3)),
                          ),
                          child: Center(
                              child: Text(
                            translate('visualizer.line_chart'),
                            style: textStyleNormal.copyWith(
                                color: oppositeColor,
                                fontSize: Const.dashboardTextSize),
                          )),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            chartType = 1;
                          });
                        },
                        child: Container(
                          color: chartType == 1
                              ? highlightColor
                              : Colors.transparent,
                          child: Center(
                              child: Text(
                            translate('visualizer.pie_chart'),
                            style: textStyleNormal.copyWith(
                                color: oppositeColor,
                                fontSize: Const.dashboardTextSize),
                          )),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            (Const.dashboardUISpacing * 3).ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                '${translate('visualizer.plotx')}:  ',
                style: textStyleNormal.copyWith(
                    color: oppositeColor, fontSize: 25),
              ),
              TextFormFieldIntegerCustom(
                controller: TextEditingController(),
                hintText: 'hola',
              ),
              ControllerValueControl(controller: TextEditingController(), oppositeColor: oppositeColor,)
            ]),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Const.dashboardUIRoundness * 3),
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

class ControllerValueControl extends StatefulWidget {
  const ControllerValueControl({super.key, required this.controller, required this.oppositeColor});
  final TextEditingController controller;
  final Color oppositeColor;

  @override
  State<ControllerValueControl> createState() => _ControllerValueControlState();
}

class _ControllerValueControlState extends State<ControllerValueControl> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: widget.oppositeColor,
            size: 20,
          ),
        ),
        5.pw,
        Container(
          height: 50,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: widget.oppositeColor,
            size: 20,
          ),
        ),
      ],
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

class TextFormFieldIntegerCustom extends ConsumerWidget {
  const TextFormFieldIntegerCustom({
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
        width: screenSize(context).width -
            screenSize(context).width / Const.tabBarWidthDivider -
            300,
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
