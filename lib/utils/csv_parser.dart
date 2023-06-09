import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileParser {
 static Future<List<List<dynamic>>> parseCSVAssets(String filename) async {
    final rawData = await rootBundle.loadString(filename);
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }
  static Future<List<List<dynamic>>> parseCSVFromStorage(String path) async {
    var localPath = await getApplicationDocumentsDirectory();
    String rawData = await File('${localPath.path}/$path').readAsString();
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }
  static List<List<dynamic>> transformer(List<List<dynamic>> data) {
    List<List<dynamic>> transformedData = [];
    for(int i = 0; i< data[0].length; i++) {
      transformedData.add([]);
    }
    for(int i = 1; i< data.length; i++) {
      for(int j = 0; j< data[0].length; j++) {
        transformedData[j].add(data[i][j]);
      }
    }
    return transformedData;
  }
}