// ignore_for_file: unused_import, avoid_print, file_names, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/AnaEkran.dart';
import 'package:swift_chat/GirisEkrani.dart';
Future<User?> createAccount(String ad, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(ad);// fark

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": ad,
      "email": email,
      "status": "Unavalible",
      "uid": _auth.currentUser!.uid,
    });

      // print(userCrendetial?.user);
    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      print("basarli giris islemi");
      return user;
    } else {
      print("giris yapma isleminde  hata olustu");
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}



Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value){
  Navigator.push(context,  MaterialPageRoute(builder: (_) => GirisEkrani())); // cikis islemi yaptikten sonra giris ekranina geri don
    });

  } catch (e) {
    print("hata");
  }
}


