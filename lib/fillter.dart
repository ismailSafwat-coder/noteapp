import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FillterPage extends StatefulWidget {
  const FillterPage({super.key});

  @override
  State<FillterPage> createState() => _FillterPageState();
}

class _FillterPageState extends State<FillterPage> {
  List<QueryDocumentSnapshot> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initdata();
  }

  Stream<QuerySnapshot> getUserDataStream() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  initdata() {
    getUserDataStream().listen((usersdata) {
      setState(() {
        data = usersdata.docs;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      floatingActionButton: FloatingActionButton(
        //adding users
        child: const Icon(Icons.add),
        onPressed: () {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          DocumentReference doc1 =
              FirebaseFirestore.instance.collection('users').doc("1");
          DocumentReference doc2 =
              FirebaseFirestore.instance.collection('users').doc("2");

          WriteBatch batch = FirebaseFirestore.instance.batch();

          batch.set(doc1, {"age": 20, "username": 'ismailssss', "money": 250});
          batch.set(doc2, {"age": 22, "username": 'ismailaaaa', "money": 260});

          batch.commit();
        },
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () async {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data[i].id);

                          try {
                            DocumentSnapshot snapshot =
                                await documentReference.get();

                            if (snapshot.exists) {
                              var snapshotdata = snapshot.data();

                              if (snapshotdata is Map<String, dynamic>) {
                                int money = snapshotdata['money'] + 100;

                                await documentReference
                                    .update({'money': money});
                              }
                            }
                          } catch (error) {
                            print("Error updating document: $error");
                          }
                        },
                        child: Card(
                          child: ListTile(
                            title: Text("User: ${data[i]["username"]}"),
                            subtitle: Text("Age: ${data[i]['age']}"),
                            trailing: Text(
                              "${data[i]['money']}\$",
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FillterPage(),
  ));
}
