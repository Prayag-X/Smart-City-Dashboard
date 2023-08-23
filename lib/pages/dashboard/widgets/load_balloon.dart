import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../providers/data_providers.dart';
import '../../../providers/page_providers.dart';
import '../../../providers/settings_providers.dart';

class BalloonLoader {
  WidgetRef ref;
  BuildContext context;
  bool mounted;

  BalloonLoader({
    required this.ref,
    required this.context,
    required this.mounted,
  });

  loadDashboardBalloon(ScreenshotController screenshotController,
      {String? tabPageName}) async {
    if (ref.read(isConnectedToLGProvider)) {
      await Future.delayed(Const.screenshotDelay).then((x) async {
        screenshotController.capture().then((image) async {
          img.Image? imageDecoded = img.decodePng(Uint8List.fromList(image!));
          await SSH(ref: ref).imageFileUpload(context, image);
          if (!mounted) {
            return;
          }
          await SSH(ref: ref).imageFileUploadSlave(context);
          var initialMapPosition = CameraPosition(
            target: ref.read(cityDataProvider)!.location,
            zoom: Const.appZoomScale,
          );
          if (!mounted) {
            return;
          }
          String tabName = '';
          if (tabPageName == null) {
            for (var pageTab in ref.read(cityDataProvider)!.availableTabs) {
              if (pageTab.tab == ref.read(tabProvider)) {
                tabName = pageTab.nameForUrl!;
              }
            }
          }
          ref.read(lastBalloonProvider.notifier).state = await SSH(ref: ref)
              .renderInSlave(
                  context,
                  ref.read(rightmostRigProvider),
                  BalloonMakers.dashboardBalloon(
                      initialMapPosition,
                      ref.read(cityDataProvider)!.cityNameEnglish,
                      tabPageName ?? tabName,
                      imageDecoded!.height / imageDecoded.width));
        }).catchError((onError) {
          SSH(ref: ref).connectionRetry(context);
          loadDashboardBalloon(screenshotController, tabPageName: tabPageName);
        });
      });
    }
  }

  loadKmlBalloon(String kmlName, String fileSize) async {
    String name = '<h3>Playing KML: $kmlName</h3>\n';
    String size = '<h3>KML file size: $fileSize</h3>\n';
    String processKml =
        ref.read(lastBalloonProvider).replaceAll('<img', '$name$size<img');
    await SSH(ref: ref)
        .renderInSlave(context, ref.read(rightmostRigProvider), processKml);
  }

  restoreBalloon(String kmlName, String fileSize) async =>
      await SSH(ref: ref).renderInSlave(context, ref.read(rightmostRigProvider),
          ref.read(lastBalloonProvider));
}
