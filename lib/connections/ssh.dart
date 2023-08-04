import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';

import '../kml_makers/balloon_makers.dart';
import '../utils/helper.dart';

class SSH {
  final encoder = const Utf8Encoder();
  final WidgetRef ref;

  SSH({required this.ref});

  Future<bool> connect(context) async {
    SSHSocket socket;
    try {
      socket = await SSHSocket.connect(
          ref.read(ipProvider), ref.read(portProvider),
          timeout: const Duration(seconds: 5));
    } catch (error) {
      ref.read(isConnectedToLGProvider.notifier).state = false;
      showSnackBar(context: context, message: error.toString());
      return false;
    }

    ref.read(sshClient.notifier).state = SSHClient(
      socket,
      username: ref.read(usernameProvider)!,
      onPasswordRequest: () => ref.read(passwordProvider)!,
    );

    ref.read(isConnectedToLGProvider.notifier).state = true;
    showSnackBar(
        context: context, message: translate('settings.connection_completed'));
    return true;
  }

  disconnect(context) async {
    ref.read(sshClient)?.close();
    ref.read(sshClient.notifier).state = null;
    showSnackBar(
        context: context,
        message: translate('settings.disconnection_completed'));
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
      showSnackBar(context: context, message: error.toString());
    }
  }

  cleanBalloon(context) async {
    try {
      await ref.read(sshClient)?.run(
          "echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_${ref.read(rightmostRigProvider)}.kml");
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  cleanKML(context) async {
    try {
      await stopOrbit(context);
      await ref.read(sshClient)?.run('echo "" > /tmp/query.txt');
      await ref.read(sshClient)?.run("echo '' > /var/www/html/kmls.txt");
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
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
      showSnackBar(context: context, message: error.toString());
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
      showSnackBar(context: context, message: error.toString());
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
      showSnackBar(context: context, message: error.toString());
    }
  }

  rebootLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S reboot');
      }
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  shutdownLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S poweroff"');
      }
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  //

  renderInSlave(context, int slaveNo, String kml) async {
    try {
      await ref
          .read(sshClient)
          ?.run("echo '$kml' > /var/www/html/kml/slave_$slaveNo.kml");
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
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
      showSnackBar(context: context, message: error.toString());
    }
  }

  flyToInstant(context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
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
      showSnackBar(context: context, message: error.toString());
    }
  }

  flyToInstantWithoutSaving(context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinearInstant(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  flyToWithoutSaving(context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  flyToOrbit(context, double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    try {
      await ref.read(sshClient)?.run(
          'echo "flytoview=${KMLMakers.orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  makeFile(String filename, String content) async {
    var localPath = await getApplicationDocumentsDirectory();
    File localFile = File('${localPath.path}/filename.kml');
    await localFile.writeAsString(content);
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
      showSnackBar(context: context, message: error.toString());
    }
  }

  fileDelete(context, String filename) async {
    try {
      final sftp = await ref.read(sshClient)?.sftp();
      await sftp?.remove("/var/www/html/$filename");
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  runKml(context, String kmlName) async {
    try {
      await ref
          .read(sshClient)
          ?.run("echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  startOrbit(context) async {
    try {
      await ref.read(sshClient)?.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }

  stopOrbit(context) async {
    try {
      await ref.read(sshClient)?.run('echo "exittour=true" > /tmp/query.txt');
    } catch (error) {
      showSnackBar(context: context, message: error.toString());
    }
  }
}
