import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPoubellesAVider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les poubelles à vider',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                  .where((doc) => doc['acces'] == 'feno')
                  .toList();

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
                  final dchtOrganique = doc['dcht_organique'];
                  final dchtChimique = doc['dcht_chimique'];

                  final organiquePourcentage = formatPercentage(
                      calculatePercentage(dchtOrganique, dchtChimique));
                  final chimiquePourcentage = formatPercentage(
                      calculatePercentage(dchtChimique, dchtOrganique));

                  return DataRow(cells: [
                    DataCell(Text(id)),
                    DataCell(Text(nom)),
                    DataCell(Text(localisation)),
                    DataCell(Text(formatNumber(poids))),
                    DataCell(Text(formatNumber(volume))),
                    DataCell(Text(formatNumber(poidsUtilise))),
                    DataCell(Text(formatNumber(volumeUtilise))),
                    DataCell(Text(organiquePourcentage)),
                    DataCell(Text(chimiquePourcentage)),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          _showViderConfirmationDialog(context, id, nom);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 16, 165, 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Vider',
                          style: TextStyle(color: Colors.white),
                        ),
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

  double calculatePercentage(int numerator, int denominator) {
    final total = numerator + denominator;
    if (total == 0) {
      return 0;
    }
    return (numerator / total) * 100;
  }

  String formatPercentage(double percentage) {
    if (percentage == percentage.toInt()) {
      return percentage.toInt().toString() + '%';
    } else {
      return percentage.toStringAsFixed(2) + '%';
    }
  }

  String formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(2);
    }
  }

  void _showViderConfirmationDialog(
      BuildContext context, String id, String nom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de vidage'),
          content: Text('Souhaitez-vous vider la poubelle "$nom" ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                _viderPoubelle(id, nom);
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _viderPoubelle(String id, String nom) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('poubelles')
        .where('nom', isEqualTo: nom)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final poubelleDoc = querySnapshot.docs.first;
      await poubelleDoc.reference.update({
        'dcht_chimique': 0,
        'dcht_organique': 0,
        'acces': 'pokaty',
        'volume_utilise': 0,
        'poids_utilise': 0,
      });
    } else {
      print('Poubelle introuvable');
    }
  }
}
