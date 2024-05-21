import 'package:flutter/material.dart';
import 'package:librolandia_001/services/firebase_services.dart';
import 'package:librolandia_001/ui/pages/Footer/footer.dart';
import 'package:librolandia_001/ui/pages/Header/header.dart';
import 'package:librolandia_001/ui/pages/widgets/custom_text_field.dart';

void main() => runApp(const CrudUsers());

class CrudUsers extends StatefulWidget {
  const CrudUsers({super.key});

  @override
  State<CrudUsers> createState() => _MyAppState();
}

class _MyAppState extends State<CrudUsers> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      //HEADER:
      appBar: const AppBarAndMenu(),
      //CONTENT
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: 600,
                width: 1535,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  margin: const EdgeInsets.all(20),
                  color: Color(0xFFFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 300,
                                    child: CustomTextField(
                                      width: 200,
                                      height: 50,
                                      label: 'Titulo',
                                      controller: _titleController,
                                      onChanged: (p0) {},
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor, ingresa un título.';
                                        }
                                        return null; // Validación pasó con éxito
                                      },
                                      style: TextStyle(
                                        fontSize:
                                            14, // Tamaño de fuente ajustado
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 300,
                                    child: Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Buscar', // Texto del hint
                                          hintStyle: TextStyle(
                                              color: Colors
                                                  .grey), // Estilo del hint
                                          prefixIcon: Icon(Icons
                                              .search), // Icono del prefijo
                                          border: OutlineInputBorder(
                                            // Borde del TextField
                                            borderRadius: BorderRadius.circular(
                                                10), // Radio del borde (bordes redondeados)
                                            borderSide: BorderSide
                                                .none, // No muestra bordes
                                          ),
                                          filled:
                                              true, // Rellenar con el color especificado
                                          fillColor: Colors.grey.withOpacity(
                                              0.2), // Color de relleno del TextField
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal:
                                                  20), // Padding interno
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(16.0),
                                  child: FutureBuilder(
                                      future: getUsers(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index) {
                                              return Text(snapshot.data?[index]
                                                  ['nombre']);
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })),
                                ),
                              ),
                            ],
                          ),
                      
                          ///ddddddddddd
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      //FOOTER:
      bottomNavigationBar: const MyFooter(),
    );
  }
}
