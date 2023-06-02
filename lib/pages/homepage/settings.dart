import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../providers/page_providers.dart';
import '../../ssh_lg/ssh.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
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
    prefs = await SharedPreferences.getInstance();
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

  initTextControllers() {
    setState(() {
      dropdownValue = ref.read(languageProvider);
      ipController.text = ref.read(ipProvider);
      usernameController.text = ref.read(usernameProvider);
      passwordController.text = ref.read(passwordProvider);
      portController.text = ref.read(portProvider).toString();
      rigsController.text = ref.read(rigsProvider).toString();
    });
  }

  @override
  void initState() {
    super.initState();
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
              Column(
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
              SizedBox(
                height: 300,
                child: VerticalDivider(
                  color: Themes.darkWhiteColor,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              Column(
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
                          dropdownColor: darkenColor(Themes.darkColor, 0.02),
                          elevation: 10,
                          style: textStyleNormalWhite.copyWith(fontSize: 15),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: TextConst.langList
                              .map<DropdownMenuItem<String>>((String value) {
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
            ],
          ),
          20.ph,
          TextButtonCustom(
            onPressed: () async {
              if (!isConnectedToLg) {
                await setSharedPrefs();
                await SSH(ref: ref).connect();
                await SSH(ref: ref).renderInSlave(
                    ref.read(leftmostRigProvider),
                    KMLMakers.screenOverlayImage(
                        ImageConst.splashOnline, Const.splashAspectRatio));
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
            name: isConnectedToLg ? TextConst.disconnect : TextConst.connect,
            width: screenSize(context).width - 400,
            color: isConnectedToLg ? Colors.red : Colors.green,
          ),
          20.ph,
          Divider(
            color: Themes.darkWhiteColor,
            indent: 100,
            endIndent: 100,
          ),
          20.ph,
          SizedBox(
            width: screenSize(context).width - 385,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).cleanSlaves();
                    }
                  },
                  name: isConnectedToLg ? TextConst.cleanLogo : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.yellow
                      : lightenColor(Themes.darkColor, 0.01),
                ),
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).renderInSlave(
                          ref.read(leftmostRigProvider),
                          KMLMakers.screenOverlayImage(ImageConst.splashOnline,
                              Const.splashAspectRatio));
                    }
                  },
                  name: isConnectedToLg ? TextConst.showLogo : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.yellow
                      : lightenColor(Themes.darkColor, 0.01),
                ),
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).cleanKML();
                    }
                  },
                  name: isConnectedToLg ? TextConst.cleanKML : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.yellow
                      : lightenColor(Themes.darkColor, 0.01),
                ),
              ],
            ),
          ),
          10.ph,
          SizedBox(
            width: screenSize(context).width - 385,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).setRefresh();
                    }
                  },
                  name: isConnectedToLg ? TextConst.setRefresh : '--',
                  width: screenSize(context).width / 2 - 215,
                  color: isConnectedToLg
                      ? Colors.blue
                      : lightenColor(Themes.darkColor, 0.01),
                ),
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).resetRefresh();
                    }
                  },
                  name: isConnectedToLg ? TextConst.resetRefresh : '--',
                  width: screenSize(context).width / 2 - 215,
                  color: isConnectedToLg
                      ? Colors.blue
                      : lightenColor(Themes.darkColor, 0.01),
                ),
              ],
            ),
          ),
          10.ph,
          SizedBox(
            width: screenSize(context).width - 385,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).relaunchLG();
                    }
                  },
                  name: isConnectedToLg ? TextConst.relaunchLG : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.redAccent
                      : lightenColor(Themes.darkColor, 0.01),
                ),
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).rebootLG();
                    }
                  },
                  name: isConnectedToLg ? TextConst.rebootLG : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.redAccent
                      : lightenColor(Themes.darkColor, 0.01),
                ),
                TextButtonCustom(
                  onPressed: () async {
                    if (isConnectedToLg) {
                      await SSH(ref: ref).shutdownLG();
                    }
                  },
                  name: isConnectedToLg ? TextConst.shutdownLG : '--',
                  width: screenSize(context).width / 3 - 150,
                  color: isConnectedToLg
                      ? Colors.redAccent
                      : lightenColor(Themes.darkColor, 0.01),
                ),
              ],
            ),
          ),
          30.ph,
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
  }) : super(key: key);

  final Function onPressed;
  final String name;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color.withOpacity(0.7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
              side: BorderSide(color: Themes.darkWhiteColor))),
      onPressed: () async => await onPressed(),
      child: SizedBox(
        height: 50,
        width: width,
        child: Center(
          child: Text(
            name,
            style: textStyleBoldWhite.copyWith(fontSize: 15),
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
