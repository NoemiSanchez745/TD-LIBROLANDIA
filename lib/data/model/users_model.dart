import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String lastname;
  String surname;
  int ci;
  String mail;
  int cellphone;
  String rol;
  String username;
  String password;
  int status;
  DateTime registerdate;
  DateTime updatedate;

  UserModel({
    required this.username,
    required this.password,
    required this.rol,
    required this.cellphone,
    required this.ci,
    required this.id,
    required this.lastname,
    this.mail='',
    required this.name,
    required this.registerdate,
    required this.status,
    required this.surname,
    required this.updatedate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) => UserModel(
        id: id,
        username: json['username'] ?? "",
        password: json['password'] ?? "",
        rol: json['rol'] ?? "",
        cellphone: json['cellphone'] is String
            ? int.tryParse(json['cellphone']) ?? 0
            : (json['cellphone'] ?? 0),
        ci: json['ci'] is String
            ? int.tryParse(json['ci']) ?? 0
            : (json['ci'] ?? 0),
        lastname: json['lastname'] ?? "",
        mail: json['mail'] ?? "",
        name: json['name'] ?? "",
        registerdate: json['registerDate'] is Timestamp
            ? (json['registerDate'] as Timestamp).toDate()
            : DateTime.tryParse(json['registerDate'] ?? '') ?? DateTime.now(),
        status: json['status'] is String
            ? int.tryParse(json['status']) ?? 1
            : (json['status'] ?? 1),
        surname: json['surname'] ?? "",
        updatedate: json['updateDate'] is Timestamp
            ? (json['updateDate'] as Timestamp).toDate()
            : DateTime.tryParse(json['updateDate'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'username': username,
      'password': password,
      'rol': rol,
      'cellphone': cellphone,
      'ci': ci,
      'lastname': lastname,
      'mail': mail,
      'name': name,
      'registerdate': registerdate.toIso8601String(),
      'status': status,
      'surname': surname,
      'updatedate': updatedate.toIso8601String(),
    };
  }
}
