import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySQL{
  late final MySqlConnection conn;
  Future<void> establishConnection() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: '127.0.0.1',
        port: 3306,
        user: 'user',
        db: 'poniedzialek',
        password: 'user'));

    print('done');
  }

  Future<void> createTable() async{
    try{
      await conn.query(
          'CREATE TABLE Laptopy (PK_laptopy INT PRIMARY KEY AUTO_INCREMENT, producent varchar(255), wielkość_matrycy varchar(255), '
              'rozdzielczość varchar(255), typ_matrycy varchar(255), dotykowy varchar(255), procesor varchar(255), liczba_rdzeni_fizycznych varchar(255), '
              'taktowanie varchar(255), RAM varchar(255), pojemność_dysku varchar(255), typ_dysku varchar(255), '
              'karta_graficzna varchar(255), pamięć_karty_graficznej varchar(255), system_operacyjny varchar(255), '
              'napęd_optyczny varchar(255))');
      print('created');
    }
    catch(e){
      print('error $e');
    }
  }

  Future<void> insertData(List<TextEditingController> controllerList) async{
    await conn.query('truncate laptopy');
    for(int i=0; i<controllerList.length-15;i+=15) {
        await conn.query('insert into laptopy (producent, wielkość_matrycy, rozdzielczość, '
            'typ_matrycy, dotykowy, procesor, liczba_rdzeni_fizycznych, taktowanie, RAM, '
            'pojemność_dysku, typ_dysku, karta_graficzna, pamięć_karty_graficznej, system_operacyjny, '
            'napęd_optyczny) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)' ,
        [controllerList[i].text, controllerList[i+1].text, controllerList[i+2].text, controllerList[i+3].text, controllerList[i+4].text,
          controllerList[i+5].text, controllerList[i+6].text, controllerList[i+7].text, controllerList[i+8].text, controllerList[i+9].text,
          controllerList[i+10].text, controllerList[i+11].text, controllerList[i+12].text, controllerList[i+13].text, controllerList[i+14].text]);
    }
  }

  Future<List<dynamic>> getData() async{
    List<dynamic> data=[];
    var result=await conn.query('SELECT producent, wielkość_matrycy, rozdzielczość, '
        'typ_matrycy, dotykowy, procesor, liczba_rdzeni_fizycznych, taktowanie, RAM, '
        'pojemność_dysku, typ_dysku, karta_graficzna, pamięć_karty_graficznej, system_operacyjny, '
        'napęd_optyczny FROM laptopy');
    for(var row in result){
      String pom= row.toString();
      pom=pom.substring(pom.indexOf("{")+1, pom.indexOf("}"));
      final seperator = pom.split(',');
      for (String element in seperator) {
        element=element.substring(element.indexOf(':')+2, element.length);
        data.add(element);
      }
    }
    return data;
  }
}