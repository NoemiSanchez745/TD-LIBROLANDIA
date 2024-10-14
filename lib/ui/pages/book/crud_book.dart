import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librolandia_001/data/model/books_model.dart';
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

  bool isEditing = false; // Controla si se está editando un libro
  String? editingBookId; // ID del libro que se está editando

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> registerBook() async {
    try {
      final newBook = BookModel(
        id: '',
        tittle: _tittleController.text,
        autor: _authorController.text,
        editorial: _editorialController.text,
        gender: _generController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        description: _descriptionController.text,
        year: int.parse(_yearController.text),
        language: _languageController.text,
        format: _selectedOption,
        registerdate: DateTime.now(),
        status: 1,
        updatedate: DateTime.now(),
      );

      await bookRemoteDataSource.addBook(newBook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro registrado exitosamente')),
      );
      _clearFields();
      loadBooks();
    } catch (e) {
      print('Error al registrar el libro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el libro: $e')),
      );
    }
  }

  Future<void> updateBook() async {
    if (editingBookId != null) {
      try {
        final updatedBook = BookModel(
          id: editingBookId!,
          tittle: _tittleController.text,
          autor: _authorController.text,
          editorial: _editorialController.text,
          gender: _generController.text,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          description: _descriptionController.text,
          year: int.parse(_yearController.text),
          language: _languageController.text,
          format: _selectedOption,
          registerdate: DateTime.now(),
          status: 1,
          updatedate: DateTime.now(),
        );

        await bookRemoteDataSource.updateBook(updatedBook);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Libro actualizado exitosamente')),
        );

        _clearFields();
        loadBooks();
        setState(() {
          isEditing = false;
          editingBookId = null;
        });
      } catch (e) {
        print('Error al actualizar el libro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el libro: $e')),
        );
      }
    }
  }

  Future<void> loadBooks() async {
    try {
      final loadedBooks = await bookRemoteDataSource.getBook();
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

  void _clearFields() {
    _tittleController.clear();
    _authorController.clear();
    _editorialController.clear();
    _descriptionController.clear();
    _languageController.clear();
    _priceController.clear();
    _stockController.clear();
    _yearController.clear();
    _generController.clear();
    _selectedOption = 'Ingrese formato';
  }

  void loadBookData(BookModel book) {
    setState(() {
      isEditing = true;
      editingBookId = book.id;
      _tittleController.text = book.tittle;
      _authorController.text = book.autor;
      _editorialController.text = book.editorial;
      _descriptionController.text = book.description;
      _languageController.text = book.language;
      _priceController.text = book.price.toString();
      _stockController.text = book.stock.toString();
      _yearController.text = book.year.toString();
      _generController.text = book.gender;
      _selectedOption = book.format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          child: CardCentralBook(),
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [MyFooter()],
              ),
            ),
          ),
        ],
      ),
    );
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
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: _clearFields,
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
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
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
                                  updateBook();
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
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
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
                                  editingBookId = null;
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
                                      style:
                                          TextStyle(color: Color(0xFF000000)),
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
                        type: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un precio';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price <= 0) {
                            return 'Por favor, ingresa un precio válido';
                          }
                          return null;
                        },
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
                            value: _selectedOption.isNotEmpty &&
                                    [
                                      'Ingrese formato',
                                      'Tapa blanda',
                                      'Tapa dura'
                                    ].contains(_selectedOption)
                                ? _selectedOption
                                : 'Ingrese formato', // Asegura que el valor por defecto esté en la lista
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
              ContentDataTable(
                isLoading: isLoading,
                books: books,
                onEdit: loadBookData,
              ),
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
    required this.onEdit,
  });

  final bool isLoading;
  final List<BookModel> books;
  final Function(BookModel) onEdit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : books.isEmpty
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
                          ],
                          rows: books.map((book) {
                            return DataRow(cells: [
                              DataCell(Text(book.tittle)),
                              DataCell(Text(book.autor)),
                              DataCell(Text(book.editorial)),
                              DataCell(Text(book.gender)),
                              DataCell(Text(book.price.toString())),
                              DataCell(Text(book.stock.toString())),
                              DataCell(Text(book.description)),
                              DataCell(Text(book.year.toString())),
                              DataCell(Text(book.language)),
                              DataCell(Text(book.format)),
                              DataCell(Text(book.status.toString())),
                              DataCell(
                                  Text(book.registerdate.toIso8601String())),
                              DataCell(Text(book.updatedate.toIso8601String())),
                              DataCell(Center(
                                child: InkWell(
                                  onTap: () {
                                    onEdit(
                                        book); // Llama a la función para editar
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
                                  )
                                ),
                              ),
                               DataCell(Center(
                                child: InkWell(
                                  onTap: () {
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
                                  )
                                ),
                              )
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
