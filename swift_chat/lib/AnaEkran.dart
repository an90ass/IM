// ignore_for_file: prefer_const_constructors, unused_import, sized_box_for_whitespace, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, avoid_print, file_names, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/Methods.dart';
import 'package:swift_chat/SohbetOdasi.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    setState(() {
      isLoading = true;
    });
    print("Text in the search field: ${_search.text}");
    await _firestore
        .collection("users")
        .where("email", isEqualTo: _search.text.trim())
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          userMap = value.docs[0].data();
        } else {
          // Handle the case when no matching document is found
          userMap = null;
        }
        isLoading = false;
      });

      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20, //ekran ustunden
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Ara",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Ara"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                if (userMap != null)
                  ListTile(
                    onTap: () {
                      String currentUserDisplayName =
                          _auth.currentUser?.displayName ?? "DefaultName";
                      String rootId = chatRoomId(currentUserDisplayName,
                          userMap?['name'] ?? "DefaultName");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SohbetOdasi(
                            chatRoomId: rootId,
                            userMap: userMap,
                          ),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.black,
                    ),
                    title: Text(
                      userMap?['name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(userMap?['email']),
                    trailing: Icon(
                      Icons.chat,
                      color: Colors.black,
                    ),
                  )
                else
                  Container()
              ],
            ),
    );
  }
}
