// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, unused_import, use_build_context_synchronously

import 'dart:math';

import 'package:swift_chat/AnaEkran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName;
  const GroupInfo({required this.groupId, required this.groupName, Key? key})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}
List membersList = [];
  bool isLoading = true;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

class _GroupInfoState extends State<GroupInfo> {


  
@override
  void initState() {
    super.initState();

    getGroupDetails();
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      print(membersList);
      isLoading = false;
      setState(() {});
    });
  }

  bool checkAdmin() {
    bool isAdmin = false;

    membersList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  // Future removeMembers(int index) async {
  //   String uid = membersList[index]['uid'];

  //   setState(() {
  //     isLoading = true;
  //     membersList.removeAt(index);
  //   });

  //   await _firestore.collection('groups').doc(widget.groupId).update({
  //     "members": membersList,
  //   }).then((value) async {
  //     await _firestore
  //         .collection('users')
  //         .doc(uid)
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .delete();

  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  // void showDialogBox(int index) {
  //   if (checkAdmin()) {
  //     if (_auth.currentUser!.uid != membersList[index]['uid']) {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               content: ListTile(
  //                 onTap: () => removeMembers(index),
  //                 title: Text("Bu Üyeyi Kaldır"),
  //               ),
  //             );
  //           });
  //     }
  //   }
  // }

   void onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == _auth.currentUser!.uid) {
          membersList.removeAt(i);
        }
      }

      await _firestore.collection('groups').doc(widget.groupId).update({
        "members": membersList,
      });

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => AnaEkran()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: isLoading? Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
        ):SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              Container(
                height: size.height / 8,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 11,
                      width: size.height / 11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.group,
                        color: Colors.white,
                        size: size.height / 20, // Adjusted icon size
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.groupName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                width: size.width / 1.1,
                child: Text(
                  "${membersList.length} Members",
                  style: TextStyle(
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},//showDialogBox(index)
                      leading: Icon(Icons.account_circle,size: 36,),
                      title: Text(
                        membersList[index]['name'],
                        style: TextStyle(
                          fontSize: size.width / 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                          subtitle: Text(membersList[index]['email']),
                          trailing: Text(membersList[index]['isAdmin'] ? "Admin" : ""), // grup olusturan kisinin ismini ayaninda admin yazar

                    );
                  },
                ),
              ),
              // SizedBox(
              //   height: size.height / 20,
              // ),
              ListTile(
                onTap: onLeaveGroup,
                leading: Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
                title: Text(
                  "Gruptan çık",
                  style: TextStyle(
                    fontSize: size.width / 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
