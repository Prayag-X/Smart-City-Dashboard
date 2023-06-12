import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartssh2/dartssh2.dart';

import '../constants/texts.dart';

StateProvider<bool> isLoadingProvider = StateProvider((ref) => false);
StateProvider<String> ipProvider = StateProvider((ref) => '');
StateProvider<String> usernameProvider = StateProvider((ref) => '');
StateProvider<String> passwordProvider = StateProvider((ref) => '');
StateProvider<int> portProvider = StateProvider((ref) => 22);
StateProvider<int> rigsProvider = StateProvider((ref) => 3);
StateProvider<int> leftmostRigProvider = StateProvider((ref) => 3);
StateProvider<int> rightmostRigProvider = StateProvider((ref) => 2);

setRigs(int rig, WidgetRef ref) {
  ref.read(rigsProvider.notifier).state = rig;
  ref.read(leftmostRigProvider.notifier).state = (rig) ~/ 2 + 2;
  ref.read(rightmostRigProvider.notifier).state = (rig) ~/ 2 + 1;
}

StateProvider<String> languageProvider = StateProvider((ref) => TextConst.langList.first);

StateProvider<SSHClient?> sshClient = StateProvider((ref) => null);
StateProvider<bool> isConnectedToLGProvider = StateProvider((ref) => false);
StateProvider<bool> isConnectedToInternetProvider = StateProvider((ref) => false);
