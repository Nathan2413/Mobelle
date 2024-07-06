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

              final poubelles = snapshot.data!.docs
                  .where((doc) => doc['acces'] != 'feno')
                  .toList();

              return DataTable(
                horizontalMargin: 20,
                columns: [
                  DataColumn(
                    label: Center(child: Text('ID')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Nom')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Localisation')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Poids (kg)')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Volume (m³)')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Poids utilisé')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Volume utilisé')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Organiques')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Chimiques')),
                  ),
                  DataColumn(
                    label: Center(child: Text('Action')),
                  ),
                ],
                rows: poubelles.map((doc) {
                  final id = doc['id'];
                  final nom = doc['nom'];
                  final localisation = doc['localisation'];
                  final poids = doc['poids'];
                  final volume = doc['volume'];
                  final poidsUtilise = doc['poids_utilise'];
                  final volumeUtilise = doc['volume_utilise'];
                  final dchtOrganique = doc['dcht_organique'];
                  final dchtChimique = doc['dcht_chimique'];

                  final organiquePourcentage =
                      calculatePercentage(dchtOrganique, dchtChimique);
                  final chimiquePourcentage =
                      calculatePercentage(dchtChimique, dchtOrganique);

                  return DataRow(cells: [
                    DataCell(Text(id.toString())),
                    DataCell(Text(nom)),
                    DataCell(Text(localisation)),
                    DataCell(Text(formatNumber(poids))),
                    DataCell(Text(formatNumber(volume))),
                    DataCell(Text(formatNumber(poidsUtilise))),
                    DataCell(Text(formatNumber(volumeUtilise))),
                    DataCell(Text(organiquePourcentage)),
                    DataCell(Text(chimiquePourcentage)),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editPoubelle(
                                context,
                                id.toString(),
                                nom,
                                poids.toDouble(),
                                volume.toDouble(),
                                localisation,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                  context, id.toString(), nom);
                            },
                          ),
                        ],
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

  String calculatePercentage(int numerator, int denominator) {
    final total = numerator + denominator;
    if (total == 0) {
      return '0%';
    }
    final percentage = (numerator / total) * 100;
    return '${percentage.toStringAsFixed(2)}%';
  }

  String formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(2);
    }
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

  void _editPoubelle(BuildContext context, String id, String currentNom,
      double currentPoids, double currentVolume, String currentLocalisation) {
    _showEditDialog(context, id, currentNom, currentPoids, currentVolume,
        currentLocalisation);
  }

  void _showEditDialog(BuildContext context, String id, String currentNom,
      double currentPoids, double currentVolume, String currentLocalisation) {
    // Liste des options de localisation
    List<String> locations = [
      'Parkings',
      'Manèges',
      'Toboggan',
      'Restaurant',
      'Etang',
      'Cirque',
    ];

    // Initialiser le controller pour le champ Nom
    TextEditingController nomController =
        TextEditingController(text: currentNom);
    // Initialiser le controller pour le champ Poids
    TextEditingController poidsController =
        TextEditingController(text: currentPoids.toString());
    // Initialiser le controller pour le champ Volume
    TextEditingController volumeController =
        TextEditingController(text: currentVolume.toString());
    // Initialiser la valeur sélectionnée pour le champ Localisation
    String dropdownValue = currentLocalisation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la poubelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom de la poubelle'),
              ),
              TextFormField(
                controller: poidsController,
                decoration: InputDecoration(labelText: 'Poids maximum'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'Volume'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: InputDecoration(labelText: 'Localisation'),
                onChanged: (String? newValue) {
                  dropdownValue = newValue!;
                },
                items: locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _updatePoubelle(
                    id,
                    nomController.text,
                    double.parse(poidsController.text),
                    double.parse(volumeController.text),
                    dropdownValue);
                Navigator.of(context).pop();
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePoubelle(String id, String nom, double poidsMax,
      double volume, String localisation) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('poubelles')
        .where('id', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final poubelleDoc = querySnapshot.docs.first;
      await poubelleDoc.reference.update({
        'nom': nom,
        'poids': poidsMax,
        'volume': volume,
        'localisation': localisation,
      });
    } else {
      print('Poubelle introuvable');
    }
  }
}

class EditPoubelleScreen extends StatelessWidget {
  final String id;

  const EditPoubelleScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    // Implémentez ici l'interface utilisateur pour l'édition de la poubelle
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la poubelle'),
      ),
      body: Center(
        child: Text('Édition de la poubelle avec ID: $id'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Gestion des poubelles',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: ListPoubelles(),
  ));
}
