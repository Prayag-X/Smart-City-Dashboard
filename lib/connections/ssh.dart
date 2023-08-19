import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';

import '../constants/constants.dart';
import '../kml_makers/balloon_makers.dart';
import '../utils/helper.dart';

class SSH {
  final encoder = const Utf8Encoder();
  final WidgetRef ref;

  SSH({required this.ref});

  Future<bool> connect(context, {int i = 0}) async {
    SSHSocket socket;
    try {
      socket = await SSHSocket.connect(
          ref.read(ipProvider), ref.read(portProvider),
          timeout: const Duration(seconds: 5));
    } catch (error) {
      ref.read(isConnectedToLGProvider.notifier).state = false;
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
      return false;
    }

    ref.read(sshClient.notifier).state = SSHClient(
      socket,
      username: ref.read(usernameProvider)!,
      onPasswordRequest: () => ref.read(passwordProvider)!,
    );

    try {
      // await prepareImageUpload(context);
      final sftp = await ref.read(sshClient)?.sftp();
      await sftp?.open('/var/www/html/connection.txt',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
    } catch (error) {
      if (i < 5) {
        await disconnect(context, snackBar: false);
        return await connect(context, i: i++);
      } else {
        showSnackBar(
            context: context, message: error.toString(), color: Colors.red);
      }
    }

    if (i == 0) {
      ref.read(isConnectedToLGProvider.notifier).state = true;
      showSnackBar(
          context: context,
          message: translate('settings.connection_completed'));
    }
    return true;
  }

  connectionRetry(context, {int i = 0}) async {
    ref.read(sshClient)?.close();
    SSHSocket socket;
    try {
      socket = await SSHSocket.connect(
          ref.read(ipProvider), ref.read(portProvider),
          timeout: const Duration(seconds: 5));
    } catch (error) {
      ref.read(isConnectedToLGProvider.notifier).state = false;
      return false;
    }

    ref.read(sshClient.notifier).state = SSHClient(
      socket,
      username: ref.read(usernameProvider)!,
      onPasswordRequest: () => ref.read(passwordProvider)!,
    );

    try {
      // await prepareImageUpload(context);
      final sftp = await ref.read(sshClient)?.sftp();
      await sftp?.open('/var/www/html/connection.txt',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
    } catch (error) {
      if (i < 5) {
        return await connectionRetry(context, i: i++);
      } else {}
    }
    return true;
  }

  disconnect(context, {bool snackBar = true}) async {
    ref.read(sshClient)?.close();
    ref.read(sshClient.notifier).state = null;
    if (snackBar) {
      showSnackBar(
          context: context,
          message: translate('settings.disconnection_completed'));
    }
    ref.read(isConnectedToLGProvider.notifier).state = false;
  }

  //

  cleanSlaves(context) async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        await ref
            .read(sshClient)
            ?.run("echo '' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (error) {
      await connectionRetry(context);
      await cleanSlaves(context);
    }
  }

  cleanBalloon(context) async {
    try {
      await ref.read(sshClient)?.run(
          "echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_${ref.read(rightmostRigProvider)}.kml");
    } catch (error) {
      await connectionRetry(context);
      await cleanBalloon(context);
    }
  }

  cleanKML(context) async {
    try {
      await stopOrbit(context);
      await ref.read(sshClient)?.run('echo "" > /tmp/query.txt');
      await ref.read(sshClient)?.run("echo '' > /var/www/html/kmls.txt");
    } catch (error) {
      await connectionRetry(context);
      await cleanKML(context);
      // showSnackBar(
      //     context: context, message: error.toString(), color: Colors.red);
    }
  }

  setRefresh(context) async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  resetRefresh(context) async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  relaunchLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo ${ref.read(passwordProvider)} | sudo -S service \\\${SERVICE} start
          else
            echo ${ref.read(passwordProvider)} | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p ${ref.read(passwordProvider)} ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await ref.read(sshClient)?.run(
            '"/home/${ref.read(usernameProvider)}/bin/lg-relaunch" > /home/${ref.read(usernameProvider)}/log.txt');
        await ref.read(sshClient)?.run(cmd);
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  rebootLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S reboot');
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  shutdownLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S poweroff"');
      }
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  //

