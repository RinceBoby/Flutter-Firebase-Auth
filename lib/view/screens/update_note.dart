import 'package:firebase_init/model/note_model.dart';
import 'package:firebase_init/service/firestore_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateNoteScreen extends StatefulWidget {
  UpdateNoteScreen({super.key, required this.note});

  NoteModel note;
  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    super.initState();
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
          actions: [
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Do you need to delete?"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              FirestoreService().deleteNote(widget.note.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Note deleted!"),
                                  backgroundColor: kRed,
                                ),
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text("No")),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_outline_outlined,
                color: kRed,
                size: 30,
              ),
            ),
            kWidth10,
          ],
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
                            child: CupertinoActivityIndicator(color: kWhite))
                        : const Text("Update Note"),
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
                        await FirestoreService().updateNote(
                          widget.note.id,
                          titleController.text,
                          descriptionController.text,
                        );
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Note Updated!"),
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
