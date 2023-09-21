import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartssh2/dartssh2.dart';

import '../constants/theme.dart';
import '../constants/constants.dart';

StateProvider<bool> isLoadingProvider = StateProvider((ref) => false);
StateProvider<double?> loadingPercentageProvider = StateProvider((ref) => null);
StateProvider<String> ipProvider = StateProvider((ref) => '192.168.56.100');
StateProvider<String> usernameProvider = StateProvider((ref) => 'lg');
StateProvider<String> passwordProvider = StateProvider((ref) => 'lg');
StateProvider<int> portProvider = StateProvider((ref) => 22);
StateProvider<int> rigsProvider = StateProvider((ref) => 3);
StateProvider<int> leftmostRigProvider = StateProvider((ref) => 3);
StateProvider<int> rightmostRigProvider = StateProvider((ref) => 2);

setRigs(int rig, WidgetRef ref) {
  ref.read(rigsProvider.notifier).state = rig;
  ref.read(leftmostRigProvider.notifier).state = (rig) ~/ 2 + 2;
  ref.read(rightmostRigProvider.notifier).state = (rig) ~/ 2 + 1;
}

StateProvider<String> languageProvider =
    StateProvider((ref) => Const.availableLanguages[0]);

StateProvider<SSHClient?> sshClient = StateProvider((ref) => null);
StateProvider<bool> isConnectedToLGProvider = StateProvider((ref) => false);
StateProvider<bool> isConnectedToInternetProvider =
    StateProvider((ref) => false);
StateProvider<bool> downloadableContentAvailableProvider =
    StateProvider((ref) => false);

StateProvider<bool> darkModeOnProvider = StateProvider((ref) => true);
StateProvider<Themes> themesProvider = StateProvider((ref) => ThemesDark());

StateProvider<bool> showHomepageTourProvider = StateProvider((ref) => true);
StateProvider<bool> showDashboardTourProvider = StateProvider((ref) => true);
StateProvider<bool> showVisualizerTourProvider = StateProvider((ref) => true);
