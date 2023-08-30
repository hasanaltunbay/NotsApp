import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notlar_uygulamasii/main.dart';

class NotKayit extends StatefulWidget {

  @override
  State<NotKayit> createState() => _NotKayitState();
}

class _NotKayitState extends State<NotKayit> {

  var tfDersAdi=TextEditingController();
  var tfnot1=TextEditingController();
  var tfnot2=TextEditingController();

  var refNotlar=FirebaseDatabase.instance.ref().child("notlar");

  Future<void> kayit(String ders_adi,int not1,int not2) async {
    var bilgi =HashMap<String,dynamic>();
    bilgi["not_id"]="";
    bilgi["ders_adi"]=ders_adi;
    bilgi["not1"]=not1;
    bilgi["not2"]=not2;
    refNotlar.push().set(bilgi);

    Navigator.push(context, MaterialPageRoute(builder:(context) =>Anasayfa()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Not Kayıt",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 40,left: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: InputDecoration(hintText: "Ders Adı"),
              ),
              TextField(
                controller: tfnot1,
                decoration: InputDecoration(hintText: "Not 1"),
              ),
              TextField(
                controller: tfnot2,
                decoration: InputDecoration(hintText: "Not 2"),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:(){
          kayit(tfDersAdi.text, int.parse(tfnot1.text), int.parse(tfnot2.text));
        } ,
        tooltip: 'Not Kayit',
        icon: const Icon(Icons.save),
        label: Text("Kaydet"),
      ),
    );
  }
}
