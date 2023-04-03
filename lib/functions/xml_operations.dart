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
    int komponentAtrybut=0;
    List<String> screens=<String>[];
    List<String> discs=<String>[];
    List<String> wholeText=<String>[];
    int ktoryAtrybut=0;
    //XmlDocument? document;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/data_xml.xml');
      final document=XmlDocument.parse(file.readAsStringSync()).findAllElements('screen');
      for(var element in document){
        screens.add(element.attributes.first.value);
        print('${element.attributes.first.value}');
      }
      final document2=XmlDocument.parse(file.readAsStringSync()).findAllElements('dysk');
      for(var element in document2){
        discs.add(element.attributes.first.value);
        //print('${element.attributes.first.value}');
      }
      await file.openRead().transform(utf8.decoder).toXmlEvents()
      .normalizeEvents().forEachEvent(onText: (event) {
            node=event.text.replaceAll(new RegExp(r"\s+"), "");
            if(node!=""){
              text=text+node+";";
            }
      });
      final seperator = text.split(';');
      for(var element in seperator){
        if(ktoryAtrybut==4){
          wholeText.add(screens[komponentAtrybut]);
        }
        else if(ktoryAtrybut==9){
          wholeText.add(discs[komponentAtrybut]);
          komponentAtrybut++;
        }
        wholeText.add(element);
        ktoryAtrybut++;
        if(ktoryAtrybut==13){
          ktoryAtrybut=0;
        }
      }
      text="";
      for(int i=0;i<wholeText.length;i++){
        text=text+wholeText[i]+";";
      }
      //var firstElement=document.first;
      //print(document);
      print('zczytalo');
      //print(text);
     // document=XmlDocument();
    } catch (e) {
     // document=XmlDocument();
      text="Couldn't read file";
      print('nie zczytalo $e');
    }
    return text;
  }

}