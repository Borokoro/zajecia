import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:xml/xml.dart';
import 'package:zajecia/functions/buttons.dart';
import 'package:zajecia/functions/file_operations.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:zajecia/functions/xml_operations.dart';
import 'package:zajecia/mySQL/mySQL.dart';

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
  List<String> textDuplicates=[];
  List<String> xmlDuplicates=[];
  List<String> databaseDuplicates=[];
  List<int> red=[];
  List<bool> isWhite=[];
  int zmienna = 0;
  String text = "";
  List<TextEditingController> controllersList = <TextEditingController>[];
  bool areThereData = false;
  bool isValidated = true;
  final MySQL mySQL = MySQL();
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
    mySQL.establishConnection().then((value) => mySQL.createTable());
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
                          if (controllersList[i].text.length < 2 &&
                              i % 15 != 6) {
                            print(controllersList[i].text);
                            isValidated = false;
                          }
                          if (i % 15 == 6 || i % 15 == 7) {
                            try {
                              int.parse(controllersList[i].text);
                            } catch (e) {
                              if (controllersList[i].text.trim() != 'brak') {
                                //print(controllersList[i].text);
                                isValidated = false;
                              }
                            }
                          }
                        }
                        if (isValidated == false) {
                          MotionToast.warning(
                                  title: Text("Warning Motion Toast"),
                                  description: Text('Nieudana walidacja'))
                              .show(context);
                          isValidated = true;
                        } else {
                          await file.write(text);
                        }
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
                        red=[];
                        isWhite=[];
                        controllersList = <TextEditingController>[];
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
                        textDuplicates=[];
                        for (int i = 0; i < data.length; i++) {
                          controllersList.add(TextEditingController());
                          if (data[i].isEmpty) {
                            data[i] += 'brak';
                          }
                          controllersList[i].text = data[i];
                          textDuplicates.add(data[i]);
                        }
                        for(int i=0; i<data.length~/15;i++){
                          isWhite.add(false);
                        }
                        if(xmlDuplicates.isNotEmpty) {
                          bool match=true;
                          for (int i = 0; i < xmlDuplicates.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=xmlDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          xmlDuplicates=[];
                        }
                        else if(databaseDuplicates.isNotEmpty){
                          bool match=true;
                          print(data.length);
                          for (int i = 0; i < databaseDuplicates.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=databaseDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          databaseDuplicates=[];
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
                        red=[];
                        isWhite=[];
                        String xmlAsString;
                        areThereData = true;
                        xmlAsString = await xml.read();
                        zmienna = 0;
                        controllersList = <TextEditingController>[];
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
                        for(int i=0; i<data.length~/15;i++){
                          isWhite.add(false);
                        }
                        if(textDuplicates.isNotEmpty) {
                          print(textDuplicates.length);
                          print(data.length);
                          bool match=true;
                          for (int i = 0; i < data.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=textDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          textDuplicates=[];
                        }
                        else if(databaseDuplicates.isNotEmpty){
                          bool match=true;
                          for (int i = 0; i < databaseDuplicates.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=databaseDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          databaseDuplicates=[];
                        }
                        for (int i = 0; i < data.length; i++) {
                          controllersList.add(TextEditingController());
                          if (data[i].isEmpty) {
                            data[i] += 'brak';
                          }
                          controllersList[i].text = data[i];
                          xmlDuplicates.add(data[i]);
                        }
                        setState(() {});
                      },
                      child: const Text('Wczytaj dane z pliku xml')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        text = "";
                        for (int i = 0; i < controllersList.length; i++) {
                          text = text + controllersList[i].text + ';';
                          if (controllersList[i].text.length < 2 &&
                              i % 15 != 6) {
                            print(controllersList[i].text);
                            isValidated = false;
                          }
                          if (i % 15 == 6 || i % 15 == 7) {
                            try {
                              int.parse(controllersList[i].text);
                            } catch (e) {
                              if (controllersList[i].text.trim() != 'brak') {
                                //print(controllersList[i].text);
                                isValidated = false;
                              }
                            }
                          }
                        }
                        if (isValidated == false) {
                          MotionToast.warning(
                                  title: Text("Warning Motion Toast"),
                                  description: Text('Nieudana walidacja'))
                              .show(context);
                          isValidated = true;
                        } else {
                          final builder = XmlBuilder();
                          DateTime dateTime = DateTime.now();
                          builder.processing(
                              'laptopy', 'moddate="${dateTime}"');
                          builder.element('Laptopy', nest: () {
                            for (int i = 0; i < (data.length - 1) ~/ 15; i++) {
                              builder.element('Laptop', nest: () {
                                builder.attribute('id', i + 1);
                                for (int j = 0; j < opis.length; j++) {
                                  if (j == 0) {
                                    builder.element(opis[j],
                                        nest: controllersList[i * 15 + j].text);
                                  } else if (j == 1) {
                                    builder.element('screen', nest: () {
                                      for (int k = 0; k < 3; k++) {
                                        builder.element(opis[j], nest: () {
                                          builder.text(
                                              controllersList[j + i * 15].text);
                                        });
                                        j++;
                                      }
                                      builder.attribute(opis[j],
                                          controllersList[j + i * 15].text);
                                    });
                                  } else if (j == 5) {
                                    builder.element('procesor', nest: () {
                                      for (int k = 0; k < 3; k++) {
                                        builder.element(opis[j], nest: () {
                                          builder.text(
                                              controllersList[j + i * 15].text);
                                        });
                                        j++;
                                      }
                                    });
                                    j--;
                                  } else if (j == 8) {
                                    builder.element(opis[j], nest: () {
                                      builder.text(
                                          controllersList[j + i * 15].text);
                                    });
                                  } else if (j == 9) {
                                    builder.element('dysk', nest: () {
                                      builder.element(opis[j], nest: () {
                                        builder.text(
                                            controllersList[j + i * 15].text);
                                      });
                                      j++;
                                      builder.attribute(opis[j],
                                          controllersList[j + i * 15].text);
                                    });
                                  } else if (j == 11) {
                                    builder.element('${opis[j]}', nest: () {
                                      for (int k = 0; k < 2; k++) {
                                        builder.element(opis[j], nest: () {
                                          builder.text(
                                              controllersList[j + i * 15].text);
                                        });
                                        j++;
                                      }
                                      j--;
                                    });
                                  } else if (j == 13 || j == 14) {
                                    builder.element('${opis[j]}', nest: () {
                                      builder.text(
                                          controllersList[j + i * 15].text);
                                    });
                                  }
                                }
                              });
                            }
                          });
                          final document = builder.buildDocument();
                          print(
                              document.toXmlString(pretty: true, indent: '\t'));
                          await xml.write(document);
                        }
                      },
                      child: const Text('Zapisz dane do XML')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        red=[];
                        List<dynamic> result;
                        result = await mySQL.getData();
                        controllersList = [];
                        data = [];
                        for (int i = 0; i < result.length; i++) {
                          controllersList.add(TextEditingController());
                          controllersList[i].text = result[i];
                          data.add(result[i].toString());
                          databaseDuplicates.add(result[i]);
                        }
                        for(int i=0; i<data.length~/15;i++){
                          isWhite.add(false);
                        }
                        if(xmlDuplicates.isNotEmpty) {
                          bool match=true;
                          for (int i = 0; i < data.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=xmlDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          xmlDuplicates=[];
                        }
                        else if(textDuplicates.isNotEmpty){
                          bool match=true;
                          for (int i = 0; i < data.length; i += 15) {
                            for(int j=0;j<15;j++){
                              if(data[i]!=textDuplicates[i]){
                                match=false;
                                break;
                              }
                            }
                            if(match){
                              red.add(i);
                            }
                            match=true;
                          }
                          textDuplicates=[];
                        }
                        data.add("");
                        setState(() {
                          print(red.length);
                          areThereData = true;
                        });
                      },
                      child: const Text('Import danych z bazy danych')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        text = "";
                        for (int i = 0; i < controllersList.length; i++) {
                          text = text + controllersList[i].text + ';';
                          if (controllersList[i].text.length < 2 &&
                              i % 15 != 6) {
                            print(controllersList[i].text);
                            isValidated = false;
                          }
                          if (i % 15 == 6 || i % 15 == 7) {
                            try {
                              int.parse(controllersList[i].text);
                            } catch (e) {
                              if (controllersList[i].text.trim() != 'brak') {
                                //print(controllersList[i].text);
                                isValidated = false;
                              }
                            }
                          }
                        }
                        if (isValidated == false) {
                          MotionToast.warning(
                                  title: Text("Warning Motion Toast"),
                                  description: Text('Nieudana walidacja'))
                              .show(context);
                          isValidated = true;
                        } else {
                          await mySQL.insertData(controllersList);
                        }
                      },
                      child: const Text('Eksport danych do bazy danych')),
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
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index]?  Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,
                                    child: TextFormField(
                                      controller: controllersList[index * 15],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15].text!=data[index*15]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,
                                    child: TextField(
                                      controller: controllersList[index * 15 + 1],
                                    ),
                                  ),
                                  onTapCancel: (){
                                      setState(() {
                                        if(controllersList[index*15+1].text!=data[index*15+1]){
                                          isWhite[index]=true;
                                        }
                                      });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 2],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+2].text!=data[index*15+2]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },)),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 3],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+3].text!=data[index*15+3]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 4],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+4].text!=data[index*15+4]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 5],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+5].text!=data[index*15+5]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 6],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+6].text!=data[index*15+6]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 7],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+7].text!=data[index*15+7]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 8],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+8].text!=data[index*15+8]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller: controllersList[index * 15 + 9],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+9].text!=data[index*15+9]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller:
                                          controllersList[index * 15 + 10],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+10].text!=data[index*15+10]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: isWhite[index] ? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller:
                                          controllersList[index * 15 + 11],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+11].text!=data[index*15+11]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: controllersList[index*15].text!=data[index*15]? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller:
                                          controllersList[index * 15 + 12],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+12].text!=data[index*15+12]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: controllersList[index*15].text!=data[index*15]? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller:
                                          controllersList[index * 15 + 13],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+13].text!=data[index*15+13]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
                                )),
                                DataCell(GestureDetector(
                                  child: Container(
                                    color: controllersList[index*15].text!=data[index*15]? Colors.white : red.contains(index*15) ? Colors.red : Colors.grey,                                  child: TextField(
                                      controller:
                                          controllersList[index * 15 + 14],
                                    ),
                                  ),
                                  onTapCancel: (){
                                    setState(() {
                                      if(controllersList[index*15+14].text!=data[index*15+14]){
                                        isWhite[index]=true;
                                      }
                                    });
                                  },
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
            ),*/
          ],
        ),
      ),
    );
  }
}
