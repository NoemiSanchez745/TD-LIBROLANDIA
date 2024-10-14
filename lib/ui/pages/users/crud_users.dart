import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librolandia_001/data/model/users_model.dart';
import 'package:librolandia_001/data/remote/user_remote_datasource.dart';
import 'package:librolandia_001/ui/pages/Footer/footer.dart';
import 'package:librolandia_001/ui/pages/Header/header.dart';
import 'package:librolandia_001/ui/pages/widgets/custom_text_field.dart';

class CrudUsers extends StatefulWidget {
  const CrudUsers({super.key});

  @override
  State<CrudUsers> createState() => _CrudUsersState();
}

class _CrudUsersState extends State<CrudUsers> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _cellphoneController = TextEditingController();
  String _selectedOption = 'Administrador';
  final userRemoteDataSource = UserRemoteDataSourceImpl();

  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final loadedUsers = await userRemoteDataSource.getUser();
      print('Users loaded: ${loadedUsers.length}');
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<int> generateUniqueId() async {
    final existingIds = await userRemoteDataSource.getUser();
    final ids = existingIds.map((e) => int.parse(e.id)).toSet();
    int newId;
    Random random = Random();

    do {
      newId = 4000 + random.nextInt(1001); // Genera un número entre 4000 y 5000
    } while (ids.contains(newId));

    return newId;
  }

  Map<String, String> generateUsernameAndPassword(
      String name, String lastname, String surname, int ci) {
    // Generar el nombre de usuario
    final username = name.substring(0, 2).toLowerCase() +
        lastname.substring(0, 1).toLowerCase() +
        surname.substring(0, 1).toLowerCase() +
        ci.toString().substring(0, 2);

    // Generar la contraseña
    final password =
        name.substring(0, 2).toLowerCase() + ci.toString().substring(0, 2);

    // Encriptar la contraseña
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final encryptedPassword = digest.toString();

    return {
      'username': username,
      'password': encryptedPassword,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      //appBar: const AppBarAndMenu(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating:
                false, // No se muestra automáticamente al desplazarse hacia abajo
            expandedHeight: 200.0, // Altura del AppBar expandido
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFF5F5F5),
                child:
                    const AppBarAndMenu(), // Aquí se integra el AppBar personalizado
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  SizedBox(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: 600,
                          width: 1535,
                          child: CardCenter(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //const Divider(),

                  // Aquí se añade el MyFooter
                  const MyFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar: const MyFooter(),
    );
  }

  Card CardCenter(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Nombre',
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un nombre.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Apellido Paterno',
                        controller: _lastnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un apellido paterno.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Correo',
                        controller: _mailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un correo.';
                          }
                          return null;
                        },
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: _selectedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                              });
                            },
                            items: <String>[
                              'Administrador',
                              'Usuario',
                              'Invitado'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const TextStyle(
                                        color: Color(0xFF716B6B))),
                              );
                            }).toList(),
                            underline: Container(),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    final newId = await generateUniqueId();
                                    final credentials =
                                        generateUsernameAndPassword(
                                            _nameController.text,
                                            _lastnameController.text,
                                            _surnameController.text,
                                            int.parse(_ciController.text));
                                    print('Generated ID: $newId');
                                    print(
                                        'Generated Username: ${credentials['username']}');
                                    print(
                                        'Generated Password: ${credentials['password']}');

                                    final newUser = UserModel(
                                      id: newId.toString(),
                                      name: _nameController.text,
                                      lastname: _lastnameController.text,
                                      surname: _surnameController.text,
                                      ci: int.parse(_ciController.text),
                                      mail: _mailController.text,
                                      cellphone:
                                          int.parse(_cellphoneController.text),
                                      rol: _selectedOption,
                                      username: credentials['username']!,
                                      password: credentials['password']!,
                                      status: 2, // Estado por defecto
                                      registerdate: DateTime.now(),
                                      updatedate: DateTime.now(),
                                    );
                                    print('New User: ${newUser.toJson()}');

                                    await userRemoteDataSource.addUser(newUser);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'User registered successfully!')),
                                    );
                                    // Limpiar los campos del formulario
                                    _nameController.clear();
                                    _lastnameController.clear();
                                    _surnameController.clear();
                                    _ciController.clear();
                                    _mailController.clear();
                                    _cellphoneController.clear();
                                  } catch (e) {
                                    print('Error registering user: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to register user. Please try again.')),
                                    );
                                  }
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/registrar.png',
                                    width: 40,
                                    height: 40,
                                    color: const Color(0xFF000000),
                                  ),
                                  const Text(
                                    'Registrar',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  // Limpiar los campos del formulario
                                  _nameController.clear();
                                  _lastnameController.clear();
                                  _surnameController.clear();
                                  _ciController.clear();
                                  _mailController.clear();
                                  _cellphoneController.clear();
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/borrador.png',
                                    width: 40,
                                    height: 40,
                                    color: const Color(0xFF000000),
                                  ),
                                  const Text(
                                    'Limpiar',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Apellido Materno',
                        controller: _surnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un apellido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'CI',
                        controller: _ciController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa el CI.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        type: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Celular',
                        controller: _cellphoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un celular.';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        type: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ContentDataTable(isLoading: isLoading, users: users),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentDataTable extends StatelessWidget {
  const ContentDataTable({
    super.key,
    required this.isLoading,
    required this.users,
  });

  final bool isLoading;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : users.isEmpty
                ? const Center(
                    child: Text('No data available'),
                  )
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('N° Empleado')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido paterno')),
                            DataColumn(label: Text('Apellido Materno')),
                            DataColumn(label: Text('CI')),
                            DataColumn(label: Text('Correo')),
                            DataColumn(label: Text('Celular')),
                            DataColumn(label: Text('Rol')),
                            DataColumn(label: Text('Usuario')),
                            DataColumn(label: Text('Contraseña')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Fecha de Registro')),
                            DataColumn(label: Text('Fecha de Modificación')),
                            DataColumn(label: Text('Editar')),
                            DataColumn(label: Text('Eliminar')),
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
                                    DataCell(Text(
                                        user.registerdate.toIso8601String())),
                                    DataCell(Text(
                                        user.updatedate.toIso8601String())),
                                    DataCell(Center(
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/editar.png',
                                              width: 20,
                                              height: 20,
                                              color: const Color(0xFF000000),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                    const DataCell(Center()),
                                  ],
                                ),
                              )
                              .toList(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  void UserCreated(UserModel userModel) async {}
}
