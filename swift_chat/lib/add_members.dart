// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swift_chat/gruplar_olusturma.dart';

class AddMembersInGroup extends StatelessWidget {
  const AddMembersInGroup({super.key});

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
            Flexible(child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics:NeverScrollableScrollPhysics(),
              
              itemBuilder:(context,index){
                return ListTile(
                  onTap: (){},
                  leading: Icon(Icons.account_circle),
                  title: Text("User2"),
                  trailing: Icon(Icons.close),
                );
              } 
             
            ),),
            SizedBox(
            height:size.height/20 ,
            ),
              Container(
                  height: size.height / 14,
                  width: size.width,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
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
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Ara"),
                ),
          ],
        ),
      ),



      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.forward),
        onPressed: () =>Navigator.of(context).push(
          MaterialPageRoute(builder: (_) =>GrouplarOlusturma())
        ),
      ),
    );
  }
}
