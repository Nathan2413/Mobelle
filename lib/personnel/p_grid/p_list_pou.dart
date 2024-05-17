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

        final poubelles = snapshot.data!.docs;

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
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
