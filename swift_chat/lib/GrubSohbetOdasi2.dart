// ignore_for_file: unused_import, file_names, must_be_immutable, unnecessary_nullable_for_final_variable_declarations, prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/group_info.dart';

class GrubSohbetOdasi2 extends StatelessWidget {
    final String groupChatId, groupName;

  GrubSohbetOdasi2({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);


  //
  

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  // String current = "user1";

  // List<Map<String, dynamic>> dummyChatList = [
  //   {"message": "User1 bu grup oluşturuldu", "type": "notify"},
  //   {
  //     "message": "hello",
  //     "sendBy": "user1",
  //     "type": "text",
  //   },
  //   {
  //     "message": "hello",
  //     "sendBy": "user2",
  //     "type": "text",
  //   },
  //   {
  //     "message": "hello",
  //     "sendBy": "user2",
  //     "type": "text",
  //   },
  //   {
  //     "message": "hello",
  //     "sendBy": "user4",
  //     "type": "text",
  //   },
  //   {
  //   "message": "User1 User8  gruba ekledi", "type": "notify",

  //   }
  // ];

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          IconButton(onPressed: () =>Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => GroupInfo(
              groupName: groupName,
              groupId: groupChatId,
            ),)
          ), icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container(); // if there is no data
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                         
                          hintText: "mesaj gonder",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.blue,
                        onPressed:onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    chatMap['sendBy'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      // } else if (chatMap['type'] == "img") {
      //   return Container(
      //     width: size.width,
      //     alignment: chatMap['sendBy'] == current
      //         ? Alignment.centerRight
      //         : Alignment.centerLeft,
      //     child: Container(
      //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      //       height: size.height / 2,
      //       child: Image.network(
      //         chatMap['message'],
      //       ),
      //     ),
      //   );}
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
