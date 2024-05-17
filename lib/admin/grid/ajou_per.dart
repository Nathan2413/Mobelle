import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AjouterPersonnelPage extends StatefulWidget {
  const AjouterPersonnelPage({Key? key}) : super(key: key);

  @override
  _AjouterPersonnelPageState createState() => _AjouterPersonnelPageState();
}

class _AjouterPersonnelPageState extends State<AjouterPersonnelPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  String? _nomErreurText;
  String? _prenomErreurText;
  String? _emailErreurText;
  String? _adresseErreurText;
  String? _numeroErreurText;
  String? _motDePasseErreurText;
  String? _roleErreurText;
  bool _isObscured = true;
  List<String> _roles = ['admin', 'personnel'];
  String? _selectedRole;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _ajouterPersonnel() async {
    setState(() {
      _nomErreurText =
          _nomController.text.isEmpty ? 'Veuillez entrer le nom' : null;
      _prenomErreurText =
          _prenomController.text.isEmpty ? 'Veuillez entrer le prénom' : null;
      _emailErreurText =
          _emailController.text.isEmpty ? 'Veuillez entrer l\'email' : null;
      _adresseErreurText =
          _adresseController.text.isEmpty ? 'Veuillez entrer l\'adresse' : null;
      _numeroErreurText = _numeroController.text.isEmpty
          ? 'Veuillez entrer le numéro de téléphone'
          : null;
      _motDePasseErreurText = _motDePasseController.text.isEmpty
          ? 'Veuillez entrer le mot de passe'
          : null;
      _roleErreurText =
          _selectedRole == null ? 'Veuillez sélectionner le rôle' : null;
    });

    if (_formKey.currentState!.validate()) {
      int _counter = await _getNextCounter();
      String id = (_counter + 1).toString();

      // Hasher le mot de passe en MD5
      String motDePasseMD5 =
          md5.convert(utf8.encode(_motDePasseController.text)).toString();

      // Envoyer les données vers Firestore avec le mot de passe hashé
      FirebaseFirestore.instance.collection('personnel').add({
        'id': id,
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'email': _emailController.text,
        'adresse': _adresseController.text,
        'numero': _numeroController.text,
        'role': _selectedRole,
        'motDePasse': motDePasseMD5,
      }).then((value) {
        // Réinitialiser les champs après l'ajout du personnel
        _nomController.clear();
        _prenomController.clear();
        _emailController.clear();
        _adresseController.clear();
        _numeroController.clear();
        _motDePasseController.clear();
        _selectedRole = null; // Réinitialiser le rôle sélectionné

        // Afficher une boîte de dialogue de succès ou effectuer une autre action
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Personnel ajouté avec succès.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print("Erreur lors de l'ajout du personnel : $error");
        // Afficher une boîte de dialogue d'erreur ou effectuer une autre action
      });
    }
  }

  Future<int> _getNextCounter() async {
    final QuerySnapshot<Map<String, dynamic>> personnelCollection =
        await FirebaseFirestore.instance.collection('personnel').get();
    return personnelCollection.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter du personnel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _nomController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _nomErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le nom';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _prenomController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _prenomErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le prénom';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              // Email
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _emailErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer l\'email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              // Adresse
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _adresseController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon:
                        Icon(Icons.location_on, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _adresseErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer l\'adresse';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              // Numero
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _numeroController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.phone, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _numeroErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le numéro de téléphone';
                    }
                    try {
                      int.parse(value);
                    } catch (e) {
                      return 'Veuillez saisir un chiffre';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              // Role
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Rôle',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _roleErreurText,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner le rôle';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 12.0),
              // Ajout des autres champs de saisie
              // Mot de passe
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _motDePasseController,
                  obscureText: _isObscured,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[700],
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorText: _motDePasseErreurText,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer le mot de passe';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _ajouterPersonnel,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AjouterPersonnelPage(),
  ));
}
