import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/downloadable_content.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../connections/ssh.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsPage> {
  final CameraPosition initialMapPosition = const CameraPosition(
    target: LatLng(51.4769, 0.0),
    zoom: 2,
  );

  TextEditingController ipController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController portController = TextEditingController(text: '');
  TextEditingController rigsController = TextEditingController(text: '');
  late SharedPreferences prefs;
  late String dropdownValue;

  setSharedPrefs() async {
    await prefs.setString('ip', ipController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setInt('port', int.parse(portController.text));
    await prefs.setInt('rigs', int.parse(rigsController.text));
    ref.read(ipProvider.notifier).state = ipController.text;
    ref.read(usernameProvider.notifier).state = usernameController.text;
    ref.read(passwordProvider.notifier).state = passwordController.text;
    ref.read(portProvider.notifier).state = int.parse(portController.text);
    setRigs(int.parse(rigsController.text), ref);
  }

  initTextControllers() async {
    setState(() {
      dropdownValue = ref.read(languageProvider);
      ipController.text = ref.read(ipProvider);
      usernameController.text = ref.read(usernameProvider);
      passwordController.text = ref.read(passwordProvider);
      portController.text = ref.read(portProvider).toString();
      rigsController.text = ref.read(rigsProvider).toString();
    });
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = false;
    });
    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Const.appBarHeight.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimationLimiter(
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
                      TextFormFieldCustom(
                        icon: Icons.network_check_rounded,
                        hintText: 'IP address',
                        controller: ipController,
                      ),
                      TextFormFieldCustom(
                        icon: Icons.person,
                        hintText: 'LG Username',
                        controller: usernameController,
                      ),
                      TextFormFieldCustom(
                        icon: Icons.key_rounded,
                        hintText: 'LG Password',
                        controller: passwordController,
                      ),
                      TextFormFieldCustom(
                        icon: Icons.key_rounded,
                        hintText: 'SSH Port',
                        controller: portController,
                      ),
                      TextFormFieldCustom(
                        icon: Icons.key_rounded,
                        hintText: 'No. of LG rigs',
                        controller: rigsController,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: VerticalDivider(
                  color: Themes.darkWhiteColor,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Const.animationDuration,
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      100.ph,
                      // Container(
                      //   width: screenSize(context).width/2 - 200,
                      //   child: Row(
                      //     children: [
                      //       Text(TextConst.theme,
                      //       style: textStyleBoldWhite.copyWith(fontSize: 20),
                      //       )
                      //     ],
                      //   )
                      // ),
                      20.ph,
                      SizedBox(
                        width: screenSize(context).width / 2 - 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TextConst.language,
                              style: textStyleBoldWhite.copyWith(fontSize: 20),
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              dropdownColor:
                                  darkenColor(Themes.darkColor, 0.02),
                              elevation: 10,
                              style:
                                  textStyleNormalWhite.copyWith(fontSize: 15),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: TextConst.langList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          30.ph,
          AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Const.animationDuration,
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: -Const.animationDistance,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  TextButtonCustom(
                    onPressed: () async {
                      if (!isConnectedToLg) {
                        await setSharedPrefs();
                        await SSH(ref: ref).connect();
                        await SSH(ref: ref).renderInSlave(
                            ref.read(leftmostRigProvider),
                            KMLMakers.screenOverlayImage(
                                ImageConst.splashOnline,
                                Const.splashAspectRatio));
                        await SSH(ref: ref).flyTo(
                            initialMapPosition.target.latitude,
                            initialMapPosition.target.longitude,
                            initialMapPosition.zoom.zoomLG,
                            initialMapPosition.tilt,
                            initialMapPosition.bearing);
                      } else {
                        await SSH(ref: ref).disconnect();
                      }
                    },
                    name: isConnectedToLg
                        ? TextConst.disconnect
                        : TextConst.connect,
                    width: screenSize(context).width - 400,
                    icon: isConnectedToLg
                        ? Icons.cloud_off
                        : Icons.cast_connected_rounded,
                    color: isConnectedToLg ? Colors.red : Colors.green,
                    ref: ref,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimationLimiter(
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
                      TextButtonCustom(
                        onPressed: () async {},
                        name: TextConst.deleteCSV,
                        width: screenSize(context).width / 2 - 200,
                        icon: Icons.delete_forever_rounded,
                        color: darkenColor(Colors.red),
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: VerticalDivider(
                  color: Themes.darkWhiteColor,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Const.animationDuration,
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      TextButtonCustom(
                        onPressed: () async {},
                        name: TextConst.deleteCSV,
                        width: screenSize(context).width / 2 - 200,
                        icon: Icons.delete_forever_rounded,
                        color: darkenColor(Colors.red),
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Const.animationDuration,
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: Const.animationDistance,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  TextButtonCustom(
                    onPressed: () async {
                      await Downloader(ref: ref).downloadAllContent(DownloadableContent.content);
                      await prefs.setBool('downloadableContent', true);
                      ref.read(downloadableContentAvailableProvider.notifier).state = true;
                    },
                    name: TextConst.download,
                    width: screenSize(context).width - 400,
                    icon: Icons.download_rounded,
                    color: darkenColor(Colors.blue),
                    ref: ref,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimationLimiter(
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
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).cleanSlaves();
                          }
                        },
                        name: isConnectedToLg ? TextConst.cleanLogo : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.cleaning_services_rounded,
                        color: isConnectedToLg
                            ? darkenColor(Colors.orange, 0.05)
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).renderInSlave(
                                ref.read(leftmostRigProvider),
                                KMLMakers.screenOverlayImage(
                                    ImageConst.splashOnline,
                                    Const.splashAspectRatio));
                          }
                        },
                        name: isConnectedToLg ? TextConst.showLogo : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.logo_dev_rounded,
                        color: isConnectedToLg
                            ? darkenColor(Colors.orange, 0.05)
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).cleanKML();
                          }
                        },
                        name: isConnectedToLg ? TextConst.cleanKML : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.cleaning_services_rounded,
                        color: isConnectedToLg
                            ? darkenColor(Colors.orange, 0.05)
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: VerticalDivider(
                  color: Themes.darkWhiteColor,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Const.animationDuration,
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).setRefresh();
                          }
                        },
                        name: isConnectedToLg ? TextConst.setRefresh : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.restart_alt_rounded,
                        color: isConnectedToLg
                            ? Colors.blue
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).resetRefresh();
                          }
                        },
                        name: isConnectedToLg ? TextConst.resetRefresh : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.restart_alt_rounded,
                        color: isConnectedToLg
                            ? Colors.blue
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: VerticalDivider(
                  color: Themes.darkWhiteColor,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Const.animationDuration,
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).relaunchLG();
                          }
                        },
                        name: isConnectedToLg ? TextConst.relaunchLG : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.power_rounded,
                        color: isConnectedToLg
                            ? Colors.redAccent
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).rebootLG();
                          }
                        },
                        name: isConnectedToLg ? TextConst.rebootLG : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.settings_power_rounded,
                        color: isConnectedToLg
                            ? Colors.redAccent
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                      TextButtonCustom(
                        onPressed: () async {
                          if (isConnectedToLg) {
                            await SSH(ref: ref).shutdownLG();
                          }
                        },
                        name: isConnectedToLg ? TextConst.shutdownLG : '--',
                        width: screenSize(context).width / 3 - 150,
                        icon: Icons.power_settings_new_rounded,
                        color: isConnectedToLg
                            ? Colors.redAccent
                            : lightenColor(Themes.darkColor, 0.01),
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextButtonCustom extends StatelessWidget {
  const TextButtonCustom({
    Key? key,
    required this.onPressed,
    required this.name,
    required this.width,
    required this.color,
    required this.ref,
    required this.icon,
  }) : super(key: key);

  final Function onPressed;
  final String name;
  final IconData icon;
  final double width;
  final Color color;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: color.withOpacity(1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
                side: name == '--'
                    ? BorderSide(color: lightenColor(Themes.darkColor))
                    : BorderSide.none)),
        onPressed: () async {
          ref.read(isLoadingProvider.notifier).state = true;
          await onPressed();
          ref.read(isLoadingProvider.notifier).state = false;
        },
        child: SizedBox(
          height: 50,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              name != '--'
                  ? Row(
                      children: [
                        Icon(
                          icon,
                          size: 25,
                          color: Colors.white,
                        ),
                        5.pw,
                      ],
                    )
                  : const SizedBox.shrink(),
              Text(
                name,
                style: textStyleBoldWhite.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData icon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: screenSize(context).width / 2 - 200,
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Themes.darkWhiteColor,
              size: 20,
            ),
            labelText: hintText,
            labelStyle: textStyleNormal.copyWith(
                fontSize: 17, color: Themes.darkWhiteColor.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Themes.darkWhiteColor, width: 1),
            ),
          ),
          style: textStyleNormalWhite.copyWith(fontSize: 17),
          controller: controller,
        ),
      ),
    );
  }
}
