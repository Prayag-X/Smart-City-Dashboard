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
      await ref.read(sshClient)!.run("echo '$imageKML' > /var/www/html/kml/slave_$slaveNo.kml");
    } catch (e) {
      print(e);
    }
  }

  Future setRefresh() async {
    try {
      const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
      const replace =
          '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
      final command =
          'echo ${ref.read(
          passwordProvider)} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

      final clear =
          'echo ${ref.read(
          passwordProvider)} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';
      for (var i = 2; i <= ref.read(rigsProvider); i++) {
        final clearCmd = clear.replaceAll('{{slave}}', i.toString());
        final cmd = command.replaceAll('{{slave}}', i.toString());
        String query =
            'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i \'{{cmd}}\'';

        await ref.read(sshClient)!.execute(
            query.replaceAll('{{cmd}}', clearCmd));
        await ref.read(sshClient)!.execute(query.replaceAll('{{cmd}}', cmd));
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
