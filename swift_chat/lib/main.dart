
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swift_chat/AnaEkran.dart';

import 'package:swift_chat/GirisEkrani.dart';
import 'package:swift_chat/HesapOlusturmaEkrani.dart'; 

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyAYPRJsHnzptJfc5Qppbqj42EwUbjXg_10', appId: '1:780337687423:android:12df8956999764fd6bc84a', messagingSenderId: '780337687423', projectId: 'swiftchat-e622c')
  )
  :  await Firebase.initializeApp();
  runApp( const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: "/",
     routes:{
      "/" :(context) =>  GirisEkrani(),
      "/HesapOlusturmaEkrani" :(context) =>  HesapOlusturmaEkrani(),
      "/AnaEkran" :(context) =>  AnaEkran(),



     },
    );
  }
}