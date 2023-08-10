import 'dart:io';
import 'dart:math';

import 'package:features_tour/features_tour.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';

import '../../connections/ssh.dart';
import '../../constants/constants.dart';
import '../../kml_makers/balloon_makers.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/csv_parser.dart';
import '../../utils/helper.dart';
import '../dashboard/downloadable_content.dart';
import '../dashboard/widgets/charts/line_chart_parser.dart';
import '../dashboard/widgets/charts/pie_chart_parser.dart';
import '../dashboard/widgets/dashboard_container.dart';
import '../dashboard/widgets/google_map.dart';
import '../panels/feature_tour_widget.dart';

class VisualizerPage extends ConsumerStatefulWidget {
  const VisualizerPage({super.key});

  @override
  ConsumerState createState() => _VisualizerPageState();
}

class _VisualizerPageState extends ConsumerState<VisualizerPage> {
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  int chartType = 0;
  int chartYNumbers = 1;
  List<List<dynamic>>? chartData;
  List<List<dynamic>> chartDataForVisualization = [];
  bool downloaded = false;
  List<Color> chartColors = [Colors.primaries[Random()
      .nextInt(Colors.primaries.length)]];
  List<TextEditingController> chartYControllers = [TextEditingController(text: '0')];
  TextEditingController chartXController = TextEditingController(text: '0');
  TextEditingController csvUrlController = TextEditingController(text: '');
  TextEditingController kmlUrlController = TextEditingController(text: '');

  visualizeCSV() async {
    try {
      ref.read(isLoadingProvider.notifier).state = true;
      downloaded = false;
      Map<String, Map<String, String>> content = {
        'Visualizer': {
          'url': csvUrlController.text,
          'filename': 'visualizer_csv.csv',
          'directory': 'Visualizer'
        },
      };
      await Downloader(ref: ref).downloadAllContent(content);
      List<List<dynamic>>? data =
          await FileParser.parseCSVFromStorage(content['Visualizer']!);
      setState(() {
        chartData = FileParser.transformer(data);
        for (int i = 0; i < chartYNumbers; i++) {
          chartDataForVisualization
              .add(chartData![int.parse(chartYControllers[i].text)]);
        }
        downloaded = true;
      });
      ref.read(isLoadingProvider.notifier).state = false;
    } catch (error) {
      showSnackBar(
          context: context, message: translate('visualizer.download_failed'));
    }
  }

