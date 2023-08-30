import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notlar_uygulamasii/NotDetay.dart';
import 'package:notlar_uygulamasii/NotKayit.dart';
import 'package:notlar_uygulamasii/Notlar.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  var refNotlar=FirebaseDatabase.instance.ref().child("notlar");

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:(){
            uygulamayiKapat();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notlar Uygulaması",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold),),
            StreamBuilder<DatabaseEvent>(
                stream: refNotlar.onValue,
                builder:(context,event) {
                  if (event.hasData) {
                    var notlarListesi = <Notlar>[];

                    var gelenDeger=event.data!.snapshot.value as dynamic;

                    if(gelenDeger!=null){
                      gelenDeger.forEach((key,nesne){
                        var gelenNot=Notlar.fromJson(key,nesne);
                        notlarListesi.add(gelenNot);
                      });
                    }

                    double ortalama = 0.0;

                    if (!notlarListesi!.isEmpty) {
                      double toplam = 0.0;

                      for (var n in notlarListesi) {
                        toplam = toplam + (n.not1 + n.not2) / 2;
                      }
                      ortalama = toplam / notlarListesi.length;
                    }
                    return Text("Ortalama : ${ortalama.toInt()}",
                      style: TextStyle(color: Colors.deepOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),);
                  } else {
                    return Text("Ortalama : 0", style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),);
                  }
                }
            ),
          ],
        ),
      ),
      body: WillPopScope(onWillPop: uygulamayiKapat,
        child: StreamBuilder<DatabaseEvent>(
          stream: refNotlar.onValue,
          builder: (context,event){
            if(event.hasData){
              var notlarListesi = <Notlar>[];

              var gelenDeger=event.data!.snapshot.value as dynamic;

              if(gelenDeger!=null){
                gelenDeger.forEach((key,nesne){
                  var gelenNot=Notlar.fromJson(key,nesne);
                  notlarListesi.add(gelenNot);
                });
              }

              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context,index){
                  var not=notlarListesi[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) =>NotDetay(not: not,)));
                    },
                    child: Card(
                      child: SizedBox(height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(not.ders_adi,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text(not.not1.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text(not.not2.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder:(context) =>NotKayit()));
        } ,
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
