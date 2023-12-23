// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
class GrouplarOlusturma extends StatelessWidget {
  const GrouplarOlusturma({super.key});

  @override
  Widget build(BuildContext context) {
      final Size size = MediaQuery.of(context).size;

    return  Scaffold(
      appBar: AppBar(
        title: Text("Group Adi"),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height/10),

  Container(
                  height: size.height / 14,
                  width: size.width,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
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
                  onPressed: (){},
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