  visualizeKML() async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      await Downloader(ref: ref).downloadKml(kmlUrlController.text);
      if (!mounted) {
        return;
      }
      await SSH(ref: ref).kmlFileUpload(
          context,
          File('${localPath.path}/${Const.kmlCustomFileName}.kml'),
          Const.kmlCustomFileName);
      if (!mounted) {
        return;
      }
      await SSH(ref: ref).runKml(context, Const.kmlCustomFileName);
      if (!mounted) {
        return;
      }
      showSnackBar(
          context: context, message: translate('settings.kml_success'));
      ref.read(isLoadingProvider.notifier).state = false;
    } catch (error) {
      showSnackBar(
          context: context, message: translate('visualizer.download_failed'));
    }
  }

  Future<bool> colorPickerDialog(
      int index, Color highlightColor, Color oppositeColor) async {
    return ColorPicker(
      color: chartColors[index],
      onColorChanged: (Color color) =>
          setState(() => chartColors[index] = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      enableOpacity: true,
      heading: Text(
        'Select color',
        style: textStyleNormal.copyWith(
          color: oppositeColor,
          fontSize: 20,
        ),
      ),
      subheading: Text(
        'Select color shade',
        style: textStyleNormal.copyWith(
          color: oppositeColor,
          fontSize: 15,
        ),
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: textStyleNormal.copyWith(
          color: oppositeColor,
          fontSize: 15,
        ),
      ),
      selectedPickerTypeColor: lightenColor(highlightColor, 0.2),
      pickerTypeTextStyle: textStyleNormal.copyWith(
        color: oppositeColor,
        fontSize: 10,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: textStyleNormal.copyWith(
        color: oppositeColor,
        fontSize: 15,
      ),
      colorNameTextStyle: textStyleNormal.copyWith(
        color: oppositeColor,
        fontSize: 15,
      ),
      colorCodeTextStyle: textStyleNormal.copyWith(
        color: oppositeColor,
        fontSize: 15,
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      backgroundColor: lightenColor(highlightColor).withOpacity(0.9),
      elevation: 0,
      titleTextStyle: textStyleNormal.copyWith(
        color: oppositeColor,
        fontSize: 10,
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  showFeatureTour() async {
    if(ref.read(showVisualizerTourProvider)) {
      ref.read(featureTourControllerVisualizerProvider).start(
        context: context,
        delay: Duration.zero,
        force: true,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showVisualizerTour', false);
      ref.read(showVisualizerTourProvider.notifier).state = false;
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(featureTourControllerVisualizerProvider).start(
      context: context,
      delay: Duration.zero,
      force: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    FeaturesTourController featuresTourVisualizerController =
      ref.watch(featureTourControllerVisualizerProvider);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: Const.appBarHeight),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: Const.animationDuration,
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: -Const.animationDistance,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
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
                    Text(
                      '${translate('visualizer.url')}:  ',
                      style: textStyleNormal.copyWith(
                          color: oppositeColor, fontSize: 25),
                    ),
                    FeaturesTour(
                      index: 0,
                      controller: featuresTourVisualizerController,
                      introduce: FeatureTourContainer(
                        text: translate('tour.v0'),
                      ),
                      introduceConfig: IntroduceConfig.copyWith(
                        quadrantAlignment: QuadrantAlignment.bottom,
                      ),
                      child: TextFormFieldCustom(
                        controller: csvUrlController,
                        hintText: translate('visualizer.download_url_hint'),
                      ),
                    ),
                    FeaturesTour(
                      index: 1,
                      controller: featuresTourVisualizerController,
                      introduce: FeatureTourContainer(
                        text: translate('tour.v1'),
                      ),
                      introduceConfig: IntroduceConfig.copyWith(
                        quadrantAlignment: QuadrantAlignment.bottom,
                      ),
                      child: Container(
                        height: 50,
                        width: screenSize(context).width / 2 -
                            20 -
                            screenSize(context).width / Const.tabBarWidthDivider,
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
                                      ? lightenColor(tabBarColor)
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
                                    ? lightenColor(tabBarColor)
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
                      FeaturesTour(
                        index: 2,
                        controller: featuresTourVisualizerController,
                        introduce: FeatureTourContainer(
                          text: translate('tour.v2'),
                        ),
                        introduceConfig: IntroduceConfig.copyWith(
                          quadrantAlignment: QuadrantAlignment.bottom,
                        ),
                        child: TextFormFieldIntegerCustom(
                          controller: chartXController,
                          hintText: translate('visualizer.column_no_hint'),
                        ),
                      ),
                      FeaturesTour(
                        index: 3,
                        controller: featuresTourVisualizerController,
                        introduce: FeatureTourContainer(
                          text: translate('tour.v3'),
                        ),
                        introduceConfig: IntroduceConfig.copyWith(
                          quadrantAlignment: QuadrantAlignment.bottom,
                        ),
                        child: ControllerValueControl(
                          controller: chartXController,
                          oppositeColor: oppositeColor,
                        ),
                      )
                    ]),
                (Const.dashboardUISpacing * 3).ph,
                chartType == 0
                    ? Column(
                        children: [
                          Text(
                            '${translate('visualizer.ploty')}:  ',
                            style: textStyleNormal.copyWith(
                                color: oppositeColor, fontSize: 25),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: chartYNumbers,
                              itemBuilder: (_, index) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        FeaturesTour(
                                          index: 5,
                                          controller: featuresTourVisualizerController,
                                          introduce: FeatureTourContainer(
                                            text: translate('tour.v5'),
                                          ),
                                          introduceConfig: IntroduceConfig.copyWith(
                                            quadrantAlignment: QuadrantAlignment.bottom,
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                minimumSize: Size.zero,
                                                padding: EdgeInsets.zero,
                                                backgroundColor:
                                                    Colors.transparent,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(Const
                                                                .dashboardUIRoundness *
                                                            100),
                                                    side: const BorderSide(
                                                        color: Colors.red,
                                                        width: 1))),
                                            onPressed: () {
                                              setState(() {
                                                chartYNumbers--;
                                                chartColors.removeAt(index);
                                                chartYControllers.removeAt(index);
                                              });
                                            },
                                            child: const SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FeaturesTour(
                                          index: 6,
                                          controller: featuresTourVisualizerController,
                                          introduce: FeatureTourContainer(
                                            text: translate('tour.v6'),
                                          ),
                                          introduceConfig: IntroduceConfig.copyWith(
                                            quadrantAlignment: QuadrantAlignment.bottom,
                                          ),
                                          child: TextFormFieldIntegerCustom(
                                            controller: chartYControllers[index],
                                            hintText: translate(
                                                'visualizer.column_no_hint'),
                                          ),
                                        ),
                                        ControllerValueControl(
                                          controller: chartYControllers[index],
                                          oppositeColor: oppositeColor,
                                        ),
                                        FeaturesTour(
                                          index: 7,
                                          controller: featuresTourVisualizerController,
                                          introduce: FeatureTourContainer(
                                            text: translate('tour.v7'),
                                          ),
                                          introduceConfig: IntroduceConfig.copyWith(
                                            quadrantAlignment: QuadrantAlignment.bottom,
                                          ),
                                          child: ColorIndicator(
                                            width: 50,
                                            height: 50,
                                            borderRadius: 400,
                                            color: chartColors[index],
                                            onSelectFocus: false,
                                            onSelect: () async {
                                              final Color colorBeforeDialog =
                                                  chartColors[index];
                                              if (!(await colorPickerDialog(
                                                  index,
                                                  highlightColor,
                                                  oppositeColor))) {
                                                setState(() {
                                                  chartColors[index] =
                                                      colorBeforeDialog;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ])),
                          (Const.dashboardUISpacing * 1).ph,
                          FeaturesTour(
                            index: 4,
                            controller: featuresTourVisualizerController,
                            introduce: FeatureTourContainer(
                              text: translate('tour.v4'),
                            ),
                            introduceConfig: IntroduceConfig.copyWith(
                              quadrantAlignment: QuadrantAlignment.bottom,
                            ),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(300),
                                        side: const BorderSide(
                                            color: Colors.green, width: 1))),
                                onPressed: () {
                                  setState(() {
                                    chartColors.add(Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]);
                                    chartYControllers
                                        .add(TextEditingController(text: '0'));
                                    chartYNumbers++;
                                  });
                                },
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
                (Const.dashboardUISpacing * 4).ph,
                FeaturesTour(
                  index: 8,
                  controller: featuresTourVisualizerController,
                  introduce: FeatureTourContainer(
                    text: translate('tour.v8'),
                  ),
                  introduceConfig: IntroduceConfig.copyWith(
                    quadrantAlignment: QuadrantAlignment.top,
                  ),
                  child: DownloadButton(
                    onPressed: () async {
                      await visualizeCSV();
                    },
                    highlightColor: lightenColor(tabBarColor),
                    oppositeColor: oppositeColor,
                  ),
                ),
                (Const.dashboardUISpacing * 4).ph,
                downloaded
                    ? chartType == 0
                        ? LineChartParser(
                            title: '',
                            chartData: {},
                            legendX: '',
                          ).chartParserForVisualizer(
                            limitMarkerX: 5,
                            dataX: chartData![int.parse(chartXController.text)],
                            dataY: chartDataForVisualization,
                            chartColors: chartColors)
                        : PieChartParser(title: '', subTitle: '')
                            .chartParserForVisualizer(
                                data: chartData![
                                    int.parse(chartXController.text)])
                    // :Container()
                    : const SizedBox.shrink(),
                (Const.dashboardUISpacing * 9).ph,
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
                (Const.dashboardUISpacing * 3).ph,
                SizedBox(
                    height: 400,
                    width: screenSize(context).width - 300,
                    child: const GoogleMapPart(
                      visualizer: true,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${translate('visualizer.url')}:  ',
                      style: textStyleNormal.copyWith(
                          color: oppositeColor, fontSize: 25),
                    ),
                    TextFormFieldCustom(
                      controller: kmlUrlController,
                      hintText: translate('visualizer.download_url_hint'),
                      kml: true,
                    ),
                  ],
                ),
                (Const.dashboardUISpacing * 2).ph,
                DownloadButton(
                  onPressed: () {},
                  highlightColor: lightenColor(tabBarColor),
                  oppositeColor: oppositeColor,
                ),
                (Const.dashboardUISpacing * 4).ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControllerValueControl extends StatelessWidget {
  const ControllerValueControl(
      {super.key, required this.controller, required this.oppositeColor});
  final TextEditingController controller;
  final Color oppositeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness),
                  side: BorderSide(color: oppositeColor, width: 1))),
          onPressed: () {
            controller.text = (int.parse(controller.text) - 1).toString();
          },
          child: SizedBox(
            height: 50,
            width: 30,
            child: Icon(
              Icons.arrow_back_rounded,
              color: oppositeColor,
              size: 20,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness),
                  side: BorderSide(color: oppositeColor, width: 1))),
          onPressed: () {
            controller.text = (int.parse(controller.text) + 1).toString();
          },
          child: SizedBox(
            height: 50,
            width: 30,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: oppositeColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton(
      {super.key,
      required this.onPressed,
      required this.highlightColor,
      required this.oppositeColor});
  final Function onPressed;
  final Color highlightColor;
  final Color oppositeColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: highlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300),
          )),
      onPressed: () async {
        await onPressed();
      },
      child: SizedBox(
        height: 50,
        width: screenSize(context).width - 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download,
              size: 30,
              color: oppositeColor,
            ),
            5.pw,
            Text(
              translate('visualizer.download'),
              style: textStyleBold.copyWith(color: oppositeColor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormFieldCustom extends ConsumerWidget {
  const TextFormFieldCustom(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.kml = false})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool kml;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: kml
            ? screenSize(context).width -
                150 -
                screenSize(context).width / Const.tabBarWidthDivider
            : screenSize(context).width / 1.75  -
                screenSize(context).width / Const.tabBarWidthDivider,
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
          onChanged: (newValue) {
            print(newValue);
            controller.text = newValue ?? '';
          },
          style: textStyleNormal.copyWith(color: oppositeColor, fontSize: 17),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: controller,
        ),
      ),
    );
  }
}
