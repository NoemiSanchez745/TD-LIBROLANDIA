import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFooter extends StatelessWidget {
  const MyFooter({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.end,
       mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    'Visítanos',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Calle Bolivar # 325 entre 25 de Mayo\n y España , Cochabamba, Bolivia',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
              // SizedBox(width: 50), // Espaciado entre los textos
              Spacer(),
              Column(
                children: [
                  Text(
                    'Información',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Lógica cuando se presiona el botón de ubicación
                               _launchURL();

                              // const url =
                              //     'https://www.google.com/maps'; // URL de tu red social
                              // // ignore: deprecated_member_use
                              // launch(
                              //     url); // Lanzar la URL al hacer clic en el botón


                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Ubicación',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(width: 20), // Espaciado entre los textos
                      Column(
                        children: [
                          Text(
                            'Horario de atención en tienda:\nLunes a Viernes: 14:00 a 19:00\nSábado, Domingo y Feriados: Cerrado',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(width: 10), // Espaciado entre los textos

                  Text(
                    'Contáctanos',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/whatsapp.png'), // Icono personalizado
                              onPressed: () {
                                // Agrega aquí la lógica cuando se presione el botón
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/facebook.png'), // Icono personalizado
                              onPressed: () {
                                // Agrega aquí la lógica cuando se presione el botón
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/correo.png'), // Icono personalizado
                              onPressed: () {
                                // Agrega aquí la lógica cuando se presione el botón
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/tiktok.png'), // Icono personalizado
                              onPressed: () {
                                // Agrega aquí la lógica cuando se presione el botón
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Spacer()
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            '© 2024 Librolandia. Todos los derechos reservados.',
            style: TextStyle(fontSize: 14.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Función para lanzar la URL al hacer clic en el botón
_launchURL() async {
  const url = 'https://www.google.com/maps'; // URL de tu red social
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
