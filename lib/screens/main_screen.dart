import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:zajecia/functions/buttons.dart';
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
  final FileOperations file = FileOperations();
  final XmlOperations xml = XmlOperations();
  final Buttons buttons = Buttons();
  List<String> data = <String>[];
  List<String> company = <String>[];
  List<int> companyApp = <int>[];
  int zmienna = 0;
  String text = "";
  List<TextEditingController> controllersList = <TextEditingController>[];
  bool areThereData = false;
  final List<String> opis = [
    'Producent',
    'Wielkość_matrycy',
    'Rozdzielczość',
    'Typ_matrycy',
    'Dotykowy',
    'Procesor',
    'Liczba_rdzeni_fizycznych',
    'Taktowanie',
    'RAM',
    'Pojemnosc_dysku',
    'Typ_dysku',
    'Karta_graficzna',
    'Pamięć_karty_graficznej',
    'System_operacyjny',
    'Napęd_optyczny'
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        text = "";
                        for (int i = 0; i < controllersList.length; i++) {
                          text = text + controllersList[i].text + ';';
                        }
                        print(text);
                        await file.write(text);
                        setState(() {
                          text = "";
                        });
                      },
                      child: const Text('Zapisz dane do pliku txt')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        data = <String>[];
                        controllersList=<TextEditingController>[];
                        zmienna = 0;
                        text = await file.read();
                        text = text.replaceAll(RegExp(r"\r\n|\n|\r"), "");
                        final seperator = text.split(';');
                        for (var element in seperator) {
                          if (zmienna > 14) {
                            zmienna = 0;
                          }
                          if (zmienna == 0) {
                            if (company.contains(element.trim())) {
                              int help = company.indexOf(element.trim());
                              companyApp[help] += 1;
                            } else {
                              company.add(element.trim());
                              companyApp.add(1);
                            }
                          }
                          data.add(element);
                          zmienna++;
                        }
                        for (int i = 0; i < data.length; i++) {
                          controllersList.add(TextEditingController());
                          if (data[i].isEmpty) {
                            data[i] += 'brak';
                          }
                          controllersList[i].text = data[i];
                        }
                        areThereData = true;
                        setState(() {});
                      },
                      child: const Text('Wczytaj dane z pliku txt')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String xmlAsString;
                        areThereData = true;
                        xmlAsString = await xml.read();
                        zmienna=0;
                        controllersList=<TextEditingController>[];
                        data = <String>[];
                        final seperator = xmlAsString.split(';');
                        for (var element in seperator) {
                          if (zmienna > 14) {
                            zmienna = 0;
                          }
                          if (zmienna == 0) {
                            if (company.contains(element.trim())) {
                              int help = company.indexOf(element.trim());
                              companyApp[help] += 1;
                            } else {
                              company.add(element.trim());
                              companyApp.add(1);
                            }
                          }
                          data.add(element);
                          zmienna++;
                        }
                        for (int i = 0; i < data.length; i++) {
                          controllersList.add(TextEditingController());
                          if (data[i].isEmpty) {
                            data[i] += 'brak';
                          }
                          controllersList[i].text = data[i];
                        }
                        setState(() {});
                      },
                      child: const Text('Wczytaj dane z pliku xml')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final builder = XmlBuilder();
                        DateTime dateTime=DateTime.now();
                        builder.processing(
                            'laptopy', 'moddate="${dateTime}"');
                        builder.element('Laptopy', nest: () {
                          for (int i = 0; i < (data.length - 1) ~/ 15; i++) {
                            builder.element('Laptop', nest: () {
                              builder.attribute('id', i+1);
                              for (int j = 0; j < opis.length; j++) {
                                if (j == 0) {
                                  builder.element(opis[j],
                                      nest: controllersList[i * 15 + j].text);
                                } else if (j == 1) {
                                  builder.element(
                                      'screen',
                                      nest: () {
                                    for (int k = 0; k < 4; k++) {
                                      builder.element(opis[j],nest: (){
                                        builder.text(controllersList[j+i*15].text);
                                      });
                                      j++;
                                    }
                                    j--;
                                  });
                                }
                                else if(j==5){
                                  builder.element(
                                      'procesor',
                                      nest: () {
                                        for(int k=0;k<3;k++){
                                          builder.element(opis[j], nest: () {
                                            builder.text(controllersList[j+i*15].text);
                                          });
                                          j++;
                                        }
                                      });
                                  j--;
                                }
                                else if(j==8){
                                  builder.element(opis[j] ,nest: () {
                                    builder.text(controllersList[j+i*15].text);
                                  });
                                }
                                else if(j==9){
                                  builder.element(
                                      'dysk',
                                      nest: () {
                                        builder.element(opis[j],nest: (){
                                          builder.text(controllersList[j+i*15].text);
                                        });
                                        j++;
                                        builder.element(opis[j],nest: (){
                                          builder.text(controllersList[j+i*15].text);
                                        });
                                      });
                                }
                                else if(j==11){
                                  builder.element(
                                      '${opis[j]}',
                                      nest: () {
                                        for(int k=0;k<2;k++) {
                                          builder.element(opis[j], nest: (){
                                              builder.text(controllersList[j + i * 15].text);
                                          });
                                      j++;
                                    }
                                        j--;
                                  });
                                }
                                else if(j==13 || j==14){
                                  builder.element(
                                      '${opis[j]}',
                                      nest: () {
                                        builder.text(controllersList[j+i*15].text);
                                      });
                                }
                              }
                            });
                          }
                        });
                        final document = builder.buildDocument();
                        print(document.toXmlString(pretty: true, indent: '\t'));
                        await xml.write(document);
                      },
                      child: const Text('Zapisz dane do XML')),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            areThereData
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 3600,
                      columns: List<DataColumn2>.generate(
                          opis.length,
                          (index) => DataColumn2(
                              size: ColumnSize.L, label: Text(opis[index]))),
                      rows: List<DataRow>.generate(
                          (data.length - 1) ~/ 15,
                          (index) => DataRow(cells: [
                                DataCell(TextFormField(
                                  controller: controllersList[index * 15],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 1],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 2],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 3],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 4],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 5],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 6],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 7],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 8],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 9],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 10],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 11],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 12],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 13],
                                )),
                                DataCell(TextField(
                                  controller: controllersList[index * 15 + 14],
                                )),
                              ])),
                    ),
                  )
                : SizedBox(),
            /*Expanded(
              child: ListView(
                children: [
                  for(int i=0;i<company.length-1;i++)
                    Text('${company[i]}: ${companyApp[i]}'),
                ],
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
