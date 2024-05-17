import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListDechets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les listes des déchets',
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
              _buildDechetsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDechetsList(BuildContext context) {
    double tableWidth =
        MediaQuery.of(context).size.width * 0.9; // 90% de la largeur de l'écran

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('dechets')
          .orderBy('id_dechet')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final dechets = snapshot.data!.docs;

        return SizedBox(
          width: tableWidth,
          child: DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(
                label: SizedBox(
                  width: 150, // Largeur de la colonne Image
                  child: Text('Images'),
                ),
              ),
              DataColumn(label: Text('Nom')),
              DataColumn(label: Text('Masse')),
              DataColumn(label: Text('Volume')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Action')),
            ],
            rows: dechets.map((doc) {
              final id = doc['id_dechet'];
              final nom = doc['nom'];
              final masse = doc['masse'];
              final volume = doc['volume'];
              final type = doc['type'];
              final imageUrl =
                  'images/${doc['image']}'; // Chemin de l'image dans votre base de données

              return DataRow(
                cells: [
                  DataCell(Text(id.toString())),
                  DataCell(
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        imageUrl,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  DataCell(Text(nom)),
                  DataCell(Text(masse.toString())),
                  DataCell(Text(volume.toString())),
                  DataCell(Text(type)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Afficher une boîte de dialogue de confirmation avant la suppression
                        _showDeleteConfirmationDialog(
                            context, id.toString(), nom);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String id, String nom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de suppression'),
          content: Text('Souhaitez-vous supprimer le déchet "$nom" ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Annuler la suppression et fermer la boîte de dialogue
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                // Supprimer l'élément de la base de données et fermer la boîte de dialogue
                _deleteDechet(nom);
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDechet(String nom) async {
    try {
      // Rechercher le déchet par son nom
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dechets')
          .where('nom', isEqualTo: nom)
          .get();

      // Vérifier si un document correspondant au nom est trouvé
      if (querySnapshot.docs.isNotEmpty) {
        // Supprimer le premier document trouvé avec le nom spécifié
        final dechetDoc = querySnapshot.docs.first;
        await dechetDoc.reference.delete();
        print('Déchet supprimé avec succès');
        // Afficher une alerte ou un message de confirmation de suppression
      } else {
        // Si aucun document n'est trouvé avec ce nom
        print('Déchet introuvable');
        // Afficher une alerte ou un message indiquant que le déchet n'a pas été trouvé
      }
    } catch (error) {
      print('Erreur lors de la suppression du déchet: $error');
      // Gérer les erreurs éventuelles lors de la suppression
    }
  }
}
