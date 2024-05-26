import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PListePoubelles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des poubelles',
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
              _buildPoubelleList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoubelleList(BuildContext context) {
    double tableWidth =
        MediaQuery.of(context).size.width * 0.9; // 90% de la largeur de l'écran

    return StreamBuilder<QuerySnapshot>(
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

        final poubelles =
            snapshot.data!.docs.where((doc) => doc['acces'] != 'feno').toList();

        return SizedBox(
          width: tableWidth,
          child: DataTable(
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
                DataCell(Text(id)),
                DataCell(Text(nom)),
                DataCell(Text(localisation)),
                DataCell(Text(formatNumber(poids))),
                DataCell(Text(formatNumber(volume))),
                DataCell(Text(formatNumber(poidsUtilise))),
                DataCell(Text(formatNumber(volumeUtilise))),
                DataCell(Text(organiquePourcentage)),
                DataCell(Text(chimiquePourcentage)),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  String calculatePercentage(int numerator, int denominator) {
    final total = numerator + denominator;
    if (total == 0) {
      return '0%';
    }
    final percentage = (numerator / total) * 100;
    return percentage == percentage.toInt()
        ? percentage.toInt().toString() + '%'
        : percentage.toStringAsFixed(2) + '%';
  }

  String formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(2);
    }
  }
}
