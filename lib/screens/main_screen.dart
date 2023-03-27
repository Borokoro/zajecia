import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:zajecia/functions/file_operations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:zajecia/functions/xml_operations.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final textController = TextEditingController();
  final FileOperations file=FileOperations();
  final XmlOperations xml=XmlOperations();
  List<String> data=<String>[];
  List<String> dataPom=<String>[];
  List<String> company=<String>[];
  List<int> companyApp=<int>[];
  int zmienna=0;
  String text="";
  List<TextEditingController> controllersList=<TextEditingController>[];
  final List<String> opis=[
    'Model',
    'Liczba',
    'Rozdzielczosc',
    'Matowa',
    'Cos',
    'Procesor',
    'Rdzenie',
    'Liczba',
    'Pamiec',
    'Pamiec_2',
    'Dysk',
    'Grafika',
    'Pamiec_3',
    'System_operacyjny',
    'DVD'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 100,),
            TextField(
              controller: textController,
              maxLines: 8,
              decoration: const InputDecoration.collapsed(hintText: 'Write something here'),
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        await file.write(textController.text);
                        setState(() {
                          text="";
                        });
                  },
                      child: const Text('Add to text file')),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        data=<String>[];
                        dataPom=<String>[];
                        zmienna=0;
                        text=await file.read();
                        text=text.replaceAll(RegExp(r"\r\n|\n|\r"), "");
                        final seperator=text.split(';');
                        for (var element in seperator) {
                          if(zmienna>14) {
                            zmienna = 0;
                          }
                          //print(element);
                          if(zmienna==0){
                            if(company.contains(element.trim())){
                              int help=company.indexOf(element.trim());
                              companyApp[help]+=1;
                            }
                            else{
                              company.add(element.trim());
                              companyApp.add(1);
                            }
                          }
                          data.add('${opis[zmienna]}: ${element}');
                          dataPom.add(element);
                          zmienna++;
                        }
                        for(int i=0;i<dataPom.length;i++) {
                          controllersList.add(TextEditingController());
                          if(dataPom[i].isEmpty) {
                            dataPom[i] += 'brak';
                          }
                          controllersList[i].text=dataPom[i];
                        }
                        setState(() {
                        });
                  },
                      child: const Text('Show text file')),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          text="";
                          textController.clear();
                        });
                  }, child: const Text('Clear text area')),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        text=await file.read();
                        setState(() {
                          textController.text=text;
                        });
                      }, child: const Text('Modify text file')),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: (){

                        setState(() {
                          
                        });
                      }, child: const Text('Get from xml')),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async {
                        final builder = XmlBuilder();
                        builder.processing('xml', 'version="1.0"');
                        builder.element('Laptopy', nest: ()
                        {
                          for (int i = 0; i < (dataPom.length - 1)/15; i++) {
                            builder.element('Laptop', nest: (){
                              for(int j=0;j<opis.length;j++){
                                builder.element(opis[j], nest: controllersList[i*15+j].text);
                              }
                            });
                          }
                        }
                        );
                        final document=builder.buildDocument();
                        print(document.toXmlString(pretty: true, indent: '\t'));
                        await xml.write(document);
                      }, child: const Text('Save to xml')),
                  const SizedBox(width: 20,),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
             /* child: ListView(
                children: [
                  for(int i=0;i<data.length-1;i++)
                    Text(data[i]),
                  for(int i=0;i<company.length-1;i++)
                        Text('${company[i]}: ${companyApp[i]}'),
                ],

              ), */

              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 3600,
                columns: List<DataColumn2>.generate(opis.length, (index) =>
                    DataColumn2(size: ColumnSize.L,
                    label: Text(opis[index]))),
                rows: List<DataRow>.generate(
                    (dataPom.length-1)~/15,
                        (index) => DataRow(cells: [
                          DataCell(TextFormField(controller: controllersList[index*15],)),
                          DataCell(TextField(controller: controllersList[index*15+1],)),
                          DataCell(TextField(controller: controllersList[index*15+2],)),
                          DataCell(TextField(controller: controllersList[index*15+3],)),
                          DataCell(TextField(controller: controllersList[index*15+4],)),
                          DataCell(TextField(controller: controllersList[index*15+5],)),
                          DataCell(TextField(controller: controllersList[index*15+6],)),
                          DataCell(TextField(controller: controllersList[index*15+7],)),
                          DataCell(TextField(controller: controllersList[index*15+8],)),
                          DataCell(TextField(controller: controllersList[index*15+9],)),
                          DataCell(TextField(controller: controllersList[index*15+10],)),
                          DataCell(TextField(controller: controllersList[index*15+11],)),
                          DataCell(TextField(controller: controllersList[index*15+12],)),
                          DataCell(TextField(controller: controllersList[index*15+13],)),
                          DataCell(TextField(controller: controllersList[index*15+14],)),
                    ])),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for(int i=0;i<company.length-1;i++)
                    Text('${company[i]}: ${companyApp[i]}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
