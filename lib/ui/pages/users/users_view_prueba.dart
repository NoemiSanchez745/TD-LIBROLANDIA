import 'package:flutter/material.dart';
import 'package:librolandia_001/data/model/users_model.dart';
import 'package:librolandia_001/data/remote/user_remote_datasource.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final userRemoteDataSource = UserRemoteDataSourceImpl();
  List<UserModel> users = [];
  bool isLoading = true;

  Future<void> loadUsers() async {
    try {
      final loadedUsers = await userRemoteDataSource.getUser();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
      print('Users loaded: ${users.length}'); // Mensaje de depuración
    } catch (e) {
      print('Error loading users: $e'); // Mensaje de depuración
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(child: Text('No users found.')) // Manejo del caso de lista vacía
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Lastname')),
                      DataColumn(label: Text('Surname')),
                      DataColumn(label: Text('CI')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Cellphone')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Password')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Register Date')),
                      DataColumn(label: Text('Update Date')),
                    ],
                    rows: users
                        .map(
                          (user) => DataRow(
                            cells: [
                              DataCell(Text(user.id)),
                              DataCell(Text(user.name)),
                              DataCell(Text(user.lastname)),
                              DataCell(Text(user.surname)),
                              DataCell(Text(user.ci.toString())),
                              DataCell(Text(user.mail)),
                              DataCell(Text(user.cellphone.toString())),
                              DataCell(Text(user.rol)),
                              DataCell(Text(user.username)),
                              DataCell(Text(user.password)),
                              DataCell(Text(user.status.toString())),
                              DataCell(Text(user.registerdate.toIso8601String())),
                              DataCell(Text(user.updatedate.toIso8601String())),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
    );
  }
}
