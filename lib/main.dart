import 'package:flutter/material.dart';
import 'package:librolandia_001/ui/pages/book/crud_book.dart';
import 'package:librolandia_001/ui/pages/users/crud_users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librolandia',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const CrudBook(),
        // '/': (context) => const UsersView(),
        '/crud_users': (context) => const CrudUsers(),
        '/crud_book': (context) => const CrudBook(),

        
        
        },
    );
  }
}


