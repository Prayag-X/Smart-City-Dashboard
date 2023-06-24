import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class FileParser {
 static parseCSV(String filename) async {
    final rawData = await rootBundle.loadString(filename);
    return const CsvToListConverter(eol: '\n').convert(rawData);
  }
}