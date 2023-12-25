// ignore_for_file: unused_import, prefer_const_constructors, file_names, unused_local_variable, sort_child_properties_last, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/GrubSohbetOdasi2.dart';
import 'package:swift_chat/add_members.dart';

class GrubSohbetAna extends StatefulWidget {
  const GrubSohbetAna({super.key});

  @override
  State<GrubSohbetAna> createState() => _GrubSohbetAnaState();
}

class _GrubSohbetAnaState extends State<GrubSohbetAna> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;




  bool isLoading = true;
  List groupList = [];
  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    // String? uid = _auth.currentUser?.uid;
    // await _auth.currentUser?.reload();
    // String? uid = _auth.currentUser?.uid;
      String uid = _auth.currentUser!.uid;

 print("******************************غ4444444444444");
    print(uid);

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        // isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gruplar"),
      ),
      body:
          //  : isLoading? Container(
          //   height: size.height,
          //   width: size.width,
          //   alignment: Alignment.center,
          //   child: CircularProgressIndicator(),
//):
          ListView.builder(
        itemCount: groupList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GrubSohbetOdasi2(
                groupName: groupList[index]['name'],
                groupChatId: groupList[index]['id'],

              ),
            )),
            leading: Icon(Icons.group),
            title: Text(groupList[index]['name']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddMembersInGroup()),
        ),
        tooltip: "Grup olustur",
      ),
    );
  }
}
