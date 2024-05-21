import 'package:flutter/material.dart';

class AppBarAndMenu extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAndMenu({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(200); // Altura total del AppBar

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height, // Altura total del AppBar
      child: Column(
        children: [
          Container(
            color: Color(0xffffffff),
            height: 100, // Altura de la primera fila
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Espaciado horizontal
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                    width: 20), // Espacio entre el logo y la caja de búsqueda
                Container(
                  width: 300,
                  child: Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar', // Texto del hint
                        hintStyle:
                            TextStyle(color: Colors.grey), // Estilo del hint
                        prefixIcon: Icon(Icons.search), // Icono del prefijo
                        border: OutlineInputBorder(
                          // Borde del TextField
                          borderRadius: BorderRadius.circular(
                              10), // Radio del borde (bordes redondeados)
                          borderSide: BorderSide.none, // No muestra bordes
                        ),
                        filled: true, // Rellenar con el color especificado
                        fillColor: Colors.grey
                            .withOpacity(0.2), // Color de relleno del TextField
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20), // Padding interno
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: 5), // Espacio entre el TextField y el botón de icono
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                    color: Colors.black,
                  ),
                  child: IconButton(
                    icon: Image.asset('assets/lupa.png'), // Icono personalizado
                    onPressed: () {
                      // Agrega aquí la lógica cuando se presione el botón
                    },
                  ),
                ),
                const SizedBox(
                    width:
                        20), // Espacio entre la caja de búsqueda y el icono de usuario
                Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  // Color de fondo del avatar del usuario
                  backgroundImage: AssetImage('assets/usuarios.png'),
                  // Aquí puedes agregar la lógica para mostrar la imagen del usuario
                ),
                SizedBox(
                    width:
                        10), // Espacio entre el icono de usuario y el nombre del usuario
                Text(
                  'Patricia Peréz', // Aquí puedes agregar el nombre de usuario
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
          ),
          Container(
            height: 90, // Altura de la segunda fila
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10,
                ),
                _buildDropdownButton(
                  context,
                  iconPath: 'assets/mapa-marcador-inicio.png',
                  buttonText: 'Inicio ', // Texto del botón
                  buttonOptions: [
                    // 'Opción 1',
                    // 'Opción 2',
                    // 'Opción 3',
                  ],
                ),
                _buildDropdownButton(
                  context,
                  iconPath: 'assets/libros.png',
                  buttonText: 'Libros ', // Texto del botón
                  buttonOptions: [
                    // 'Opción 1',
                    // 'Opción 2',
                    // 'Opción 3',
                  ],
                ),
                _buildDropdownButton(
                  context,
                  iconPath: 'assets/catalogo.png',
                  buttonText: 'Catálogo ', // Texto del botón
                  buttonOptions: [
                    'Infantiles',
                    'Novelas',
                    'Comics',
                  ],
                ),
                _buildDropdownButton(
                  context,
                  iconPath: 'assets/ventas.png',
                  buttonText: 'Ventas', // Texto del botón
                  buttonOptions: [
                    'Registrar ventas',
                    'Ventas realizadas',
                  ],
                ),
                _buildDropdownButton(
                  context,
                  iconPath: 'assets/usuarios.png',
                  buttonText: 'Usuarios ', // Texto del botón
                  buttonOptions: [
                    // 'Opción 1',
                    // 'Opción 2',
                    // 'Opción 3',
                  ],
                ),
                // SizedBox(
                //   width: 60,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para construir un botón desplegable personalizado
  Widget _buildDropdownButton(BuildContext context,
      {required String iconPath,
      required String buttonText,
      required List<String> buttonOptions,
      double itemContainerWidth = 150.0,
      double itemContainerHeight = 40.0}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton(
        color: Color(0XFFFFFFFF),
        shape: RoundedRectangleBorder(
          // Definir el borde del menú desplegable
          borderRadius: BorderRadius.circular(10),
          // side: BorderSide(color: Colors.white), // Borde blanco
        ),
        offset: Offset(0, 50),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFFFFFFF),
          ),
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 80,
                height: 30,
                alignment: AlignmentDirectional.centerStart,
              ), // Icono personalizado
              Text(buttonText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Texto en negrita
                  )),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) {
          return buttonOptions.map((String option) {
            return PopupMenuItem(
              value: option,
              child: Container(
                  width: 145, // Ancho deseado del contenedor
                  height: 50,
                  child: Text(option)),
            );
          }).toList();
        },
        onSelected: (String selectedOption) {
          // Lógica cuando se selecciona una opción
        },
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;

  MenuButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () {
          // Aquí puedes añadir la lógica para manejar la pulsación del botón
          print('Pulsaste $text');
        },
        child: Text(text),
      ),
    );
  }
}
