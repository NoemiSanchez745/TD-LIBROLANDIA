import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db=FirebaseFirestore.instance;

//LEER DATOS
Future<List> getUsers() async {
  List users = [];
  CollectionReference collectionReferenceUsers = db.collection('user');
  QuerySnapshot queryUser= await collectionReferenceUsers.get();
  queryUser.docs.forEach((documento) {
    users.add(documento.data());
  });
  return users;
 }