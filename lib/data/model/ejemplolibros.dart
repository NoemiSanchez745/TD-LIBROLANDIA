// import 'package:cloud_firestore/cloud_firestore.dart';

// class BookModel {
//   String id;
//   String tittle;
//   String autor;
//   String editorial;
//   String gender;
//   double price;
//   int stock;
//   String description;
//   int year;
//   String language;
//   String format;
//   int status;
//   DateTime registerdate;
//   DateTime updatedate;

//   BookModel({
//     required this.tittle,
//     required this.autor,
//     required this.editorial,
//     required this.gender,
//     required this.price,
//     required this.id,
//     required this.stock,
//     this.description = '',
//     required this.year,
//     required this.language,
//     required this.format,
//     required this.registerdate,
//     required this.status,
//     required this.updatedate,
//   });

//   factory BookModel.fromJson(Map<String, dynamic> json, String id) => BookModel(
//         id: id,
//         tittle: json['tittle'] ?? "",
//         autor: json['autor'] ?? "",
//         editorial: json['editorial'] ?? "",
//         gender: json['gender'] ??"",
//         price: double.tryParse(json['price']) ?? 0,
//         stock: int.tryParse(json['lastname']) ?? 0,
//         description: json['description'] ?? "",
//         year: int.tryParse(json['year']) ?? 0,
//         language: json['language'] ?? "",
//         format: json['format'] ?? "",
//         registerdate: json['registerDate'] is Timestamp
//             ? (json['registerDate'] as Timestamp).toDate()
//             : DateTime.tryParse(json['registerDate'] ?? '') ?? DateTime.now(),
//         status: json['status'] is String
//             ? int.tryParse(json['status']) ?? 1
//             : (json['status'] ?? 1),
//         updatedate: json['updateDate'] is Timestamp
//             ? (json['updateDate'] as Timestamp).toDate()
//             : DateTime.tryParse(json['updateDate'] ?? '') ?? DateTime.now(),
//       );

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'tittle': tittle,
//       'autor': autor,
//       'editorial': editorial,
//       'gender': gender,
//       'price': price,
//       'stock': stock,
//       'description': description,
//       'year': year,
//       'language': language,
//       'format': format,
//       'registerdate': registerdate.toIso8601String(),
//       'status': status,
//       'updatedate': updatedate.toIso8601String(),
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel2 {
  String id;
  String tittle;
  String autor;
  String editorial;
  String gender;
  double price;
  int stock;
  String description;
  int year;
  String language;
  String format;
  int status;
  DateTime registerdate;
  DateTime updatedate;

  BookModel2({
    required this.tittle,
    required this.autor,
    required this.editorial,
    required this.gender,
    required this.price,
    required this.id,
    required this.stock,
    this.description = '',
    required this.year,
    required this.language,
    required this.format,
    required this.registerdate,
    required this.status,
    required this.updatedate,
  });

  factory BookModel2.fromJson(Map<String, dynamic> json, String id) => BookModel2(
        id: id,
        tittle: json['tittle'] ?? "",
        autor: json['autor'] ?? "",
        editorial: json['editorial'] ?? "",
        gender: json['gender'] ??"",
        price: double.tryParse(json['price']) ?? 0,
        stock: int.tryParse(json['stock']) ?? 0,
        description: json['description'] ?? "",
        year: int.tryParse(json['year']) ?? 0,
        language: json['language'] ?? "",
        format: json['format'] ?? "",
        registerdate: json['registerDate'] is Timestamp
            ? (json['registerDate'] as Timestamp).toDate()
            : DateTime.tryParse(json['registerDate'] ?? '') ?? DateTime.now(),
        status: json['status'] is String
            ? int.tryParse(json['status']) ?? 1
            : (json['status'] ?? 1),
        updatedate: json['updateDate'] is Timestamp
            ? (json['updateDate'] as Timestamp).toDate()
            : DateTime.tryParse(json['updateDate'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tittle': tittle,
      'autor': autor,
      'editorial': editorial,
      'gender': gender,
      'price': price,
      'stock': stock,
      'description': description,
      'year': year,
      'language': language,
      'format': format,
      'registerdate': registerdate.toIso8601String(),
      'status': status,
      'updatedate': updatedate.toIso8601String(),
    };
  }
}
