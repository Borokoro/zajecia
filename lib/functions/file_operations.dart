import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileOperations{

  write(String text) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/data.txt');
    print(directory.path);
    await file.writeAsString(text);
  }

  Future<String> read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/data.txt');
      text = await file.readAsString();
    } catch (e) {
      text="Couldn't read file";
    }
    return text;
  }
}