  Future<String> renderInSlave(context, int slaveNo, String kml) async {
    try {
      await ref
          .read(sshClient)
          ?.run("echo '$kml' > /var/www/html/kml/slave_$slaveNo.kml");
      return kml;
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
      return BalloonMakers.blankBalloon();
    }
  }

  flyTo(context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    try {
      ref.read(lastGMapPositionProvider.notifier).state = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: zoom,
        tilt: tilt,
        bearing: bearing,
      );
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      await connectionRetry(context);
      await flyTo(context, latitude, longitude, zoom, tilt, bearing);
    }
  }

  flyToInstant(context, double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      ref.read(lastGMapPositionProvider.notifier).state = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: zoom,
        tilt: tilt,
        bearing: bearing,
      );
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinearInstant(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  flyToInstantWithoutSaving(context, double latitude, double longitude,
      double zoom, double tilt, double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinearInstant(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  flyToWithoutSaving(context, double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  flyToOrbit(context, double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      await connectionRetry(context);
      await flyToOrbit(context, latitude, longitude, zoom, tilt, bearing);
    }
  }

  makeFile(String filename, String content) async {
    var localPath = await getApplicationDocumentsDirectory();
    File localFile = File('${localPath.path}/filename.kml');
    await localFile.writeAsString(content);
    return localFile;
  }

  makeImageFile(Uint8List imageBytes, int number) async {
    var localPath = await getApplicationDocumentsDirectory();
    File localFile = File('${localPath.path}/$number.png');
    localFile.writeAsBytesSync(imageBytes);
    return localFile;
  }

  kmlFileUpload(context, File inputFile, String kmlName) async {
    try {
      bool uploading = true;
      final sftp = await ref.read(sshClient)?.sftp();
      final file = await sftp?.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file?.write(inputFile.openRead().cast(), onProgress: (progress) {
        ref.read(loadingPercentageProvider.notifier).state =
            progress / fileSize;
        if (fileSize == progress) {
          uploading = false;
        }
      });
      if (file == null) {
        return;
      }
      await waitWhile(() => uploading);
      ref.read(loadingPercentageProvider.notifier).state = null;
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  prepareImageUpload(context) async {
    String command =
        'echo "${ref.read(passwordProvider)}" | sudo -S chmod 777 ${Const.dashboardBalloonFileLocation}';
    try {
      // final shell = await ref.read(sshClient)?.shell();
      //
      // final completer = Completer<String>();
      // final outputBuffer = StringBuffer();
      //
      // shell?.stdout.listen(
      //       (data) {
      //         print(String.fromCharCodes(data));
      //     outputBuffer.write(String.fromCharCodes(data));
      //   },
      //   onDone: () {
      //     completer.complete(outputBuffer.toString());
      //   },
      // );
      //
      // shell?.write(encoder.convert('$command\n'));
      // shell?.write(encoder.convert("sshpass -p \"${ref.read(passwordProvider)}\" ssh -t lg@lg${ref.read(rightmostRigProvider)} '$command'\n"));
      // shell?.write(encoder.convert('exit\n'));
      // await shell?.stdout.join();
      // print(outputBuffer.toString());
      await ref.read(sshClient)?.run(command);
      await ref.read(sshClient)?.run(
          "sshpass -p \"${ref.read(passwordProvider)}\" ssh -t lg@lg${ref.read(rightmostRigProvider)} '$command'");
      // print(command);
      // print("ssh -t lg@lg${ref.read(rightmostRigProvider)} '$command'");
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  imageFileUpload(context, Uint8List imageBytes) async {
    try {
      bool uploading = true;
      File inputFile = await makeImageFile(imageBytes, 1);
      final sftp = await ref.read(sshClient)?.sftp();
      String tabName = '';
      for (var pageTab in ref.read(cityDataProvider)!.availableTabs) {
        if (pageTab.tab == ref.read(tabProvider)) {
          if (ref.read(tabProvider) == 0) {
            tabName = 'weather';
          } else if (ref.read(tabProvider) ==
              ref.read(cityDataProvider)!.availableTabs.length - 1) {
            tabName = 'about';
          } else {
            tabName = pageTab.nameForUrl!;
          }
        }
      }
      final file = await sftp?.open(
          '${Const.dashboardBalloonFileLocation}${Const.dashboardBalloonFileName}_${ref.read(cityDataProvider)!.cityNameEnglish.replaceAll(' ', '_')}_$tabName.png',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file?.write(inputFile.openRead().cast(), onProgress: (progress) {
        ref.read(loadingPercentageProvider.notifier).state =
            progress / fileSize;
        if (fileSize == progress) {
          uploading = false;
        }
      });
      if (file == null) {
        return;
      }
      await waitWhile(() => uploading);
      ref.read(loadingPercentageProvider.notifier).state = null;
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  imageFileUploadSlave(context) async {
    try {
      String tabName = '';
      for (var pageTab in ref.read(cityDataProvider)!.availableTabs) {
        if (pageTab.tab == ref.read(tabProvider)) {
          if (ref.read(tabProvider) == 0) {
            tabName = 'weather';
          } else if (ref.read(tabProvider) ==
              ref.read(cityDataProvider)!.availableTabs.length - 1) {
            tabName = 'about';
          } else {
            tabName = pageTab.nameForUrl!;
          }
        }
      }
      await ref.read(sshClient)?.run(
          'echo "put ${Const.dashboardBalloonFileLocation}${Const.dashboardBalloonFileName}_${ref.read(cityDataProvider)!.cityNameEnglish.replaceAll(' ', '_')}_$tabName.png" | sshpass -p ${ref.read(passwordProvider)} sftp -oBatchMode=no -b - lg@lg${ref.read(rightmostRigProvider)}:${Const.dashboardBalloonFileLocation}');
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  // kmlFileUploadTry(context) async {
  //   try {
  //     bool uploading = true;
  //     final sftp = await ref.read(sshClient)?.sftp();
  //     final file = await sftp?.open('/var/www/html/trying.png',
  //         mode: SftpFileOpenMode.create |
  //         SftpFileOpenMode.truncate |
  //         SftpFileOpenMode.write);
  //
  //     var fileSize = await inputFile.length();
  //     file?.write(inputFile.openRead().cast(), onProgress: (progress) {
  //       ref.read(loadingPercentageProvider.notifier).state =
  //           progress / fileSize;
  //       if (fileSize == progress) {
  //         uploading = false;
  //       }
  //     });
  //     if (file == null) {
  //       return;
  //     }
  //     await waitWhile(() => uploading);
  //     ref.read(loadingPercentageProvider.notifier).state = null;
  //   } catch (error) {
  //     showSnackBar(context: context, message: error.toString());
  //   }
  // }

  fileDelete(context, String filename) async {
    try {
      final sftp = await ref.read(sshClient)?.sftp();
      await sftp?.remove("/var/www/html/$filename");
    } catch (error) {
      showSnackBar(
          context: context, message: error.toString(), color: Colors.red);
    }
  }

  runKml(context, String kmlName) async {
    try {
      await ref
          .read(sshClient)
          ?.run("echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
    } catch (error) {
      await SSH(ref: ref).connectionRetry(context);
      await runKml(context, kmlName);
    }
  }

  startOrbit(context) async {
    try {
      await ref.read(sshClient)?.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      await SSH(ref: ref).connectionRetry(context);
      await startOrbit(context);
    }
  }

  stopOrbit(context) async {
    try {
      await ref.read(sshClient)?.run('echo "exittour=true" > /tmp/query.txt');
    } catch (error) {
      await SSH(ref: ref).connectionRetry(context);
      stopOrbit(context);
    }
  }
}
