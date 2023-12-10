// ignore_for_file: prefer_const_constructors, unused_import, sized_box_for_whitespace, unused_field, no_leading_underscores_for_local_identifiers, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/Methods.dart';
class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  Map <String,dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  void onSearch() async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  setState(() {
    isLoading = true;
  });
  print("Text in the search field: ${_search.text}");
  await _firestore.collection("users").where("email", isEqualTo: _search.text.trim()).get().then((value) {
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
    return  Scaffold(
      appBar: AppBar(title: Text("Ana Sayfa")),
      body: isLoading?Center(child: Container(
        height: size.height/20,
        width: size.width/20,
        child: CircularProgressIndicator(),
      ),): Column(children: [
            SizedBox(
                height: size.height/20,//ekran ustunden
            ),
            Container(
              height: size.height/14,
              width: size.width,
              child: Container(
                height: size.height/14,
                width: size.width/1.2,
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
              height: size.height/30,
            ),
            ElevatedButton( onPressed:onSearch,
            
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,), 
            child: Text("Ara"),
            ),
          SizedBox(
            height: size.height/30,
          ),
            userMap != null ? ListTile(
              leading: Icon(Icons.account_box,color: Colors.black,),
              title: Text(userMap?['name'],style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),),
              subtitle:Text (userMap?['email']),
              trailing: Icon(Icons.chat,color: Colors.black,),
            ):Container()



      ],),
    );
  }
 
}