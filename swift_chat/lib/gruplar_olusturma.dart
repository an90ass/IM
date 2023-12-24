// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/AnaEkran.dart';
import 'package:uuid/uuid.dart';

class GrouplarOlusturma extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;
  // const GrouplarOlusturma({super.key, required this.membersList});
  const GrouplarOlusturma({required this.membersList, Key? key})
      : super(key: key);

  @override
  State<GrouplarOlusturma> createState() => _GrouplarOlusturmaState();
}

class _GrouplarOlusturmaState extends State<GrouplarOlusturma> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void creatGroup() async {
    setState(() {
      isLoading = true;
    });
    String groupId = Uuid().v1();
    await _firestore
        .collection('groups')
        .doc(groupId)
        .set({"members": widget.membersList, "id": groupId});
    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({"name": _groupName.text, "id": groupId});
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => AnaEkran()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Adi"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(height: size.height / 10),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: "Grup adı giriniz",
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
                  onPressed: creatGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Grup oluştur"),
                ),
              ],
            ),
    );
  }
}
