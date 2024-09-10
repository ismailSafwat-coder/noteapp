import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firbaseapp/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  String? url;

  addnote(context) {
    CollectionReference collctionnote = FirebaseFirestore.instance
        .collection('catagories')
        .doc(widget.docid)
        .collection("note");
    if (formstate.currentState!.validate()) {
      try {
        collctionnote.add({"note": note.text, "url": url ?? "none"}).then(
            (value) => Text("======== the $note added"));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(catagoryid: widget.docid)));
      } catch (e) {
        print("the error is $e");
      }
    }
  }

  File? file;

  getimgae() async {
    final ImagePicker picker = ImagePicker();
// Capture a photo.
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagecamera != null) {
      file = File(imagecamera.path);

      var imagename = basename(imagecamera.path);

      var refstoreg = FirebaseStorage.instance.ref("images/$imagename");
      await refstoreg.putFile(file!);
      url = await refstoreg.getDownloadURL();
      print("===============done");
    }

    setState(() {});
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
        title: const Text("Add Note"),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CustomTextFormField(
                    hint: "Enter note",
                    mycontroller: note,
                    validator: (val) {
                      if (val == "") {
                        return "cant be empety";
                      }
                      return null;
                    }),
              ),
              CustomButtonUpLoading(
                  titel: "UpLoadImage",
                  onPressed: () async {
                    await getimgae();
                  },
                  isSelected: url == null ? false : true),
              if (url != null) Image.network(url!),
              CustomButtonAuth(
                titel: "add",
                onPressed: () {
                  addnote(context);
                },
              )
            ],
          )),
    );
  }
}
