import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../constants/text_styles.dart';
import '../../providers/data_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/extensions.dart';
import '../../utils/helper.dart';
import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../providers/page_providers.dart';
import 'feature_tour_widget.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AppBarState();
}

class _AppBarState extends ConsumerState<CustomAppBar> {
  TextEditingController controller = TextEditingController(text: '');
  bool listening = false;
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _startListening() async {
    _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    ref.read(searchProvider.notifier).state = result.recognizedWords;
    controller.text = result.recognizedWords;
  }

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    bool isConnectedToInternet = ref.watch(isConnectedToInternetProvider);
    bool isLoading = ref.watch(isLoadingProvider);
    double? loadingPercentage = ref.watch(loadingPercentageProvider);
    bool isHomePage = ref.watch(isHomePageProvider);
    int tab = ref.watch(tabProvider);
    FeaturesTourController featuresTourController =
        ref.watch(featureTourControllerHomepageProvider);
    return Column(
      children: [
        Container(
          height: Const.appBarHeight - 10,
          color: themes.normalColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate('title'),
                      style: textStyleBold.copyWith(
                          color: themes.oppositeColor,
                          fontSize: Const.appBarTextSize + 10),
                    ),
                    5.ph,
                    FeaturesTour(
                      index: 5,
                      introduce: FeatureTourContainer(
                        text: translate('tour.5'),
                      ),
                      introduceConfig: IntroduceConfig.copyWith(
                        quadrantAlignment: QuadrantAlignment.bottom,
                      ),
                      controller: featuresTourController,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Const.appBarTextSize - 7,
                            height: Const.appBarTextSize - 7,
                            decoration: BoxDecoration(
                                color: isConnectedToInternet
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(35.0)),
                          ),
                          5.pw,
                          Text(
                            isConnectedToInternet
                                ? translate('settings.online')
                                : translate('settings.offline'),
                            style: textStyleBold.copyWith(
                                color: isConnectedToInternet
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: Const.appBarTextSize - 6),
                          ),
                          20.pw,
                          Container(
                            width: Const.appBarTextSize - 7,
                            height: Const.appBarTextSize - 7,
                            decoration: BoxDecoration(
                                color:
                                    isConnectedToLg ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(35.0)),
                          ),
                          5.pw,
                          Text(
                            isConnectedToLg
                                ? translate('settings.connected')
                                : translate('settings.disconnected'),
                            style: textStyleBold.copyWith(
                                color:
                                    isConnectedToLg ? Colors.green : Colors.red,
                                fontSize: Const.appBarTextSize - 6),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                isHomePage && tab == 0
                    ? FeaturesTour(
                  index: 4,
                  introduce: FeatureTourContainer(
                    text: translate('tour.4'),
                  ),
                  introduceConfig: IntroduceConfig.copyWith(
                    quadrantAlignment: QuadrantAlignment.bottom,
                  ),
                      controller: featuresTourController,
                      child: SizedBox(
                          width: 350,
                          height: Const.appBarHeight - 30,
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    if (listening) {
                                      _stopListening();
                                      showSnackBar(
                                          context: context,
                                          message: translate('settings.mic_off'));
                                    } else {
                                      _startListening();
                                      showSnackBar(
                                          context: context,
                                          message: translate('settings.mic_on'));
                                    }
                                    setState(() {
                                      listening = !listening;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13.0, right: 8),
                                    child: Icon(
                                      listening
                                          ? Icons.mic
                                          : Icons.mic_off_rounded,
                                      color: !listening
                                          ? themes.oppositeColor
                                          : Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ref.read(searchProvider.notifier).state = '';
                                    controller.text = '';
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13.0, right: 8),
                                    child: Icon(
                                      Icons.close,
                                      color: themes.oppositeColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 25),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: !listening
                                            ? themes.oppositeColor
                                            : Colors.green,
                                        width: 3),
                                    borderRadius: BorderRadius.circular(35.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: !listening
                                            ? themes.oppositeColor
                                            : Colors.green,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(35.0)),
                                hintText: translate('search'),
                                hintStyle: textStyleNormal.copyWith(
                                    color: themes.oppositeColor.withOpacity(0.5),
                                    fontSize: 16)),
                            style: textStyleNormal.copyWith(
                                color: themes.oppositeColor, fontSize: 16),
                            controller: controller,
                            onChanged: (val) {
                              ref.read(searchProvider.notifier).state = val;
                            },
                          ),
                        ),
                    )
                    : Container(),
              ],
            ),
          ),
        ),
        SizedBox(
            height: 3,
            child: isLoading
                ? LinearProgressIndicator(
                    value: loadingPercentage != -1 ? loadingPercentage : null,
                    backgroundColor: themes.normalColor,
                    color: loadingPercentage == null
                        ? loadingPercentage != -1
                            ? lightenColor(themes.highlightColor, 0.2)
                            : Colors.green
                        : Colors.green,
                  )
                : const SizedBox.shrink()),
        7.ph
      ],
    );
  }
}
