import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../constants/text_styles.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../models/downloadable_kml.dart';

class KmlDownloaderButton extends ConsumerWidget {
  const KmlDownloaderButton(this.data, this.index, {super.key});

  final DownloadableKML data;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    int kmlClicked = ref.watch(kmlClickedProvider);
    double? loadingPercentage = ref.watch(loadingPercentageProvider);
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
                          color: kmlClicked == index ? highlightColor : null,
                          borderRadius:
                              BorderRadius.circular(Const.dashboardUIRoundness),
                          border: kmlClicked == index
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
              ref.watch(kmlClickedProvider.notifier).state = index;
              ref.read(isLoadingProvider.notifier).state = true;
              var localPath = await getApplicationDocumentsDirectory();
              await Downloader(ref: ref).downloadKml(data.url);
              await SSH(ref: ref).kmlFileUpload(
                  File('${localPath.path}/${Const.kmlCustomFileName}.kml'),
                  Const.kmlCustomFileName);
              await SSH(ref: ref).runKml(Const.kmlCustomFileName);
              var initialMapPosition = CameraPosition(
                target: ref.read(cityDataProvider)!.location,
                zoom: 11,
              );
              await SSH(ref: ref).renderInSlave(
                  ref.read(rightmostRigProvider),
                  BalloonMakers.kmlBalloon(
                      initialMapPosition,
                      ref.read(cityDataProvider)!.image,
                      data.name,
                      data.size,));
              ref.read(isLoadingProvider.notifier).state = false;
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_downward_rounded,
                    size: 25,
                    color: Colors.blue,
                  ),
                  7.pw,
                  Row(
                    children: [
                      Text(
                        data.size,
                        style: textStyleNormal.copyWith(
                            fontSize: 18,
                            color: Colors.redAccent.withOpacity(0.7)),
                      ),
                      Text(
                        '  ${data.name}',
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
