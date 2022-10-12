import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/service/firestore_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNoteScreen extends StatefulWidget {
  AddNoteScreen({super.key, required this.user});
  User user;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  //<<<<<Pick_Image>>>>>//
  File? imageFile;
  String? fileName;

  Future uploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    setState(() {
      fileName = pickedImage.name;
      imageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kTrans,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => uploadImage(),
                  child: Container(
                    height: 150,
                    child: imageFile == null
                        ? const Center(
                            child: Icon(
                            Icons.image_outlined,
                            size: 100,
                          ))
                        : Center(
                            child: Image.file(imageFile!),
                          ),
                  ),
                ),
                kHeight30,
                //<<<<<Title>>>>>//
                const Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kHeight10,
                CupertinoTextField(
                  controller: titleController,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: kRadius05,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.turned_in_not_outlined),
                  ),
                  padding: const EdgeInsets.all(15),
                  placeholder: "Title",
                ),
                kHeight20,
                //<<<<<Description>>>>>//
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kHeight15,
                CupertinoTextField(
                  controller: descriptionController,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: kRadius05,
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.description_outlined),
                  ),
                  placeholder: "Description",
                  padding: const EdgeInsets.all(15),
                  maxLines: 10,
                  minLines: 5,
                ),

                //<<<<<Button>>>>>//
                kHeight30,
                Center(
                  child: CupertinoButton.filled(
                    child: loading
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: kWhite,
                            ),
                          )
                        : const Text("Add Note"),
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("All fields are required"),
                            backgroundColor: kRed,
                          ),
                        );
                      } else {
                        setState(() {
                          loading = true;
                        });

                        //<<<<<Image>>>>>//
                        String imageUrl = await FirebaseStorage.instance
                            .ref(fileName)
                            .putFile(imageFile!)
                            .then((result) {
                          return result.ref.getDownloadURL();
                        });
                        print(imageUrl);

                        //<<<<<Inserting_Note>>>>>//
                        await FirestoreService().createNote(
                          titleController.text,
                          descriptionController.text,
                          widget.user.uid,
                          imageUrl,
                        );
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Note added!"),
                            backgroundColor: kGreen,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
