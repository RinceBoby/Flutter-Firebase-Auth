import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_init/model/note_model.dart';
import 'package:firebase_init/service/auth_service.dart';
import 'package:firebase_init/view/constants/spaces/dimensions.dart';
import 'package:firebase_init/view/constants/styles/colors.dart';
import 'package:firebase_init/view/screens/add_note.dart';
import 'package:firebase_init/view/screens/update_note.dart';
import 'package:firebase_init/view/screens/upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  User user;
  HomeScreen(this.user, {super.key});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[100],
          elevation: 0,
          title: Text("Home Page".toUpperCase()),
          centerTitle: true,
          actions: [
            //
            //<<<<<SignOut>>>>>//
            IconButton(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .where('userId', isEqualTo: user.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    NoteModel note =
                        NoteModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      color: Colors.greenAccent,
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: note.image,
                          placeholder: (context, url) =>
                              Image.asset('images/placeholder.jpg'),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          note.description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateNoteScreen(note: note),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text("No notes to show"),
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(
                color: kRed,
              ),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNoteScreen(user: user),
                  ),
                );
              },
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.add),
            ),
            kWidth10,
            //<<<<<Image_Firestore>>>>>//
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadImageScreen(),
                  ),
                );
              },
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.image_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
