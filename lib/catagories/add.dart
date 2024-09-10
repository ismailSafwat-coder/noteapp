import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference catagories =
      FirebaseFirestore.instance.collection('catagories');

  addcatagories() {
    if (formstate.currentState!.validate()) {
      try {
        catagories.add({
          "name": name.text,
          "id": FirebaseAuth.instance.currentUser!.uid
        }).then((value) => Text("======== the $name added"));
        Navigator.of(context).pushReplacementNamed("HomePage");
      } catch (e) {
        print("the error is $e");
      }
    }
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
                titel: "add",
                onPressed: () {
                  addcatagories();
                },
              )
            ],
          )),
    );
  }
}
