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
      
        cellphone: int.tryParse(json['cellphone']?.toString() ?? '0') ?? 0,
       
        ci: int.tryParse(json['ci']?.toString() ?? '0') ?? 0,
        lastname: json['lastname'] ?? "",
        mail: json['mail'] ?? "",
        name: json['name'] ?? "",
       
        surname: json['surname'] ?? "",
        registerdate: DateTime.parse( json['registerdate']),
      
        status: json['status'] is String
      ? int.tryParse(json['status']) ?? 1
      : (json['status'] ?? 1),
        updatedate: DateTime.parse( json['updatedate']),
     
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
