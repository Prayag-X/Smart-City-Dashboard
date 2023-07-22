import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';

import '../constants/constants.dart';

class Downloader {
  final WidgetRef ref;

  Downloader({required this.ref});

  downloadKml(String url) async {
    ref.read(loadingPercentageProvider.notifier).state = -1;
    await FileDownloader().download(
        DownloadTask(
          url: url,
          filename: '${Const.kmlCustomFileName}.kml',
          updates: Updates.statusAndProgress,
          requiresWiFi: false,
          retries: 5,
          allowPause: true,
        ),
        onProgress: (progress) {
          if (progress != 0) {
            ref.read(loadingPercentageProvider.notifier).state = progress;
          }
        },
        onStatus: (status) => print('Status: $status'));

    ref.read(loadingPercentageProvider.notifier).state = null;
  }

  downloadAllContent(
      Map<String, Map<String, String>> downloadableContent) async {
    List<DownloadTask> tasks = [];

    for (MapEntry<String, Map<String, String>> url
        in downloadableContent.entries) {
      tasks.add(DownloadTask(
        url: url.value['url']!,
        filename: url.value['filename']!,
        directory: url.value['directory']!,
        updates: Updates.statusAndProgress,
        requiresWiFi: false,
        retries: 5,
      ));
    }

    await FileDownloader().downloadBatch(tasks,
        batchProgressCallback: (succeeded, failed) => ref
            .read(loadingPercentageProvider.notifier)
            .state = (succeeded + failed) / tasks.length);

    ref.read(loadingPercentageProvider.notifier).state = null;
  }
}
