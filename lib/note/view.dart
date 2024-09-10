import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/catagories/editngpage.dart';
import 'package:firbaseapp/note/add.dart';
import 'package:firbaseapp/note/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String catagoryid;
  const NoteView({super.key, required this.catagoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List data = [];
  bool loading = true;

  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("catagories")
        .doc(widget.catagoryid)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    // await Future.delayed(const Duration(seconds: 2));
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNote(docid: widget.catagoryid)));
            }),
        appBar: AppBar(
          title: const Text("notes"),
        ),
        body: WillPopScope(
          child: loading == true
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 215),
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                                  notedocid: data[i].id,
                                  catagory: widget.catagoryid,
                                  value: data[i]['note'],
                                )));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            title: 'Dialog Title',
                            desc: "are you sure to delete",
                            btnCancelOnPress: () async {},
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("catagories")
                                  .doc(widget.catagoryid)
                                  .collection("note")
                                  .doc(data[i].id)
                                  .delete();

                              if (data[i]['url'] != "none") {
                                FirebaseStorage.instance
                                    .refFromURL(data[i]['url'])
                                    .delete();
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(catagoryid: widget.catagoryid)));
                            }).show();
                      },
                      child: Card(
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    " ${data[i]['note']}",
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  if (data[i]['url'] != "none")
                                    Image.network(data[i]['url']),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false);
            return Future.value(false);
          },
        ));
  }
}
