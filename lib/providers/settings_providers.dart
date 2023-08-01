import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/constants/theme.dart';

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

StateProvider<String> languageProvider = StateProvider((ref) => translate('language.en'));

StateProvider<SSHClient?> sshClient = StateProvider((ref) => null);
StateProvider<bool> isConnectedToLGProvider = StateProvider((ref) => false);
StateProvider<bool> isConnectedToInternetProvider = StateProvider((ref) => false);
StateProvider<bool> downloadableContentAvailableProvider = StateProvider((ref) => false);

StateProvider<bool> darkModeOnProvider = StateProvider((ref) => true);
StateProvider<Color> normalColorProvider = StateProvider((ref) => const Color(0xFF15151A));
StateProvider<Color> oppositeColorProvider = StateProvider((ref) => Colors.white);
StateProvider<Color> tabBarColorProvider = StateProvider((ref) => const Color(0xFF1E2026));
StateProvider<Color> highlightColorProvider = StateProvider((ref) => const Color(0xFF252F52));

setDarkTheme(WidgetRef ref) {
  ref.read(normalColorProvider.notifier).state = ThemesDark.normalColor;
  ref.read(oppositeColorProvider.notifier).state = ThemesDark.oppositeColor;
  ref.read(tabBarColorProvider.notifier).state = ThemesDark.tabBarColor;
  ref.read(highlightColorProvider.notifier).state = ThemesDark.highlightColor;
}

setLightTheme(WidgetRef ref) {
  ref.read(normalColorProvider.notifier).state = ThemesLight.normalColor;
  ref.read(oppositeColorProvider.notifier).state = ThemesLight.oppositeColor;
  ref.read(tabBarColorProvider.notifier).state = ThemesLight.tabBarColor;
  ref.read(highlightColorProvider.notifier).state = ThemesLight.highlightColor;
}