import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/service/firestore_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                          descriptionController.text.isEmpty) {
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
                        await FirestoreService().createNote(
                          titleController.text,
                          descriptionController.text,
                          widget.user.uid,
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
