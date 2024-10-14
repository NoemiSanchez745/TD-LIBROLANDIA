import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librolandia_001/data/model/books_model.dart';
import 'package:librolandia_001/data/model/ejemplolibros.dart';
import 'package:librolandia_001/data/remote/book_remote_datasource.dart';
import 'package:librolandia_001/ui/pages/Footer/footer.dart';
import 'package:librolandia_001/ui/pages/Header/header.dart';
import 'package:librolandia_001/ui/pages/widgets/custom_text_field.dart';

void main() => runApp(const CrudBook());

class CrudBook extends StatefulWidget {
  const CrudBook({super.key});

  @override
  State<CrudBook> createState() => _MyAppState();
}

class _MyAppState extends State<CrudBook> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _tittleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _editorialController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _generController = TextEditingController();

  String _selectedOption = 'Ingrese formato';
  bool isLoading = true;
  List<BookModel> books = [];
  final bookRemoteDataSource = BookRemoteDataSourceImpl();
  bool isPriceValid = true; // Variable para rastrear si el precio es válido
  String? priceErrorMessage; // Variable para almacenar el mensaje de error

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> registerBook() async {
    try {
      // Crear un nuevo modelo de libro usando los datos del formulario
      final newBook = BookModel(
        id: '', // Firebase generará el ID automáticamente
        tittle: _tittleController.text,
        autor: _authorController.text,
        editorial: _editorialController.text,
        gender: _generController.text,
        price: double.parse(_priceController
            .text), // Asegúrate de que el campo tenga un valor numérico
        stock: int.parse(_stockController.text),
        description: _descriptionController
            .text, // Si tienes otro controlador para descripción, cámbialo
        year: int.parse(
            _yearController.text), // Cambia el controlador si es necesario
        language:
            _languageController.text, // Cambia el controlador si es necesario
        format: _selectedOption,
        registerdate: DateTime.now(),
        status: 1, // O el estado que quieras darle por defecto
        updatedate: DateTime.now(),
      );

      // Llamar al método de datasource para agregar el libro
      await bookRemoteDataSource.addBook(newBook);

      // Mostrar mensaje de éxito y limpiar los campos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro registrado exitosamente')),
      );
      formKey.currentState?.reset(); // Limpiar formulario
      // Limpiar el campo de precio
      _priceController.clear();
      _tittleController.clear();
      _authorController.clear();
      _editorialController.clear();
      _descriptionController.clear();
      _languageController.clear();
      _priceController.clear();
      _stockController.clear();
      _yearController.clear();
      _generController.clear;
      _selectedOption = 'Ingrese formato';
      _generController.clear();

      // Actualizar la tabla de libros
      setState(() {
        loadBooks(); // Llamar a la función para recargar los libros y actualizar la tabla
      });
    } catch (e) {
      print('Error al registrar el libro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el libro: $e')),
      );
    }
  }

  Future<void> loadBooks() async {
    try {
      final loadedBooks = await bookRemoteDataSource.getBook();
      print('Books loaded: ${loadedBooks.length}');
      setState(() {
        books = loadedBooks;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        //HEADER:
        //appBar: const AppBarAndMenu(),
        //CONTENT
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
                                child: CardCentralBook(),
                              ),
                            )))
                  ],
                )
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
          //FOOTER:
          //bottomNavigationBar: const MyFooter(),
        ));
  }

  Card CardCentralBook() {
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
                child: Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Título',
                        controller: _tittleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa un título.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Autor',
                        controller: _authorController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese el autor.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Editorial',
                        controller: _editorialController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa la editorial.';
                          }
                          return null;
                        },
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Descripción',
                        controller: _descriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa la descripción.';
                          }
                          return null;
                        },
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Idioma',
                        controller: _languageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa el idioma';
                          }
                          return null;
                        },
                        type: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  await registerBook();
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
                                  _tittleController.clear();
                                  _authorController.clear();
                                  _editorialController.clear();
                                  _generController.clear();
                                  _descriptionController.clear();
                                  _yearController.clear();
                                  _descriptionController.clear();
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
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Género',
                        controller: _generController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa el género';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Precio',
                        controller: _priceController,
                        type: TextInputType.numberWithOptions(
                            decimal: true), // Teclado numérico con decimales
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^\d*\.?\d{0,2}')), // Permitir números y hasta 2 decimales
                        ],
                        onChanged: (value) {
                          setState(() {
                            // Aquí puedes manejar cualquier validación adicional si es necesario
                          });
                        },
                        // Formateamos automáticamente el valor cuando se guarda el campo
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            // Si el valor no contiene un punto decimal, agregamos ".00"
                            if (!value.contains('.')) {
                              _priceController.text = double.parse(value)
                                  .toStringAsFixed(2); // Agregamos .00
                            } else {
                              // Si ya contiene decimales, asegurarnos de que siempre tenga 2 decimales
                              _priceController.text =
                                  double.parse(value).toStringAsFixed(2);
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un precio';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price <= 0) {
                            return 'Por favor, ingresa un precio válido';
                          }
                          return null; // Precio válido
                        },
                        // onChanged: (value) {
                        //   setState(() {
                        //     formKey.currentState!
                        //         .validate(); // Valida el formulario en tiempo real
                        //   });
                        // },
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^\d+\.?\d{0,2}')),
                        // ],
                        // type: TextInputType.numberWithOptions(
                        //     decimal:
                        //         true), // Permitir teclado numérico con decimales
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Cantidad disponible(stock)',
                        controller: _stockController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese la cantidad';
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
                        label: 'Año',
                        controller: _yearController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese el año';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        type: TextInputType.number,
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
                              'Ingrese formato',
                              'Tapa blanda',
                              'Tapa dura',
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ContentDataTable(isLoading: isLoading, books: books),
              //ContentDataTable(),
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
    required this.books,
  });

  final bool isLoading;
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    print('Books in the table: ${books.length}');

    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : books.isEmpty
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
                            // DataColumn(label: Text('Id')),
                            DataColumn(label: Text('Título')),
                            DataColumn(label: Text('Autor')),
                            DataColumn(label: Text('Editorial')),
                            DataColumn(label: Text('Género')),
                            DataColumn(label: Text('Precio')),
                            DataColumn(label: Text('Stock')),
                            DataColumn(label: Text('Descripción')),
                            DataColumn(label: Text('Año')),
                            DataColumn(label: Text('Idioma')),
                            DataColumn(label: Text('Formato')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Fecha de Registro')),
                            DataColumn(label: Text('Fecha de Modificación')),
                            DataColumn(label: Text('Editar')),
                            DataColumn(label: Text('Eliminar')),
                          ],
                          rows: books
                              .map(
                                (books) => DataRow(
                                  cells: [
                                    // DataCell(Text(books.id)),
                                    DataCell(Text(books.tittle)),
                                    DataCell(Text(books.autor)),
                                    DataCell(Text(books.editorial)),
                                    DataCell(Text(books.gender)),
                                    DataCell(Text(books.price.toString())),
                                    DataCell(Text(books.stock.toString())),
                                    DataCell(Text(books.description)),
                                    DataCell(Text(books.year.toString())),
                                    DataCell(Text(books.language)),
                                    DataCell(Text(books.format)),
                                    DataCell(Text(books.status.toString())),
                                    DataCell(Text(
                                        books.registerdate.toIso8601String())),
                                    DataCell(Text(
                                        books.updatedate.toIso8601String())),
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

  void BookCreated(BookModel bookModel) async {}
}
