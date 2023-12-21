// ignore_for_file: unused_import, prefer_const_constructors, file_names, unused_local_variable, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:swift_chat/GrubSohbetOdasi2.dart';

class GrubSohbetAna extends StatefulWidget {
  const GrubSohbetAna({super.key});

  @override
  State<GrubSohbetAna> createState() => _GrubSohbetAnaState();
}

class _GrubSohbetAnaState extends State<GrubSohbetAna> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Grublar"),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GrubSohbetOdasi2(),
            )),
            leading: Icon(Icons.group),
            title: Text("Grub $index"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {},
        tooltip: "Grub Yarat",
      ),
    );
  }
}
