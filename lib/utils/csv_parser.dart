import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/dashboard/downloadable_content.dart';

class FileParser {
  static double totalColumn({required List<dynamic> data}) {
    double total = 0;

    for (var x in data) {
      try {
        total += double.parse(x.toString());
      } catch (e) {}
    }

    return total;
  }

  static Future<List<List<dynamic>>> parseCSVAssets(String filename) async {
    final rawData = await rootBundle.loadString(filename);
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }

  static Future<List<List<dynamic>>> parseCSVFromStorage(
      Map<String, String> path,
      {int limit = 2000}) async {
    var localPath = await getApplicationDocumentsDirectory();
    String rawData = await File(
            '${localPath.path}/${DownloadableContent.generateFileName(path)}')
        .readAsString();
    var data = const CsvToListConverter(eol: '\n').convert(rawData);
    if (limit > 0) {
      return data.sublist(0, min(data.length, limit));
    } else {
      return data;
    }
  }

  static List<List<dynamic>> transformer(List<List<dynamic>> data) {
    List<List<dynamic>> transformedData = [];
    for (int i = 0; i < data[0].length; i++) {
      transformedData.add([]);
    }
    for (int i = 1; i < data.length; i++) {
      for (int j = 0; j < data[0].length; j++) {
        transformedData[j].add(data[i][j]);
      }
    }
    return transformedData;
  }
}
