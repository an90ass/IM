// ignore_for_file: prefer_const_constructors, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/gruplar_olusturma.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  // List membersList = [];
  List<Map<String, dynamic>> membersList = [];

  @override
  void initState() {
    super.initState();
    getCurrentUserDeta();
  }

  void getCurrentUserDeta() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((userMap) {
      setState(() {
        membersList.add({
          "name": userMap['name'],
          "email": userMap['email'],
          "uid": userMap['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser?.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  void onSearch() async {
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
          userMap = null;
        }
        isLoading = false;
      });

      print(userMap);
    });
  }

  bool isAlreadyExist = false;

  void onResulTap() {
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap?['uid']) {
        isAlreadyExist = true;
      }
    }
    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });
        userMap = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onRemoveMembers(index),
                      leading: Icon(Icons.account_circle),
                      title: Text(membersList[index]['name']),
                      subtitle: Text(membersList[index]['email']),
                      trailing: Icon(Icons.close),
                    );
                  }),
            ),
            SizedBox(
              height: size.height / 20,
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
            isLoading
                ? Container(
                    height: size.height / 10,
                    width: size.width / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text("Ara"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onResulTap,
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: Icon(Icons.add),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => GrouplarOlusturma(membersList:membersList,))),
            )
          : SizedBox(),
    );
  }
}
