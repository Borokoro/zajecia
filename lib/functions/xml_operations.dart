import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

class XmlOperations{

  write(XmlDocument text) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/data_xml.xml');
    await file.writeAsString(text.toXmlString(pretty: true, indent: '\t'));
    print('im done');
  }

  Future<String> read() async {
    String text="";
    String node="";
    XmlDocument? document;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/data_xml.xml');
      await file.openRead().transform(utf8.decoder).toXmlEvents()
      .forEachEvent(onText: (event) {
           print(event);
      });
      print('zczytalo');
      print(text);
      document=XmlDocument();
    } catch (e) {
      document=XmlDocument();
      text="Couldn't read file";
      print('nie zczytalo $e');
    }
    return text;
  }

}