// ignore_for_file: unused_import, sized_box_for_whitespace, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SohbetOdasi extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;

  // ignore: use_key_in_widget_constructors
  SohbetOdasi({this.chatRoomId, this.userMap});

  final TextEditingController _massage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(userMap?['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return Text(snapshot.data?.docs[index]['message']);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
                stream: null,
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
                        controller: _massage,
                        decoration: InputDecoration(
                          hintText: "mesaj gonder",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    IconButton(icon: Icon(Icons.send), onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
