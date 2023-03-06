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
  String text="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              maxLines: 8,
              decoration: InputDecoration.collapsed(hintText: 'Write something here'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async{
                      await file.write(textController.text);
                      print(textController.text);
                      setState(() {
                        text="";
                      });
                }, 
                    child: Text('Add to text file')),
                ElevatedButton(
                    onPressed: () async{
                      text=await file.read();
                      print('done');
                      setState(() {});
                },
                    child: Text('Show text file')),
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        text="";
                        textController.clear();
                      });
                }, child: Text('Clear text area')),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/8,
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
