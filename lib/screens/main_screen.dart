import 'package:flutter/material.dart';
import 'package:zajecia/functions/file_operations.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final textController = TextEditingController();
  final FileOperations file=FileOperations();
  List<String> data=<String>[];
  List<String> dataPom=<String>[];
  List<String> company=<String>[];
  List<int> companyApp=<int>[];
  int zmienna=0;
  String text="";
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
    'Pamiec 2',
    'Dysk',
    'Grafika',
    'Pamiec 3',
    'System operacyjny',
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
            TextField(
              controller: textController,
              maxLines: 8,
              decoration: InputDecoration.collapsed(hintText: 'Write something here'),
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        await file.write(textController.text);
                        print(textController.text);
                        setState(() {
                          text="";
                        });
                  },
                      child: Text('Add to text file')),
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        data=<String>[];
                        dataPom=<String>[];
                        zmienna=0;
                        text=await file.read();
                        print('done');
                        final seperator=text.split(';');
                        seperator.forEach((element) {
                          if(zmienna>14) {
                            data.add('-----------------------------------------------------------');
                            dataPom.add('123');
                            zmienna = 0;
                          }
                          if(zmienna==0){
                            if(company.contains(element)){
                              int help=company.indexOf(element);
                              companyApp[help]+=1;
                            }
                            else{
                              company.add(element);
                              companyApp.add(1);
                            }
                          }
                          data.add('${opis[zmienna]}: ${element}');
                          dataPom.add(element);
                          zmienna++;
                        });
                        for(int i=0;i<data.length;i++)
                          if(dataPom[i].isEmpty) {
                            data[i] += ' brak';
                          }
                        setState(() {});
                  },
                      child: Text('Show text file')),
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          text="";
                          textController.clear();
                        });
                  }, child: Text('Clear text area')),
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () async{
                        text=await file.read();
                        setState(() {
                          textController.text=text;
                        });
                      }, child: Text('Modify text file')),
                  SizedBox(width: 20,),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              child: ListView(
                children: [
                  for(int i=0;i<data.length-1;i++)
                    Text(data[i]),
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
