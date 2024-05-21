import 'package:flutter/material.dart';

class Login extends StatelessWidget {
   Login({super.key});
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Color(0xFFACAEB0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  height: 350,
                  child: Card(
                    //CARD DERECHA----------
                    color: Color(0xFF000000),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Text(
                                'Librolandia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Image.asset('assets/logo.png',
                              width: 200,
                              height: 200),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 350,
                  height: 350,
                  child: Card(
                    color: const Color(0xFFF1F1F1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Inicio de Sesión',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff000000)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Ingrese su usuario',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Ingrese su contraseña',
                                prefixIcon:
                                const Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   obscurePassword = !obscurePassword;
                                    // });
                                  },
                                  icon: obscurePassword
                                      ? const Icon(Icons.visibility_outlined)
                                      : const Icon(
                                    Icons.visibility_off_outlined),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF000000),
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final username = usernameController.text;
                                    final password = passwordController.text;
                                    try {
                                      // PersonaModel? persona =
                                      // await _authenticate(
                                      //     username, password);
                                      // if (persona != null) {
                                      //   // Verificar el rol del usuario
                                      //   if (persona.rol == 'administrador') {
                                      //     // Usuario con rol de administrador
                                      //     SharedPreferences prefs =
                                      //     await SharedPreferences.getInstance();
                                      //     await prefs.setString('personId', persona.id);
                                      //     Navigator.pushNamed(
                                      //         context, '/notice_main');
                                      //   } else {
                                      //     // Usuario no tiene permisos de administrador
                                      //     Text("No tiene per");
                                      //   }
                                      // } else {
                                      //   // Error al iniciar sesión
                                      //   Text("No tiene per");
                                      // }
                                    } catch (e) {
                                      // Error al iniciar sesión
                                     Text("No tiene per");
                                    }
                                  },
                                  child: Text(
                                    "Ingresar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Divider(
                                  color: Color(0x00767676),
                                  height: 20,
                                  thickness: 2,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'O continuar con',
                                  style: TextStyle(
                                    color: Color(0x00767676),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}