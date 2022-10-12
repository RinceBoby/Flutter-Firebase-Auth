import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String id;
  String title;
  String description;
  Timestamp date;
  String userId;
  String image;
  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId,
    required this.image,
  });

  factory NoteModel.fromJson(DocumentSnapshot snapshot) {
    return NoteModel(
      id: snapshot.id, //***This id is the document id in firestore***//
      title: snapshot['title'],
      description: snapshot['description'],
      date: snapshot['date'],
      userId: snapshot['userId'],
      image: snapshot['image'],
    );
  }
}
