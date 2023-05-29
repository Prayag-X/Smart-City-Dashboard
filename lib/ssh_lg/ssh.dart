import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';

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

    print('CONNECTED');
    ref.read(isConnectedToLGProvider.notifier).state = true;
    return true;
  }

  renderInSlave(int slaveNo, String imageKML) async {
    try {
      await ref
          .read(sshClient)!
          .run("echo '$imageKML' > /var/www/html/kml/slave_$slaveNo.kml");
    } catch (e) {
      print(e);
    }
  }

  cleanSlaves() async {
    try {
      for(var i = 2; i <= ref.read(rigsProvider); i++) {
        await ref
            .read(sshClient)!
            .run("echo '' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (e) {
      print(e);
    }
  }

  Future setRefresh() async {
    try {
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await ref.read(sshClient)!.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await ref.read(sshClient)!.run(
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'echo ${ref.read(passwordProvider)} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (e) {
      print(e);
    }
  }

  disconnect() {
    ref.read(sshClient)?.close();
    ref.read(isConnectedToLGProvider.notifier).state = false;
  }
}
