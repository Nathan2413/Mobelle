import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashPage extends StatelessWidget {
  Future<int> getCount(String collection,
      {String? field, String? isEqualTo}) async {
    Query query = FirebaseFirestore.instance.collection(collection);
    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Tableau de bord',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: <Widget>[
              buildStatCard(
                  'Personnel', 'personnel', 'role', 'personnel', Icons.person),
              buildStatCard('Poubelles pokaty', 'poubelles', 'acces', 'pokaty',
                  Icons.delete),
              buildStatCard('Poubelles à vider', 'poubelles', 'acces', 'feno',
                  Icons.delete_sweep),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String collection, String field,
      String value, IconData icon) {
    return FutureBuilder<int>(
      future: getCount(collection, field: field, isEqualTo: value),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Card(
            child: Center(child: Text('Erreur')),
          );
        } else {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
