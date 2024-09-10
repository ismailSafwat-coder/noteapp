import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePaker extends StatefulWidget {
  const ImagePaker({super.key});

  @override
  State<ImagePaker> createState() => _ImagePakerState();
}

class _ImagePakerState extends State<ImagePaker> {
  File? file;
  File? file1;
  String? url;

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

  getimgae1() async {
    final ImagePicker picker = ImagePicker();
// Capture a photo.
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imagecamera != null) {
      file1 = File(imagecamera.path);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("image picker"),
      ),
      body: ListView(
        children: [
          MaterialButton(
            color: Colors.redAccent,
            child: const Text("get image"),
            onPressed: () async {
              await getimgae();
            },
          ),
          MaterialButton(
            color: Colors.redAccent,
            child: const Text("get image1"),
            onPressed: () async {
              await getimgae1();
            },
          ),
          if (url != null) Image.network(url!),
          if (file1 != null) Image.file(file1!)
        ],
      ),
    );
  }
}


// Pick an image.
// final XFile? imgaegallery = await picker.pickImage(source: ImageSource.gallery);