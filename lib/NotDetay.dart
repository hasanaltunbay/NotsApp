import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notlar_uygulamasii/Notlar.dart';
import 'package:notlar_uygulamasii/main.dart';

class NotDetay extends StatefulWidget {

  Notlar not;
  NotDetay({required this.not});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {

  var tfDersAdi=TextEditingController();
  var tfnot1=TextEditingController();
  var tfnot2=TextEditingController();

  var refNotlar=FirebaseDatabase.instance.ref().child("notlar");

  Future<void> sil(String not_id ) async {
    refNotlar.child(not_id).remove();

    Navigator.push(context, MaterialPageRoute(builder:(context) =>Anasayfa()));
  }

  Future<void> guncelle(String not_id,String ders_adi,int not1,int not2) async {
    var bilgi =HashMap<String,dynamic>();
    bilgi["ders_adi"]=ders_adi;
    bilgi["not1"]=not1;
    bilgi["not2"]=not2;
    refNotlar.child(not_id).update(bilgi);
    Navigator.push(context, MaterialPageRoute(builder:(context) =>Anasayfa()));
  }

  @override
  void initState() {
    super.initState();

    var not=widget.not;
    tfDersAdi.text=not.ders_adi;
    tfnot1.text=not.not1.toString();
    tfnot2.text=not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Not Detay"),
        actions: [
          TextButton(onPressed:(){
            sil(widget.not.not_id);
          },
              child: Text("Sil",style: TextStyle(color: Colors.deepOrange))
          ),
          TextButton(
              onPressed:(){
                guncelle(widget.not.not_id, tfDersAdi.text, int.parse(tfnot1.text), int.parse(tfnot2.text));
              },
              child: Text("Güncelle",style: TextStyle(color: Colors.deepOrange))
          ),
        ],
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
    );
  }
}
