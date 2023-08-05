import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../constants/text_styles.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../models/downloadable_kml.dart';

class KmlDownloaderButton extends ConsumerStatefulWidget {
  const KmlDownloaderButton(this.data, this.index, {super.key});

  final DownloadableKML data;
  final int index;

  @override
  ConsumerState createState() => _KmlDownloaderButtonState();
}

class _KmlDownloaderButtonState extends ConsumerState<KmlDownloaderButton> {
  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    int kmlClicked = ref.watch(kmlClickedProvider);
    int kmlPlaying = ref.watch(kmlPlayProvider);
    double? loadingPercentage = ref.watch(loadingPercentageProvider);
    bool isConnectedToLG = ref.watch(isConnectedToLGProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Container(
                        width: loadingPercentage != null
                            ? constraints.maxWidth *
                                (loadingPercentage != -1
                                    ? loadingPercentage
                                    : 1)
                            : constraints.maxWidth,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kmlClicked == widget.index
                              ? highlightColor
                              : null,
                          borderRadius:
                              BorderRadius.circular(Const.dashboardUIRoundness),
                          border: kmlClicked == widget.index
                              ? Border.all(color: highlightColor)
                              : null,
                        ))),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () async {
              if (!isConnectedToLG) {
                showSnackBar(
                    context: context,
                    message: translate('settings.connection_required'));
                return;
              }
              ref.read(kmlClickedProvider.notifier).state = widget.index;
              await SSH(ref: ref).cleanKML(
                context,
              );
              var localPath = await getApplicationDocumentsDirectory();
              await Downloader(ref: ref).downloadKml(widget.data.url);
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
              var initialMapPosition = CameraPosition(
                target: ref.read(cityDataProvider)!.location,
                zoom: Const.appZoomScale,
              );
              if (!mounted) {
                return;
              }
              // await SSH(ref: ref).renderInSlave(
              //     context,
              //     ref.read(rightmostRigProvider),
              //     BalloonMakers.kmlBalloon(
              //       initialMapPosition,
              //       ref.read(cityDataProvider)!.image,
              //       widget.data.name,
              //       widget.data.size,
              //     ));
              if (!mounted) {
                return;
              }
              ref.read(kmlPlayProvider.notifier).state = widget.index;
              showSnackBar(
                  context: context, message: translate('settings.kml_success'));
              ref.read(isLoadingProvider.notifier).state = false;
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                children: [
                  kmlPlaying != widget.index
                      ? const Icon(
                          Icons.arrow_downward_rounded,
                          size: 25,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.screenshot_monitor_rounded,
                          size: 25,
                          color: Colors.green,
                        ),
                  7.pw,
                  Row(
                    children: [
                      kmlPlaying != widget.index
                          ? Text(
                              widget.data.size,
                              style: textStyleNormal.copyWith(
                                  fontSize: 18,
                                  color: Colors.redAccent.withOpacity(0.7)),
                            )
                          : Text(
                              translate('dashboard.playing'),
                              style: textStyleNormal.copyWith(
                                  fontSize: 18,
                                  color: Colors.green.withOpacity(0.7)),
                            ),
                      Text(
                        '  ${widget.data.name}',
                        style: textStyleNormal.copyWith(
                            color: oppositeColor, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
