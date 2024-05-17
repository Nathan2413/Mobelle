import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assurez-vous d'avoir le bon chemin d'accès au fichier firebase_options.dart
import 'ecran.dart'; // Importez la classe MyApp depuis le fichier ecran.dart

void main() async {
  // Assurez-vous que Firebase est initialisé avant de lancer votre application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lancez votre application Flutter avec MyApp comme point de départ
  runApp(const MyApp());
}
