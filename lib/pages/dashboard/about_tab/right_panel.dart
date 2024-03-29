import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../widgets/dashboard_right_panel.dart';
import '../../../constants/text_styles.dart';
import '../../../kml_makers/kml_makers.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../constants/theme.dart';
import '../../../providers/settings_providers.dart';
import '../../../connections/ssh.dart';
import '../../../utils/helper.dart';

class AboutTabRight extends ConsumerStatefulWidget {
  const AboutTabRight({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AboutTabRightState();
}

class _AboutTabRightState extends ConsumerState<AboutTabRight> {
  int selectedTask = -1;

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    return DashboardRightPanel(
        headers: [translate('dashboard.about.available_options')],
        headersFlex: const [1],
        centerHeader: true,
        panelList: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () async {
                ref.read(isLoadingProvider.notifier).state = true;
                setState(() {
                  selectedTask = 0;
                });
                try {
                  File file = await SSH(ref: ref).makeFile(
                      Const.kmlOrbitFileName,
                      KMLMakers.buildTourOfCityAbout(ref));
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref)
                      .kmlFileUpload(context, file, Const.kmlOrbitFileName);
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref).runKml(context, Const.kmlOrbitFileName);
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref).startOrbit(
                    context,
                  );
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref)
                      .kmlFileUpload(context, file, Const.kmlOrbitFileName);
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref).runKml(context, Const.kmlOrbitFileName);
                  if (!mounted) {
                    return;
                  }
                  await SSH(ref: ref).startOrbit(
                    context,
                  );
                } catch (error) {
                  showSnackBar(context: context, message: error.toString());
                }
                ref.read(isLoadingProvider.notifier).state = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTask == 0 ? themes.highlightColor : null,
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: Const.dashboardTextSize + 5,
                          color: themes.oppositeColor,
                        ),
                        10.pw,
                        Text(
                          translate('dashboard.about.start_tour'),
                          style: textStyleNormal.copyWith(
                              color: themes.oppositeColor,
                              fontSize: Const.dashboardTextSize + 5),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () async {
                ref.read(isLoadingProvider.notifier).state = true;
                setState(() {
                  selectedTask = 1;
                });
                if (!mounted) {
                  return;
                }
                await SSH(ref: ref).stopOrbit(
                  context,
                );
                ref.read(isLoadingProvider.notifier).state = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTask == 1 ? themes.highlightColor : null,
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.stop_rounded,
                          size: Const.dashboardTextSize + 5,
                          color: themes.oppositeColor,
                        ),
                        10.pw,
                        Text(
                          translate('dashboard.about.stop'),
                          style: textStyleNormal.copyWith(
                              color: themes.oppositeColor,
                              fontSize: Const.dashboardTextSize + 5),
                        ),
                      ],
                    )),
              ),
            ),
          )
        ]);
  }
}
