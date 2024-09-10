import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbaseapp/catagories/editngpage.dart';
import 'package:firbaseapp/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];
  bool loading = true;

  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("catagories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
              Navigator.of(context).pushNamed("AddPage");
            }),
        appBar: AppBar(
          title: const Text("Note App "),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn google = GoogleSignIn();
                  google.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "Login",
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: loading == true
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 215),
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              NoteView(catagoryid: data[i].id)));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        btnCancelText: "delete",
                        btnOkText: "edit",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("catagories")
                              .doc(data[i].id)
                              .delete();
                          Navigator.of(context)
                              .pushReplacementNamed("HomePage");
                        },
                        btnOkOnPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditingPage(
                                  docid: data[i].id,
                                  oldname: data[i]['name'])));
                        },
                      ).show();
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.all(0),
                                child: Image.asset(
                                    "images/OneDrive_Folder_Icon.svg.png")),
                            Text(
                              " ${data[i]['name']}",
                              style: const TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
