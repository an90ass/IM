
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
Future<User?> createAccount(String ad, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password))
        .user;
    if (user != null) {
      print("Basarli bir sekilde hesap olusturuldu ");
      return user;
    } else {
      print("hesap olusturma aninda hata olustu");
      return null;   
    }
  } catch (e) {
    print(e);
    return null; 
  }
}


