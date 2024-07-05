import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ListPersonnel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste du personnel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildPersonnelList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonnelList(BuildContext context) {
    double tableWidth =
        MediaQuery.of(context).size.width * 0.9; // 90% de la largeur de l'écran

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('personnel')
          .where('role', isEqualTo: 'personnel')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final personnel = snapshot.data!.docs;

        return SizedBox(
          width: tableWidth,
          child: DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text('Nom')),
              DataColumn(label: Text('Prénom')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Adresse')),
              DataColumn(label: Text('Numéro de téléphone')),
              DataColumn(
                label: Text('Actions'),
                numeric: false,
              ),
            ],
            rows: personnel.map((doc) {
              final nom = doc['nom'];
              final prenom = doc['prenom'];
              final email = doc['email'];
              final adresse = doc['adresse'];
              final numero = doc['numero'];
              final motDePasseMD5 = doc['motDePasse'];

              return DataRow(cells: [
                DataCell(Text(nom)),
                DataCell(Text(prenom)),
                DataCell(Text(email)),
                DataCell(Text(adresse)),
                DataCell(Text(numero)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, doc, motDePasseMD5);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, doc);
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> doc) async {
    String nom = doc['nom'];
    String prenom = doc['prenom'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation de suppression"),
          content: Text("Souhaitez-vous supprimer $nom $prenom ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Non"),
            ),
            TextButton(
              onPressed: () {
                // Supprimer l'élément de la base de données
                FirebaseFirestore.instance
                    .collection('personnel')
                    .doc(doc.id)
                    .delete();
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Oui"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context,
      QueryDocumentSnapshot<Object?> doc, String motDePasseMD5) async {
    // Décode le mot de passe MD5 en texte clair
    String motDePasse = _decodeMD5(motDePasseMD5);

    // Initialiser les contrôleurs avec les données actuelles du personnel
    final TextEditingController _nomController =
        TextEditingController(text: doc['nom']);
    final TextEditingController _prenomController =
        TextEditingController(text: doc['prenom']);
    final TextEditingController _emailController =
        TextEditingController(text: doc['email']);
    final TextEditingController _adresseController =
        TextEditingController(text: doc['adresse']);
    final TextEditingController _numeroController =
        TextEditingController(text: doc['numero']);
    String _selectedRole = doc['role'];
    final TextEditingController _motDePasseController =
        TextEditingController(text: motDePasse);
    bool _isObscured = true;

    // Afficher la boîte de dialogue d'édition
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Modifier le personnel"),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(labelText: 'Nom'),
                    ),
                    TextFormField(
                      controller: _prenomController,
                      decoration: InputDecoration(labelText: 'Prénom'),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: _adresseController,
                      decoration: InputDecoration(labelText: 'Adresse'),
                    ),
                    TextFormField(
                      controller: _numeroController,
                      decoration:
                          InputDecoration(labelText: 'Numéro de téléphone'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      onChanged: (String? value) {
                        _selectedRole = value!;
                      },
                      items: ['admin', 'personnel'].map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Rôle'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _motDePasseController,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                            ),
                            obscureText: _isObscured,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                  },
                  child: Text("Annuler"),
                ),
                TextButton(
                  onPressed: () {
                    // Mettre à jour les données dans Firestore
                    String nouveauMotDePasse =
                        _motDePasseController.text.trim();
                    if (nouveauMotDePasse.isNotEmpty) {
                      String nouveauMotDePasseMD5 = md5
                          .convert(utf8.encode(nouveauMotDePasse))
                          .toString();
                      FirebaseFirestore.instance
                          .collection('personnel')
                          .doc(doc.id)
                          .update({
                        'nom': _nomController.text,
                        'prenom': _prenomController.text,
                        'email': _emailController.text,
                        'adresse': _adresseController.text,
                        'numero': _numeroController.text,
                        'role': _selectedRole,
                        'motDePasse': nouveauMotDePasseMD5,
                      }).then((value) {
                        Navigator.of(context)
                            .pop(); // Fermer la boîte de dialogue
                      }).catchError((error) {
                        print(
                            "Erreur lors de la mise à jour du personnel : $error");
                        // Afficher une boîte de dialogue d'erreur ou effectuer une autre action
                      });
                    } else {
                      // Si aucun nouveau mot de passe n'est saisi, mettre à jour les autres champs seulement
                      FirebaseFirestore.instance
                          .collection('personnel')
                          .doc(doc.id)
                          .update({
                        'nom': _nomController.text,
                        'prenom': _prenomController.text,
                        'email': _emailController.text,
                        'adresse': _adresseController.text,
                        'numero': _numeroController.text,
                        'role': _selectedRole,
                      }).then((value) {
                        Navigator.of(context)
                            .pop(); // Fermer la boîte de dialogue
                      }).catchError((error) {
                        print(
                            "Erreur lors de la mise à jour du personnel : $error");
                        // Afficher une boîte de dialogue d'erreur ou effectuer une autre action
                      });
                    }
                  },
                  child: Text("Enregistrer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _decodeMD5(String md5) {
    // Décode le mot de passe MD5 en texte clair
    String decodedPassword = utf8.decode(md5.codeUnits);
    return decodedPassword;
  }
}

void main() {
  runApp(MaterialApp(
    home: ListPersonnel(),
  ));
}
