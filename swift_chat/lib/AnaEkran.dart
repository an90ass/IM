// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swift_chat/Methods.dart';
class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: Center(
        child: TextButton(
           onPressed: () => logOut(context),
           child: Text("Çıkış yap"),
           ),
      ),
    );
  }
}