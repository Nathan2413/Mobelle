import 'package:flutter/material.dart';

class ModifierPersonnelPage extends StatelessWidget {
  final String id; // Ajouter l'ID comme paramètre
  final String nom;
  final String prenom;
  final String email;
  final String adresse;
  final String role;
  final String motDePasse;
  final String numero;

  const ModifierPersonnelPage({
    required this.id, // Rendre l'ID requis
    required this.nom,
    required this.prenom,
    required this.email,
    required this.adresse,
    required this.role,
    required this.motDePasse,
    required this.numero,
  });

  @override
  Widget build(BuildContext context) {
    // Utilisez les données reçues pour afficher le formulaire de modification
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Personnel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom: $nom'),
            Text('Prénom: $prenom'),
            Text('Email: $email'),
            Text('Adresse: $adresse'),
            Text('Role: $role'),
            Text('Mot de passe: $motDePasse'),
            Text('Numéro: $numero'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton "Modifier"
                // Ajoutez ici la logique pour modifier les données du personnel
              },
              child: Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Revenir en arrière
              },
              child: Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
