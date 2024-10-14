import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librolandia_001/data/model/books_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBook();
  Future<void> addBook(BookModel bookModel);
  Future<void> updateBook(BookModel updateBook);
  Future<void> deleteBook(String id);

}

class BookRemoteDataSourceImpl extends BookRemoteDataSource {
  final CollectionReference<BookModel> bookFirestoreRef =
      FirebaseFirestore.instance.collection('book').withConverter<BookModel>(
          fromFirestore: (snapshot, options) {
            print('Document data: ${snapshot.data()}'); // Mensaje de depuración
            return BookModel.fromJson(snapshot.data()!, snapshot.id);
          },
          toFirestore: (book, options) => book.toJson());

  //Método registrar un nuevo usuario
  @override
  Future<List<BookModel>> getBook() async {
    final bookDoc = await bookFirestoreRef.get();
    print('Book documents retrieved: ${bookDoc.docs.length}'); // Mensaje de depuración
    final book = bookDoc.docs.map((e) => e.data()).toList();
    print('Book list: $book'); // Mensaje de depuración
    await Future.delayed(const Duration(seconds: 1));
    return book;
  }


   @override
  Future<void> addBook(BookModel bookModel) async {
    bookFirestoreRef.add(bookModel);
  }
  
  
  @override
  Future<void> updateBook(BookModel bookModel) async {
    // Utilizamos el método `set` para actualizar un documento existente en Firestore
    await bookFirestoreRef.doc(bookModel.id).update(bookModel.toJson());
  }

 @override
  Future<void> deleteBook(String id) async {
    FirebaseFirestore.instance
      .collection("book")
      .doc(id)
      .delete(); 
}

}
