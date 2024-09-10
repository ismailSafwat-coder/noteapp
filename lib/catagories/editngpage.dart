import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditingPage extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditingPage({super.key, required this.docid, required this.oldname});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference catagories =
      FirebaseFirestore.instance.collection('catagories');

  editcatagories() {
    if (formstate.currentState!.validate()) {
      try {
        catagories.doc(widget.docid).update({"name": name.text});
        setState(() {});
        Navigator.of(context).pushReplacementNamed("HomePage");
      } catch (e) {
        print("the error is $e");
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldname;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Catagory"),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CustomTextFormField(
                    hint: "Enter Catagory",
                    mycontroller: name,
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
                  editcatagories();
                },
              )
            ],
          )),
    );
  }
}
