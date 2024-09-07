import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashPage extends StatelessWidget {
  Stream<Map<String, double>> getDechetStatistics(String role) {
    return FirebaseFirestore.instance
        .collection('poubelles')
        .where('acces', isEqualTo: role)
        .snapshots()
        .map((querySnapshot) {
      int totalOrganique = 0;
      int totalChimique = 0;

      for (var doc in querySnapshot.docs) {
        totalOrganique += (doc['dcht_organique'] ?? 0) as int;
        totalChimique += (doc['dcht_chimique'] ?? 0) as int;
      }

      double totalDechets =
          totalOrganique.toDouble() + totalChimique.toDouble();
      double pourcentageOrganique = totalDechets > 0
          ? (totalOrganique.toDouble() / totalDechets) * 100
          : 0;
      double pourcentageChimique = totalDechets > 0
          ? (totalChimique.toDouble() / totalDechets) * 100
          : 0;

      return {
        'Organique': pourcentageOrganique,
        'Chimique': pourcentageChimique,
      };
    });
  }

  Stream<int> getCount(String collection, {String? field, String? isEqualTo}) {
    Query query = FirebaseFirestore.instance.collection(collection);
    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    return query.snapshots().map((snapshot) => snapshot.docs.length);
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
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: <Widget>[
              buildPieChartWithCenterText('Poubelles pokaty', 'pokaty'),
              buildPieChartWithCenterText('Poubelles à vider', 'feno'),
              buildStatCard(
                  'Personnel', 'personnel', 'role', 'personnel', Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String collection, String field,
      String value, IconData icon) {
    return StreamBuilder<int>(
      stream: getCount(collection, field: field, isEqualTo: value),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
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

  Widget buildPieChartWithCenterText(String title, String role) {
    return StreamBuilder<int>(
      stream: getCount('poubelles', field: 'acces', isEqualTo: role),
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
          return StreamBuilder<Map<String, double>>(
            stream: getDechetStatistics(role),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, double>> dechetSnapshot) {
              if (dechetSnapshot.connectionState == ConnectionState.waiting) {
                return Card(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (dechetSnapshot.hasError) {
                return Card(
                  child: Center(child: Text('Erreur: ${dechetSnapshot.error}')),
                );
              } else {
                var data = dechetSnapshot.data!;
                bool isEmpty = snapshot.data == 0;
                return Card(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sections: isEmpty
                                    ? [
                                        PieChartSectionData(
                                          value: 1,
                                          title: '',
                                          color: Colors.grey,
                                          radius: 150,
                                        )
                                      ]
                                    : [
                                        PieChartSectionData(
                                          value: data['Organique'] ?? 0,
                                          title:
                                              '${data['Organique']!.toStringAsFixed(2)}%',
                                          color: Colors.green,
                                          radius: 150,
                                          titleStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        PieChartSectionData(
                                          value: data['Chimique'] ?? 0,
                                          title:
                                              '${data['Chimique']!.toStringAsFixed(2)}%',
                                          color: Colors.red,
                                          radius: 150,
                                          titleStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                            Center(
                              child: Text(
                                snapshot.data.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      if (!isEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Indicator(
                              color: Colors.green,
                              text: 'Organique',
                              isSquare: true,
                            ),
                            SizedBox(width: 16),
                            Indicator(
                              color: Colors.red,
                              text: 'Chimique',
                              isSquare: true,
                            ),
                          ],
                        ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
