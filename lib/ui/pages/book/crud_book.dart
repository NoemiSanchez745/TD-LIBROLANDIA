import 'dart:convert';
import 'dart:ui';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librolandia_001/data/model/books_model.dart';
import 'package:librolandia_001/data/remote/book_remote_datasource.dart';
import 'package:librolandia_001/ui/pages/Footer/footer.dart';
import 'package:librolandia_001/ui/pages/Header/header.dart';
import 'package:librolandia_001/ui/pages/widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;


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
  final TextEditingController _isbnController =TextEditingController(); // Añadido
  // final TextEditingController _categoryController = TextEditingController(); // Añadido

  String _selectedOption = 'Tapa blanda';
  String _selectedOptionCategory = 'Comics';
  bool isLoading = true;
  List<BookModel> books = [];
  final bookRemoteDataSource = BookRemoteDataSourceImpl();

  bool isEditing = false; // Controla si se está editando un libro
  String? editingBookId; // ID del libro que se está editando
  BookModel? editingBook;

  // get http => null; //Almacena el libro que se esta editando
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> registerBook() async {
    try {
      final newBook = BookModel(
          id: '',
          tittle: _tittleController.text.toUpperCase(),
          autor: _authorController.text.toUpperCase(),
          editorial: _editorialController.text.toUpperCase(),
          gender: _generController.text.toUpperCase(),
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          description: _descriptionController.text,
          year: int.parse(_yearController.text),
          language: _languageController.text.toUpperCase(),
          format: _selectedOption,
          registerdate: DateTime.now(),
          status: 1,
          updatedate: DateTime.now(),
          isbn: _isbnController.text, // Campo añadido
          category: _selectedOptionCategory // Campo añadido
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
    if (editingBook != null) {
      try {
        final updatedBook = BookModel(
            id: editingBook!.id,
            tittle: _tittleController.text.toUpperCase(),
            autor: _authorController.text.toUpperCase(),
            editorial: _editorialController.text.toUpperCase(),
            gender: _generController.text.toUpperCase(),
            price: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            description: _descriptionController.text,
            year: int.parse(_yearController.text),
            language: _languageController.text.toUpperCase(),
            format: _selectedOption,
            registerdate: editingBook!.registerdate,
            status: editingBook!.status,
            updatedate: DateTime.now(),
            isbn: _isbnController.text, // Campo añadido
            category: _selectedOptionCategory // Campo añadido
            );

        await bookRemoteDataSource.updateBook(updatedBook);

// Actualizar la lista en la UI sin recargar todos los libros
        setState(() {
          // Encontrar el índice del libro editado en la lista
          final index = books.indexWhere((book) => book.id == updatedBook.id);
          if (index != -1) {
            books[index] = updatedBook; // Reemplazar solo el libro editado
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Libro actualizado exitosamente')),
        );

        _clearFields();
        // loadBooks();
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
        books = loadedBooks
            .where((book) => book.status == 1)
            .toList(); // Solo libros con status 1
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
    _isbnController.clear(); // Añadido
    _selectedOptionCategory = 'Comics'; // Añadido
    _selectedOption = 'Tapa blanda';
  }

  void loadBookData(BookModel book) {
    setState(() {
      isEditing = true;
      editingBook = book;
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
      _selectedOptionCategory = book.category;
    });
  }

  Future<void> softDeleteBook(BookModel book) async {
    try {
      final updatedBook = BookModel(
          id: book.id,
          tittle: book.tittle,
          autor: book.autor,
          editorial: book.editorial,
          gender: book.gender,
          price: book.price,
          stock: book.stock,
          description: book.description,
          year: book.year,
          language: book.language,
          format: book.format,
          registerdate: book.registerdate,
          status: 0, // Cambia el estado a 0
          updatedate: DateTime.now(),
          category: book.category,
          isbn: book.isbn);

      await bookRemoteDataSource.updateBook(updatedBook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro eliminado exitosamente')),
      );
      loadBooks();
    } catch (e) {
      print('Error al eliminar el libro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el libro: $e')),
      );
    }
  }

  void _showDeleteDialog(BookModel book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás segura de eliminar este libro?'),
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
                softDeleteBook(book);
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

// Nueva función para resetear las validaciones
  void _resetValidationMessages() {
    formKey.currentState?.reset(); // Restablecer el estado del formulario
    setState(() {}); // Vuelve a renderizar la vista
  }

// Método para obtener los datos del libro utilizando la API de Google Books
  Future<void> fetchBookData(String isbn) async {
  try {
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&key=AIzaSyD7z0Qa3voDN7UqTgE7WahdYa1pY3dI2Nc';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        var volumeInfo = data['items'][0]['volumeInfo'];

        setState(() {
          _tittleController.text =volumeInfo['title'] ?? 'Título no disponible';
          _authorController.text = (volumeInfo['authors'] != null) ? volumeInfo['authors'].join(', '): 'Autor no disponible';
          _generController.text = (volumeInfo['categories'] != null)? volumeInfo['categories'].join(', '): 'Género no disponible';
          _editorialController.text =volumeInfo['publisher'] ?? 'Editorial no disponible';
          _yearController.text=volumeInfo['year'] ?? 0;
          _languageController.text=volumeInfo['languages'] ?? 'Idioma no disponible';
          _descriptionController.text=volumeInfo['description'] ?? 'Descripción no disponible';

        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontraron datos para este ISBN')),
        );
      }
    } else {
      print('Error en la consulta: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al obtener datos del libro: ${response.statusCode}')),
      );
    }
  } catch (e) {
    print('Error al obtener datos del libro: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al obtener datos del libro: $e')),
    );
  }
}
  // Método para escanear el ISBN
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        _isbnController.text = result.rawContent;
      });
      fetchBookData(result.rawContent);
    } catch (e) {
      print('Error al escanear el código de barras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Oculta el teclado al hacer clic fuera
        _resetValidationMessages(); // Resetea las validaciones al hacer clic fuera
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
                          child: Expanded(
                            // height: 600,
                            // width: 1535,
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
                      const SizedBox(height: 10),
                      CustomTextField(
                        width: 300,
                        height: 60,
                        label: 'Ingrese el código Isbn',
                        controller: _isbnController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa el código';
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
                        height: 57,
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
                                      // 'Ingrese formato',
                                      'Tapa blanda',
                                      'Tapa dura'
                                    ].contains(_selectedOption)
                                ? _selectedOption
                                : 'Tapa blanda', // Asegura que el valor por defecto esté en la lista
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                              });
                            },
                            items: <String>[
                              // 'Ingrese formato',
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
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        height: 57,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: _selectedOptionCategory.isNotEmpty &&
                                    [
                                      // 'Ingrese formato',
                                      'Infantiles',
                                      'Novelas',
                                      'Comics',
                                    ].contains(_selectedOptionCategory)
                                ? _selectedOptionCategory
                                : 'Comics', // Asegura que el valor por defecto esté en la lista
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOptionCategory = newValue!;
                              });
                            },
                            items: <String>[
                              // 'Ingrese formato',
                              'Infantiles',
                              'Novelas',
                              'Comics',
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
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () async {
                            // //  scanBarcode;
                            // // Verifica si el campo ISBN no está vacío antes de hacer la consulta
                            if (_isbnController.text.isNotEmpty) {
                              fetchBookData(_isbnController
                                  .text); // Llama a la función que consulta a la API
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Por favor, ingresa el ISBN antes de buscar.')),
                              );
                            }

                            
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/escanear.png',
                                width: 40,
                                height: 40,
                                color: const Color(0xFF000000),
                              ),
                              const Text(
                                'Escanear ISBN',
                                style: TextStyle(color: Color(0xFF000000)),
                              ),
                            ],
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
                onDelete: _showDeleteDialog, // Pasa la función de eliminar
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
    required this.onDelete,
  });

  final bool isLoading;
  final List<BookModel> books;
  final Function(BookModel) onEdit;
  final Function(BookModel) onDelete;

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
                            DataColumn(label: Text('Año')),
                            DataColumn(label: Text('Idioma')),
                            DataColumn(label: Text('Formato')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Fecha de Registro')),
                            DataColumn(label: Text('Fecha de Modificación')),
                            DataColumn(label: Text('Isbn')),
                            DataColumn(label: Text('Descripción')),
                            DataColumn(label: Text('Editar')),
                            DataColumn(label: Text('Eliminar')),

                          ],
                          rows: books.map((book) {
                            return DataRow(cells: [
                              DataCell(Text(book.tittle)),
                              DataCell(Text(book.autor)),
                              DataCell(Text(book.editorial)),
                              DataCell(Text(book.gender)),
                              DataCell(Text(book.price.toString())),
                              DataCell(Text(book.stock.toString())),
                              DataCell(Text(book.year.toString())),
                              DataCell(Text(book.language)),
                              DataCell(Text(book.format)),
                              DataCell(Text(book.status.toString())),
                              DataCell(
                                  Text(book.registerdate.toIso8601String())),
                              DataCell(Text(book.updatedate.toIso8601String())),
                              DataCell(Text(book.isbn)),
                              DataCell(Text(book.description)),
                              DataCell(
                                Center(
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
                                )),
                              ),
                              DataCell(
                                Center(
                                    child: InkWell(
                                  onTap: () {
                                    onDelete(
                                        book); // Llama a la función de eliminación
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
                                )),
                              ),
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
