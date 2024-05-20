import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPoubelles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les listes des poubelles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildPoubelleList(context),
    );
  }

  Widget _buildPoubelleList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('poubelles')
                .orderBy('id')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final poubelles = snapshot.data!.docs;

              return DataTable(
                horizontalMargin: 20,
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Localisation')),
                  DataColumn(label: Text('Poids (kg)')),
                  DataColumn(label: Text('Volume (m³)')),
                  DataColumn(label: Text('Poids utilisé')),
                  DataColumn(label: Text('Volume utilisé')),
                  DataColumn(label: Text('Organiques')),
                  DataColumn(label: Text('Chimiques')),
                  DataColumn(label: Text('Action')),
                ],
                rows: poubelles.map((doc) {
                  final id = doc['id'];
                  final nom = doc['nom'];
                  final localisation = doc['localisation'];
                  final poids = doc['poids'];
                  final volume = doc['volume'];
                  final poidsUtilise = doc['poids_utilise'];
                  final volumeUtilise = doc['volume_utilise'];

                  return DataRow(cells: [
                    DataCell(Text(id)),
                    DataCell(Text(nom)),
                    DataCell(Text(localisation)),
                    DataCell(Text(poids.toString())),
                    DataCell(Text(volume.toString())),
                    DataCell(Text(poidsUtilise.toString())),
                    DataCell(Text(volumeUtilise.toString())),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, id, nom);
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String id, String nom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de suppression'),
          content: Text('Souhaitez-vous supprimer la poubelle "$nom" ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                _deletePoubelle(nom);
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePoubelle(String nom) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('poubelles')
        .where('nom', isEqualTo: nom)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final poubelleDoc = querySnapshot.docs.first;
      await poubelleDoc.reference.delete();
    } else {
      print('Poubelle introuvable');
    }
  }
}
