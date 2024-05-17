import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FakoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Les poubelles disponibles',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: PoubellesList(), // Affiche la liste des poubelles
            ),
          ],
        ),
      ),
    );
  }
}

class PoubellesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('poubelles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text('Aucune poubelle disponible.');
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String nom = data['nom'];
            String localisation = data['localisation'];
            return PoubelleCard(
              nom: nom,
              localisation: localisation,
            );
          }).toList(),
        );
      },
    );
  }
}

class PoubelleCard extends StatelessWidget {
  final String nom;
  final String localisation;

  PoubelleCard({required this.nom, required this.localisation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.grey[300], // Utilisation d'une teinte de gris neutre
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.asset(
              'images/bg.png',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.title, color: Colors.blue),
                      SizedBox(width: 5.0),
                      Text(
                        nom,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Color.fromARGB(255, 240, 31, 28)),
                      SizedBox(width: 5.0),
                      Text(
                        localisation,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            255, 16, 165, 8), // Couleur de fond du bouton
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordure arrondie
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Action à effectuer lorsque le bouton est pressé
                        },
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white, // Couleur du texte du bouton
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
