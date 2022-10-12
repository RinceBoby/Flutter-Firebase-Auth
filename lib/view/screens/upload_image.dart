import 'dart:io';

import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  //<<<<<Upload_Image>>>>>//
  Future uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    String fileName = pickedImage.name;
    File imageFile = File(pickedImage.path);
    // File compressedFile = await compressImage(imageFile);

    try {
      setState(() {
        loading = true;
      });
      await firebaseStorage.ref(fileName).putFile(
          imageFile); //Pass compreddedFile instead of imageFile while compressing//
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully uploaded"),
          backgroundColor: kGreen,
        ),
      );
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //<<<<<Multiple_Image>>>>>//
  Future<void> uploadMultipleImage() async {
    final picker = ImagePicker();
    final List<XFile?> pickedImages = await picker.pickMultiImage();
    if (pickedImages == null) {
      return null;
    }
    setState(() {
      loading = true;
    });
    await Future.forEach(pickedImages, (XFile? image) async {
      String fileName = image!.name;
      File imageFile = File(image.path);

      try {
        await firebaseStorage.ref(fileName).putFile(imageFile);
      } on FirebaseException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    });
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Uploaded Successfully!"),
        backgroundColor: kGreen,
      ),
    );
  }

  //<<<<<Retrive_Image>>>>>//
  Future<List> loadImages() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach(
      allFiles,
      (Reference file) async {
        final String fileUrl = await file.getDownloadURL();
        files.add({
          'url': fileUrl,
          'path': file.fullPath,
        });
      },
    );
    print(files);
    return files;
  }

  //<<<<<Delete_Image>>>>>//
  Future deleteImage(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  // //<<<<<Compress_Image>>>>>//
  // Future<File> compressImage(File file) async {
  //   File compressedFile =
  //       await FlutterNativeImage.compressImage(file.path, quality: 50);
  //   print("Orginal size: ${file.lengthSync()}");
  //   print("Compressed image: ${compressedFile.lengthSync()}");
  //   return compressedFile;
  // }

//****************************<<<<<<<<<<>>>>>>>>>***********************//
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          // backgroundColor: Colors.amberAccent[100],
          centerTitle: true,
          title: const Text("Upload image to Firebase Storage"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //<<<<<Camera>>>>>//
                  ElevatedButton.icon(
                      onPressed: () {
                        uploadImage('camera');
                      },
                      icon: loading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                              color: kWhite,
                            ))
                          : const Icon(Icons.camera_alt_outlined),
                      label: const Text("Camera")),

                  //<<<<<Gallery>>>>>//
                  ElevatedButton.icon(
                      onPressed: () {
                        uploadImage('gallery');
                      },
                      icon: loading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                              color: kWhite,
                            ))
                          : const Icon(Icons.library_add_outlined),
                      label: const Text("Gallery")),
                ],
              ),
              kHeight20,

              //<<<<<Multiple_Image>>>>>//
              ElevatedButton.icon(
                  onPressed: () {
                    uploadMultipleImage();
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: const Text("Multiple Image")),
              kHeight15,
              Expanded(
                child: FutureBuilder(
                  future: loadImages(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(
                          color: kBlack,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map image = snapshot.data[index];
                        return Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Container(
                                  height: 200,
                                  child: Image.network(image['url']),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteImage(image['path']);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Deleted successfully"),
                                  backgroundColor: kRed,
                                ));
                              },
                              icon: const Icon(
                                Icons.delete_sweep_outlined,
                                color: kRed,
                                size: 30,
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
