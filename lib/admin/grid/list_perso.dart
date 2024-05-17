import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPersonnel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les listes des personnels',
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
              DataColumn(label: Text('Action')),
            ],
            rows: personnel.map((doc) {
              final nom = doc['nom'];
              final prenom = doc['prenom'];
              final email = doc['email'];
              final adresse = doc['adresse'];
              final numero = doc['numero'];

              return DataRow(cells: [
                DataCell(Text(nom)),
                DataCell(Text(prenom)),
                DataCell(Text(email)),
                DataCell(Text(adresse)),
                DataCell(Text(numero)),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, doc);
                    },
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
}
