import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librolandia_001/data/model/users_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUser();
  Future<void> addUser(UserModel userModel);
  

}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final CollectionReference<UserModel> userFirestoreRef =
      FirebaseFirestore.instance.collection('user').withConverter<UserModel>(
          fromFirestore: (snapshot, options) {
            print('Document data: ${snapshot.data()}'); // Mensaje de depuración
            return UserModel.fromJson(snapshot.data()!, snapshot.id);
          },
          toFirestore: (user, options) => user.toJson());

  //Método registrar un nuevo usuario
  @override
  Future<List<UserModel>> getUser() async {
    final userDoc = await userFirestoreRef.get();
    print('User documents retrieved: ${userDoc.docs.length}'); // Mensaje de depuración
    final user = userDoc.docs.map((e) => e.data()).toList();
    print('User list: $user'); // Mensaje de depuración
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }


   @override
  Future<void> addUser(UserModel userModel) async {
    userFirestoreRef.add(userModel);
  }



}
