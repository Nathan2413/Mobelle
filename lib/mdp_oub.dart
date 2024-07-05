import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'login.dart'; // Importer le fichier login.dart

class MotDePasseOublie extends StatefulWidget {
  @override
  _MotDePasseOublieState createState() => _MotDePasseOublieState();
}

class _MotDePasseOublieState extends State<MotDePasseOublie> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController activationKeyController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPasswordFields = false;
  bool obscurePassword = true; // Pour gérer l'obfuscation du mot de passe

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
                builder: (context) => Login(),
              ),
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
                            "Si vous avez oublié votre mot de passe, veuillez saisir l'adresse email, le numéro de téléphone et les 4 derniers chiffres du numéro comme clé d'activation, puis envoyer",
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
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Numéro de téléphone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: activationKeyController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: 'Clé d\'activation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    if (showPasswordFields) ...[
                      TextField(
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          hintText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        obscureText: obscurePassword,
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          hintText: 'Confirmation du mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        obscureText: obscurePassword,
                      ),
                      SizedBox(height: 20.0),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        if (showPasswordFields) {
                          _updatePassword(context);
                        } else {
                          _verifyInformation(context);
                        }
                      },
                      child:
                          Text(showPasswordFields ? 'Mise à jour' : 'Vérifier'),
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

  void _verifyInformation(BuildContext context) async {
    String email = emailController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String activationKey = activationKeyController.text.trim();

    // Prendre les 4 derniers chiffres du numéro de téléphone comme clé d'activation
    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);

    try {
      // Vérifier si l'email et le numéro de téléphone existent dans la collection "personnel"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('personnel')
          .where('email', isEqualTo: email)
          .where('numero', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Vérifier si la clé d'activation correspond aux 4 derniers chiffres du numéro
        if (activationKey == lastFourDigits) {
          setState(() {
            showPasswordFields = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Clé d\'activation incorrecte. Veuillez vérifier vos données.',
              ),
            ),
          );
        }
      } else {
        // Les informations ne correspondent pas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Les informations ne correspondent pas. Veuillez vérifier vos données.",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la vérification des informations: $e',
          ),
        ),
      );
    }
  }

  void _updatePassword(BuildContext context) async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez remplir tous les champs du nouveau mot de passe.',
          ),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Les mots de passe ne correspondent pas. Veuillez réessayer.',
          ),
        ),
      );
      return;
    }

    // Calculer le hash MD5 du nouveau mot de passe
    var bytes = utf8.encode(newPassword); // Convertir le mot de passe en bytes
    var md5Hash = md5.convert(bytes); // Calculer le hash MD5

    String hashedPassword = md5Hash.toString(); // Convertir le hash en String

    // Mettre à jour Firestore avec le nouveau mot de passe hashé
    try {
      await FirebaseFirestore.instance
          .collection('personnel')
          .where('email', isEqualTo: emailController.text.trim())
          .where('numero', isEqualTo: phoneNumberController.text.trim())
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('personnel')
              .doc(querySnapshot.docs.first.id)
              .update({'motDePasse': hashedPassword}).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Mot de passe mis à jour avec succès!',
                ),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erreur lors de la mise à jour du mot de passe: $error',
                ),
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Utilisateur non trouvé. Veuillez vérifier vos informations.',
              ),
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la mise à jour du mot de passe: $e',
          ),
        ),
      );
    }

    // Réinitialiser les champs après la mise à jour réussie
    emailController.clear();
    phoneNumberController.clear();
    activationKeyController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    setState(() {
      showPasswordFields =
          false; // Cacher à nouveau les champs de mot de passe après la mise à jour
    });

    // Optionnel: Naviguer vers une autre page après la mise à jour réussie
    // Navigator.pushReplacement(...);
  }
}
