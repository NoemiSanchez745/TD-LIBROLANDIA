import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librolandia_001/data/model/users_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUser();
  Future<void> addUser(UserModel userModel);
  Future<void> updateUser(UserModel updateUser);
  Future<void> deleteUser(String id);
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
    print(
        'User documents retrieved: ${userDoc.docs.length}'); // Mensaje de depuración
    final user = userDoc.docs.map((e) => e.data()).toList();
    print('User list: $user'); // Mensaje de depuración
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  //  @override
  // Future<void> addUser(UserModel userModel) async {
  //   userFirestoreRef.add(userModel);
  // }

  //Con este método capturamos el id y no se queda en blanco el campo id al momento de registrar
  @override
  Future<void> addUser(UserModel userModel) async {
    // Agregamos el documento y obtenemos la referencia
    DocumentReference docRef = await userFirestoreRef.add(userModel);

    // Actualizamos el id del usuario con el id generado por Firestore
    await userFirestoreRef.doc(docRef.id).update({'id': docRef.id});
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    // Utilizamos el método `set` para actualizar un documento existente en Firestore
    await userFirestoreRef.doc(userModel.id).update(userModel.toJson());
  }

  @override
  Future<void> deleteUser(String id) async {
    FirebaseFirestore.instance.collection("user").doc(id).delete();
  }
}
