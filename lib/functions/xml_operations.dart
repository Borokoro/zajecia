import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class XmlOperations{

  write(XmlDocument text) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/data_xml.xml');
    await file.writeAsString(text.toXmlString(pretty: true, indent: '\t'));
    print('im done');
  }

  Future<XmlDocument> read() async {
    String text;
    XmlDocument? document;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/data_xml.xml');
      text = await file.readAsString();
      document=XmlDocument.parse(text);
    } catch (e) {
      document=XmlDocument();
      text="Couldn't read file";
    }
    return document;
  }

}