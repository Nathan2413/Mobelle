import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Importer le fichier login.dart

class MotDePasseOublie extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Couleur spécifique de l'image fournie
    final Color customGreenColor = Color.fromARGB(255, 54, 218, 152);

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
                child: Image.asset('images/mdp_oub.png'),
              ),
              // Grid de droite avec le formulaire
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.0), // Espace supplémentaire en haut
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Mot de passe oublié',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: customGreenColor, // Couleur spécifique
                            ),
                            textAlign: TextAlign.center, // Centrer le texte
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Si vous avez oublié votre mot de passe, veuillez saisir l'adresse email, puis envoyer",
                            textAlign: TextAlign.center, // Centrer le texte
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: emailController,
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
                        _resetPassword(context);
                      },
                      child: Text('Envoyer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customGreenColor, // Couleur spécifique
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

  void _resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    try {
      // Vérifier si l'email existe dans la collection "personnel"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('personnel')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // L'email existe, envoyer l'email de réinitialisation de mot de passe
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Un email de réinitialisation de mot de passe a été envoyé.'),
          ),
        );
      } else {
        // L'email n'existe pas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("L'email n'existe pas dans notre base de données."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Erreur lors de la réinitialisation du mot de passe: $e'),
        ),
      );
    }
  }
}
