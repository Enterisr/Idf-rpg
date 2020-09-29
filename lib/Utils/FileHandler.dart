import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileHandler {
  String fileName = "data.txt";
  FileHandler({this.fileName});

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, fileName);
    File file = File(path);
    bool isExists = await file.exists();
    if (!isExists) {
      await file.create();
    }
    return file;
  }

  Future<File> writeToFile(data) async {
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> readFromFile() async {
    try {
      final file = await _getFile();
      return await file.readAsString();
    } catch (e) {
      //TODO: do something with the error
      throw e;
    }
  }
}
