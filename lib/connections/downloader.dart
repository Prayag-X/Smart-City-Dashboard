import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Downloader {
  final WidgetRef ref;

  Downloader({required this.ref});

  downloadKml(String url) async {
    await FileDownloader().download(
        DownloadTask(
          url: url,
          filename: 'custom_kml.jpg',
          updates: Updates.statusAndProgress,
          requiresWiFi: false,
          retries: 5,
          allowPause: true,
        ),
        onProgress: (progress) => print('Progress: ${progress * 100}%'),
        onStatus: (status) => print('Status: $status'));

    print('FILE DONEE');
  }
}
