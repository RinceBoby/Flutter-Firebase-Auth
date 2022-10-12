import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //<<<<<Add_Note>>>>>//
  Future createNote(
      String title, String description, String image, String userId) async {
    try {
      await firestore.collection('notes').add({
        'title': title,
        'description': description,
        'date': DateTime.now(),
        'userId': userId,
        'image': image,
      });
    } catch (e) {
      print(e);
    }
  }

  //<<<<<Update_Note>>>>>//
  Future updateNote(String docId, String title, String description) async {
    try {
      await firestore.collection('notes').doc(docId).update({
        'title': title,
        'description': description,
      });
    } catch (e) {
      print(e);
    }
  }

  //<<<<<Delete_Note>>>>>//
  Future deleteNote(String docId) async {
    try {
      await firestore.collection('notes').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
