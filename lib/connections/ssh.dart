import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';

import '../utils/helper.dart';

class SSH {
  final encoder = const Utf8Encoder();
  final WidgetRef ref;

  SSH({required this.ref});

  Future<bool> connect() async {
    SSHSocket socket;
    try {
      socket = await SSHSocket.connect(
          ref.read(ipProvider), ref.read(portProvider),
          timeout: const Duration(seconds: 5));
    } catch (e) {
      ref.read(isConnectedToLGProvider.notifier).state = false;
      print(e);
      return false;
    }

    ref.read(sshClient.notifier).state = SSHClient(
      socket,
      username: ref.read(usernameProvider)!,
      onPasswordRequest: () => ref.read(passwordProvider)!,
    );

    ref.read(isConnectedToLGProvider.notifier).state = true;
    return true;
  }

  disconnect() async {
    ref.read(sshClient)?.close();
    ref.read(isConnectedToLGProvider.notifier).state = false;
  }

  renderInSlave(int slaveNo, String imageKML) async {
    try {
      await ref
          .read(sshClient)
          ?.run("echo '$imageKML' > /var/www/html/kml/slave_$slaveNo.kml");
    } catch (e) {
      print(e);
    }
  }

  cleanSlaves() async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        await ref
            .read(sshClient)
            ?.run("echo '' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (e) {
      print(e);
    }
  }

  cleanKML() async {
    try {
      await stopOrbit();
      await ref.read(sshClient)!.run('echo "" > /tmp/query.txt');
      await ref.read(sshClient)!.run("echo '' > /var/www/html/kmls.txt");
    } catch (e) {
      print(e);
    }
  }

  setRefresh() async {
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
      print("DONE");
    } catch (e) {
      print(e);
    }
  }

  resetRefresh() async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
      print("DONE");
    } catch (e) {
      print(e);
    }
  }

  relaunchLG() async {
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
    } catch (e) {
      print(e);
    }
  }

  rebootLG() async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S reboot');
      }
    } catch (e) {
      print(e);
    }
  }

  shutdownLG() async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        await ref.read(sshClient)?.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S poweroff"');
      }
    } catch (e) {
      print(e);
    }
  }

  flyTo(double latitude, double longitude, double zoom, double tilt,
      double bearing) async {
    ref.read(lastGMapPositionProvider.notifier).state = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: zoom,
      tilt: tilt,
      bearing: bearing,
    );
    await ref.read(sshClient)?.run(
        'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
  }

  makeFile(String filename, String content) async {
    var localPath = await getApplicationDocumentsDirectory();
    File localFile = File('${localPath.path}/filename.kml');
    await localFile.writeAsString(content);
    return localFile;
  }

  kmlFileUpload(File inputFile, String kmlName) async {
    ref.read(loadingPercentageProvider.notifier).state = 0;
    bool done = true;
    await ref.read(sshClient)?.sftp();
    final sftp = await ref.read(sshClient)?.sftp();
    await sftp?.remove('/var/www/html/$kmlName.kml');
    final file = await sftp?.open('/var/www/html/$kmlName.kml',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    var fileSize = await inputFile.length();
    file?.write(inputFile.openRead().cast(), onProgress: (progress) {
      ref.read(loadingPercentageProvider.notifier).state = progress/fileSize;
      if (fileSize == progress) {
        done = false;
      }
    });
    await waitWhile(() => done);
    ref.read(loadingPercentageProvider.notifier).state = null;
  }

  runKml(String kmlName) async {
    await ref
        .read(sshClient)
        ?.run("echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
  }

  startOrbit() async {
    await ref.read(sshClient)?.run('echo "playtour=Orbit" > /tmp/query.txt');
  }

  stopOrbit() async {
    await ref.read(sshClient)?.run('echo "exittour=true" > /tmp/query.txt');
  }
}
