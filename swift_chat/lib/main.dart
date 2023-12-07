
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:swift_chat/GirisEkrani.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
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


     },
    );
  }
}