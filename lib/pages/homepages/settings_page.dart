import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../connections/downloader.dart';
import '../../pages/dashboard/downloadable_content.dart';
import '../../constants/images.dart';
import '../../constants/text_styles.dart';
import '../../kml_makers/kml_makers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/extensions.dart';
import '../../utils/helper.dart';
import '../../constants/constants.dart';
import '../../connections/ssh.dart';
import '../../constants/theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsPage> {
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

  connectionSection() {
    Themes themes = ref.watch(themesProvider);
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    bool darkMode = ref.watch(darkModeOnProvider);
    double widgetSize = screenSize(context).width / 2 - 200;
    return Column(
      children: [
        TitleContainer(title: translate('settings.connection_management')),
        30.ph,
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
                      icon: Icons.private_connectivity_rounded,
                      hintText: 'SSH Port',
                      controller: portController,
                    ),
                    TextFormFieldCustom(
                      icon: Icons.monitor,
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
                color: themes.oppositeColor,
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
                    SizedBox(
                        width: widgetSize,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('settings.theme'),
                              style: textStyleBold.copyWith(
                                  color: themes.oppositeColor, fontSize: 20),
                            ),
                            FlutterSwitch(
                              width: 70.0,
                              height: 35.0,
                              valueFontSize: 10.0,
                              toggleSize: 25.0,
                              activeColor: Colors.black,
                              inactiveColor: Colors.white,
                              toggleColor: Colors.blue,
                              value: darkMode,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: false,
                              onToggle: (val) async {
                                setState(() {
                                  ref.read(darkModeOnProvider.notifier).state =
                                      val;
                                });
                                if (val == true) {
                                  await prefs.setBool('theme', true);
                                  ref.read(themesProvider.notifier).state = ThemesDark();
                                } else {
                                  await prefs.setBool('theme', false);
                                  ref.read(themesProvider.notifier).state = ThemesLight();
                                }
                              },
                            ),
                          ],
                        )),
                    20.ph,
                    SizedBox(
                      width: widgetSize,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate('settings.language'),
                            style: textStyleBold.copyWith(
                                color: themes.oppositeColor, fontSize: 20),
                          ),
                          DropdownButton<String>(
                            value: dropdownValue,
                            dropdownColor: darkenColor(themes.normalColor, 0.02),
                            elevation: 10,
                            style: textStyleNormal.copyWith(
                                color: themes.oppositeColor, fontSize: 15),
                            onChanged: (String? value) async {
                              setState(() {
                                dropdownValue = value!;
                              });
                              await prefs.setString('language', value!);
                              if (!mounted) {
                                return;
                              }
                              ref.read(languageProvider.notifier).state = value;
                              changeLocale(
                                  context,
                                  Const.availableLanguageCodes[
                                      Const.availableLanguages.indexOf(value)]);
                            },
                            items: Const.availableLanguages
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
                      if (!mounted) {
                        return;
                      }
                      await SSH(ref: ref).connect(
                        context,
                      );
                      if (!mounted) {
                        return;
                      }
                      await SSH(ref: ref).cleanBalloon(
                        context,
                      );
                      if (!mounted) {
                        return;
                      }
                      await SSH(ref: ref).renderInSlave(
                          context,
                          ref.read(leftmostRigProvider),
                          KMLMakers.screenOverlayImage(ImageConst.splashOnline,
                              Const.splashAspectRatio));
                      if (!mounted) {
                        return;
                      }
                      await SSH(ref: ref).flyTo(
                          context,
                          Const.initialMapPosition.target.latitude,
                          Const.initialMapPosition.target.longitude,
                          Const.initialMapPosition.zoom.zoomLG,
                          Const.initialMapPosition.tilt,
                          Const.initialMapPosition.bearing);
                    } else {
                      await SSH(ref: ref).disconnect(
                        context,
                      );
                    }
                  },
                  name: isConnectedToLg
                      ? translate('settings.disconnect')
                      : translate('settings.connect'),
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
        70.ph,
      ],
    );
  }

  contentSection() {
    Themes themes = ref.watch(themesProvider);
    double widgetSize = screenSize(context).width / 2 - 200;
    bool downloadableContentAvailable =
        ref.watch(downloadableContentAvailableProvider);
    return Column(
      children: [
        TitleContainer(title: translate('settings.content_management')),
        30.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
                        showSnackBar(
                            context: context,
                            message: translate('settings.download_started'));
                        await Downloader(ref: ref)
                            .downloadAllContent(DownloadableContent.content);
                        await prefs.setBool('downloadableContent', true);
                        ref
                            .read(downloadableContentAvailableProvider.notifier)
                            .state = true;
                        if (!mounted) {
                          return;
                        }
                        showSnackBar(
                            context: context,
                            message: translate('settings.download_completed'));
                      },
                      name: translate('settings.download'),
                      width: widgetSize,
                      icon: Icons.download_rounded,
                      color: darkenColor(Colors.blue),
                      ref: ref,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: VerticalDivider(
                color: themes.oppositeColor,
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
                        var localPath =
                            await getApplicationDocumentsDirectory();
                        for (MapEntry<String, Map<String, String>> fileData
                            in DownloadableContent.content.entries) {
                          File file = File(
                              "${localPath.path}/${fileData.value['directory']}/${fileData.value['filename']}");
                          try {
                            if (downloadableContentAvailable) {
                              await file.delete();
                            }
                          } catch (error) {
                            if (!mounted) {
                              return;
                            }
                            showSnackBar(
                                context: context, message: error.toString());
                          }
                        }
                        await prefs.setBool('downloadableContent', false);
                        ref
                            .read(downloadableContentAvailableProvider.notifier)
                            .state = false;
                        if (!mounted) {
                          return;
                        }
                        File file = File(
                            "${localPath.path}/${Const.kmlCustomFileName}.kml");
                        try {
                          await file.delete();
                        } catch (error) {}
                        if (!mounted) {
                          return;
                        }
                        await SSH(ref: ref).fileDelete(
                            context, "${Const.kmlCustomFileName}.kml");
                        if (!mounted) {
                          return;
                        }
                        showSnackBar(
                            context: context,
                            message: translate('settings.delete_success'));
                      },
                      name: translate('settings.delete_kml'),
                      width: widgetSize,
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
        70.ph,
      ],
    );
  }

  lgSection() {
    Themes themes = ref.watch(themesProvider);
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    double widgetSize = screenSize(context).width / 3 - 150;
    return Column(
      children: [
        TitleContainer(title: translate('settings.lg_management')),
        30.ph,
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
                          await SSH(ref: ref).cleanSlaves(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.clean_logo')
                          : '--',
                      width: widgetSize,
                      icon: Icons.cleaning_services_rounded,
                      color: isConnectedToLg
                          ? darkenColor(Colors.orange, 0.05)
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                    TextButtonCustom(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          await SSH(ref: ref).renderInSlave(
                              context,
                              ref.read(leftmostRigProvider),
                              KMLMakers.screenOverlayImage(
                                  ImageConst.splashOnline,
                                  Const.splashAspectRatio));
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.show_logo')
                          : '--',
                      width: widgetSize,
                      icon: Icons.logo_dev_rounded,
                      color: isConnectedToLg
                          ? darkenColor(Colors.orange, 0.05)
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                    TextButtonCustom(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          await SSH(ref: ref).cleanKML(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.clean_kml')
                          : '--',
                      width: widgetSize,
                      icon: Icons.cleaning_services_rounded,
                      color: isConnectedToLg
                          ? darkenColor(Colors.orange, 0.05)
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: VerticalDivider(
                color: themes.oppositeColor,
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
                          await SSH(ref: ref).setRefresh(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.set_refresh')
                          : '--',
                      width: widgetSize,
                      icon: Icons.restart_alt_rounded,
                      color: isConnectedToLg
                          ? Colors.blue
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                    TextButtonCustom(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          await SSH(ref: ref).resetRefresh(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.reset_refresh')
                          : '--',
                      width: widgetSize,
                      icon: Icons.restart_alt_rounded,
                      color: isConnectedToLg
                          ? Colors.blue
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: VerticalDivider(
                color: themes.oppositeColor,
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
                          await SSH(ref: ref).relaunchLG(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.relaunch_lg')
                          : '--',
                      width: widgetSize,
                      icon: Icons.power_rounded,
                      color: isConnectedToLg
                          ? Colors.redAccent
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                    TextButtonCustom(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          await SSH(ref: ref).rebootLG(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.reboot_lg')
                          : '--',
                      width: widgetSize,
                      icon: Icons.settings_power_rounded,
                      color: isConnectedToLg
                          ? Colors.redAccent
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                    TextButtonCustom(
                      onPressed: () async {
                        if (isConnectedToLg) {
                          await SSH(ref: ref).shutdownLG(
                            context,
                          );
                        } else {
                          showSnackBar(
                              context: context,
                              message:
                                  translate('settings.connection_required'));
                        }
                      },
                      name: isConnectedToLg
                          ? translate('settings.shutdown_lg')
                          : '--',
                      width: widgetSize,
                      icon: Icons.power_settings_new_rounded,
                      color: isConnectedToLg
                          ? Colors.redAccent
                          : lightenColor(themes.normalColor, 0.01),
                      ref: ref,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
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
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          Const.appBarHeight.ph,
          connectionSection(),
          contentSection(),
          lgSection()
        ],
      ),
    );
  }
}

class TextButtonCustom extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    Themes themes = ref.watch(themesProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: color.withOpacity(1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
                side: name == '--'
                    ? BorderSide(color: lightenColor(themes.normalColor))
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
                style:
                    textStyleBold.copyWith(color: themes.oppositeColor, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormFieldCustom extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    Themes themes = ref.watch(themesProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: screenSize(context).width / 2 - 200,
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: themes.oppositeColor,
              size: 20,
            ),
            labelText: hintText,
            labelStyle: textStyleNormal.copyWith(
                fontSize: 17, color: themes.oppositeColor.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: themes.oppositeColor, width: 1),
            ),
          ),
          style: textStyleNormal.copyWith(color: themes.oppositeColor, fontSize: 17),
          controller: controller,
        ),
      ),
    );
  }
}

class TitleContainer extends ConsumerWidget {
  const TitleContainer({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes themes = ref.watch(themesProvider);
    return Container(
      height: 100,
      width: screenSize(context).width -
          screenSize(context).width / Const.tabBarWidthDivider -
          50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        color: lightenColor(themes.highlightColor),
      ),
      child: Center(
        child: Text(
          title,
          style: textStyleBold.copyWith(color: themes.oppositeColor, fontSize: 40),
        ),
      ),
    );
  }
}
