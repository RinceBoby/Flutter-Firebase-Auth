import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_init/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
        body: Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //
              //<<<<<Add_Data_to_firestore>>>>>//
              ElevatedButton(
                onPressed: () async {
                  CollectionReference users = firestore.collection('users');
                  // //Add with own document id//
                  // await users.add({
                  //   'name': 'Rince',
                  // });

                  //To give a specific document id//
                  await users
                      .doc("fluttere123")
                      .set({'name': 'Goolge Flutter'});
                },
                child: const Text("Add data to firestore"),
              ),

              //<<<<<Read_data_from_firestore>>>>>//
              ElevatedButton(
                onPressed: () async {
                  CollectionReference users = firestore.collection('users');
                  // // To get all documents//
                  // QuerySnapshot allResults = await users.get();
                  // allResults.docs.forEach(
                  //   (DocumentSnapshot result) {
                  //     print(result.data());
                  //   },
                  // );

                  //To get a specific document//
                  DocumentSnapshot result =
                      await users.doc('fluttere123').get();
                  print(result.data());

                  // //Stream_Builder//
                  // users.doc('flutter123').snapshots().listen(
                  //   (result) {
                  //     result.data();
                  //   },
                  // );
                },
                child: const Text("Read data from firestore"),
              ),

              //<<<<<Update_Data_In_Firestore>>>>>//
              ElevatedButton(
                onPressed: () async {
                  await firestore.collection('users').doc('flutter123').update({
                    'name': 'flutter firebase',
                  });
                },
                child: const Text("Update data in Firestore"),
              ),

              //<<<<<Delete_Data_From_Firestore>>>>>//
              ElevatedButton(
                onPressed: () async {
                  await firestore
                      .collection('users')
                      .doc('flutter123')                      .delete();
                },
                child: const Text("Delete data from Firestore"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
