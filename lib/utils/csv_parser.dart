import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileParser {
 static parseCSVAssets(String filename) async {
    final rawData = await rootBundle.loadString(filename);
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }
  static parseCSVFromStorage(String path) async {
    var localPath = await getApplicationDocumentsDirectory();
    String rawData = await File('${localPath.path}/$path').readAsString();
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }
}