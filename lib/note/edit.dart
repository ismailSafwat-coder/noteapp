import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firbaseapp/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String value;
  final String catagory;
  const EditNote(
      {super.key,
      required this.notedocid,
      required this.catagory,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  EditNote() {
    CollectionReference collctionnote = FirebaseFirestore.instance
        .collection('catagories')
        .doc(widget.catagory)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        collctionnote.doc(widget.notedocid).update({
          "note": note.text,
        }).then((value) => Text("======== the $note added"));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(catagoryid: widget.catagory)));
      } catch (e) {
        print("the error is $e");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit "),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CustomTextFormField(
                    hint: "edit note",
                    mycontroller: note,
                    validator: (val) {
                      if (val == "") {
                        return "cant be empety";
                      }
                      return null;
                    }),
              ),
              CustomButtonAuth(
                titel: "save",
                onPressed: () {
                  EditNote();
                },
              )
            ],
          )),
    );
  }
}
