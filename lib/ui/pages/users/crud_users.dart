import 'dart:math';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'dart:convert';
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
  bool isEditing = false; // Controla si se está editando un usuario
  UserModel? editingUser; // Almacena el usuario que se está editando


  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> registerUser() async {
    try {
      // Generar nombre de usuario
      String username = _generateUsername(
        name: _nameController.text,
        lastname: _lastnameController.text,
        surname: _surnameController.text,
        ci: _ciController.text,
      );

      // Generar contraseña y encriptarla
      String password = _generateEncryptedPassword(name: _nameController.text);

      // Crear un nuevo usuario con los datos del formulario y el nombre de usuario y contraseña generados
      final newUser = UserModel(
        id: '',
        name: _nameController.text,
        lastname: _lastnameController.text,
        surname: _surnameController.text,
        ci: int.parse(_ciController.text),
        mail: _mailController.text,
        cellphone: int.parse(_cellphoneController.text),
        registerdate: DateTime.now(),
        status: 1,
        updatedate: DateTime.now(),
        username: username,  // Nombre de usuario generado
        password: password,  // Contraseña generada y encriptada
        rol: _selectedOption,
      );

      // Llamar a la función del datasource para registrar el usuario
      await userRemoteDataSource.addUser(newUser);


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );

      _clearFields();
      loadUsers(); // Recargar la lista de usuarios
    } catch (e) {
      print('Error al registrar el usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el usuario: $e')),
      );
    }
  }

  Future<void> loadUsers() async {
    try {
      final loadedUsers = await userRemoteDataSource.getUser();
      setState(() {
        users = loadedUsers
        .where((user) => user.status == 1)
            .toList(); // Solo libros con status 1
        isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    if (editingUser != null) {
      try {
        final updatedUser = UserModel(
          id: editingUser!.id,
          name: _nameController.text,
          lastname: _lastnameController.text,
          surname: _surnameController.text,
          ci: int.parse(_ciController.text),
          mail: _mailController.text,
          cellphone: int.parse(_cellphoneController.text),
          rol: _selectedOption,
          username: editingUser!.username,  // Mantener el username sin cambios
          password: editingUser!.password,  // Mantener la password sin cambios
          registerdate: editingUser!.registerdate,
          status: editingUser!.status,
          updatedate: DateTime.now(),
        );

        await userRemoteDataSource.updateUser(updatedUser);

      
      // Actualizar la lista en la UI sin recargar todos los usuarios
      setState(() {
        // Encontrar el índice del usuario editado en la lista
        final index = users.indexWhere((user) => user.id == updatedUser.id);
        if (index != -1) {
          users[index] = updatedUser;  // Reemplazar solo el usuario editado
        }
      });


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado exitosamente')),
        );

        _clearFields();
        // loadUsers();
        setState(() {
          isEditing = false;
          editingUser = null;
        });
      } catch (e) {
        print('Error al actualizar usuario: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $e')),
        );
      }
    }
  }

  void loadUserData(UserModel user) {
    setState(() {
      isEditing = true;
      editingUser = user;  // Guardar el usuario actual en editingUser
      _nameController.text = user.name;
      _lastnameController.text = user.lastname;
      _surnameController.text = user.surname;
      _ciController.text = user.ci.toString();
      _mailController.text = user.mail;
      _cellphoneController.text = user.cellphone.toString();
      _selectedOption = user.rol;
    });
  }

  void _clearFields() {
    _nameController.clear();
    _lastnameController.clear();
    _surnameController.clear();
    _ciController.clear();
    _mailController.clear();
    _cellphoneController.clear();
    _selectedOption = 'Administrador';
  }

  // Generar nombre de usuario
  String _generateUsername({
    required String name,
    required String lastname,
    required String surname,
    required String ci,
  }) {
    // Extraer las primeras letras y los dos primeros dígitos del CI
    String namePart = name.substring(0, 2).toLowerCase();
    String lastnamePart = lastname.substring(0, 1).toLowerCase();
    String surnamePart = surname.substring(0, 1).toLowerCase();
    String ciPart = ci.substring(0, 2);

    // Generar dos números aleatorios
    Random random = Random();
    String randomPart = random.nextInt(90).toString().padLeft(2, '0');  // Asegurarse de que sea de 2 dígitos

    return namePart + lastnamePart + surnamePart + ciPart + randomPart;
  }

  // Generar y encriptar contraseña
  String _generateEncryptedPassword({required String name}) {
    // Crear una contraseña básica con los dos primeros caracteres del nombre y cuatro números aleatorios
    String namePart = name.substring(0, 2).toLowerCase();
    Random random = Random();
    String randomPart = (random.nextInt(9000) + 1000).toString();  // Generar 4 dígitos aleatorios

    // Concatenar las partes
    String rawPassword = namePart + randomPart;

    // Encriptar la contraseña usando SHA-256
    var bytes = utf8.encode(rawPassword);  // Codificar en bytes
    var digest = sha256.convert(bytes);  // Hash usando SHA-256

    return digest.toString();  // Devolver el hash en formato de cadena
  }

  // Función para eliminar usuarios (soft delete)
  Future<void> softDeleteUser(UserModel user) async {
    try {
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        lastname: user.lastname,
        surname: user.surname,
        ci: user.ci,
        mail: user.mail,
        cellphone: user.cellphone,
        rol: user.rol,
        username: user.username,
        password: user.password,
        registerdate: user.registerdate,
        status: 0, // Cambia el estado a 0
        updatedate: DateTime.now(),
      );

      await userRemoteDataSource.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario eliminado exitosamente')),
      );
      loadUsers();
    } catch (e) {
      print('Error al eliminar usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar usuario: $e')),
      );
    }
  }

  void _showDeleteDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás segura de eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/cancelar.png',
                    width: 40,
                    height: 40,
                    color: const Color(0xFF000000),
                  ),
                  const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                softDeleteUser(user);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/eliminar.png',
                    width: 40,
                    height: 40,
                    color: const Color(0xFF000000),
                  ),
                  const Text(
                    'Eliminar',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Oculta el teclado al hacer clic fuera
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xFFF5F5F5),
                  child: const AppBarAndMenu(),
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
                  children: const [
                    MyFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
                          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
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
                                child: Text(value, style: const TextStyle(color: Color(0xFF716B6B))),
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
                          if (!isEditing) ...[
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    await registerUser();
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
                                    _clearFields();
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
                          ] else ...[
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    updateUser();
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/editar.png',
                                      width: 40,
                                      height: 40,
                                      color: const Color(0xFF000000),
                                    ),
                                    const Text(
                                      'Guardar',
                                      style: TextStyle(color: Color(0xFF000000)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isEditing = false;
                                    editingUser = null;
                                    _clearFields();
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/cancelar.png',
                                      width: 40,
                                      height: 40,
                                      color: const Color(0xFF000000),
                                    ),
                                    const Text(
                                      'Cancelar',
                                      style: TextStyle(color: Color(0xFF000000)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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
              ContentDataTable(isLoading: isLoading, users: users, 
                onEdit: loadUserData, onDelete: _showDeleteDialog),
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
    required this.onEdit,
    required this.onDelete,
  });

  final bool isLoading;
  final List<UserModel> users;
  final Function(UserModel) onEdit;
  final Function(UserModel) onDelete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : users.isEmpty
                ? const Center(child: Text('No data available'))
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
                          rows: users.map((user) {
                            return DataRow(cells: [
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
                              DataCell(Center(
                                child: InkWell(
                                  onTap: () {
                                    onEdit(user); // Llama a la función para editar
                                  },
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
                              DataCell(Center(
                                child: InkWell(
                                  onTap: () {
                                    onDelete(user); // Llama a la función de eliminación
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/eliminar.png',
                                        width: 20,
                                        height: 20,
                                        color: const Color(0xFF000000),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ]);
                          }).toList(),
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
}
