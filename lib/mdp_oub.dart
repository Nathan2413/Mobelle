import 'package:flutter/material.dart';
import 'login.dart'; // Importer le fichier login.dart

class MotDePasseOublie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fond transparent
        elevation: 0, // Pas d'ombre
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Login()), // Revenir à la page de connexion
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              // Grid de gauche avec l'image
              Container(
                child: Image.asset('images/pou5.jpeg'),
              ),
              // Grid de droite avec le formulaire
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mot de passe oublié',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Action à effectuer lorsque le bouton est pressé
                      },
                      child: Text('Envoyer'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
