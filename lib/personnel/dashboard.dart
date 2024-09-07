import 'package:flutter/material.dart';
import '../login.dart';
import '../carte.dart'; // Importer la page carte.dart
import 'p_grid/p_list_pou.dart'; // Importer la page p_list_pou.dart
import 'p_grid/p_dash.dart'; // Importer la page p_dash.dart
import 'p_grid/p_dcht_vide.dart'; // Importer la page p_dcht_vide.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PDashboard extends StatefulWidget {
  const PDashboard({Key? key}) : super(key: key);

  @override
  _PDashboardState createState() => _PDashboardState();
}

class _PDashboardState extends State<PDashboard> {
  Widget _currentWidget =
      SizedBox(); // Widget actuel à afficher dans le côté droit
  int _poubellesAViderCount = 0; // Compteur des poubelles à vider

  @override
  void initState() {
    super.initState();
    _currentWidget = TabDashboard(); // Initialiser avec p_dash.dart
    _listenToPoubellesAVider(); // Écouter les changements pour les poubelles à vider
  }

  void _listenToPoubellesAVider() {
    // Écouter les changements du nombre de poubelles à vider
    getCountStream('poubelles', field: 'acces', isEqualTo: 'feno')
        .listen((count) {
      setState(() {
        _poubellesAViderCount = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // En-tête avec ombre en bas
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Titre du projet "Mo Belle" avec un padding à gauche
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Mo Belle',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 93, 233, 98),
                      shadows: [
                        Shadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                // Texte "Personnel"
                Text(
                  'Personnel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                // Icône de déconnexion
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Ombre gris-noir
          Container(
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Grid à gauche
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ListTile(
                          leading: Icon(Icons.dashboard),
                          title: Text(
                            'Tableau de bord',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          onTap: () {
                            // Action lorsque "Tableau de bord" est tapé
                            setState(() {
                              _currentWidget =
                                  TabDashboard(); // Afficher p_dash.dart
                            });
                          },
                        ),
                        ExpansionTile(
                          leading: Icon(Icons.delete),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Poubelles',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      15), // Espacement fixe entre le texte et le nombre
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _getPoubellesAViderColor(), // Couleur du cercle en fonction du nombre
                                ),
                              ),
                            ],
                          ),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            StreamBuilder<int>(
                              stream: getCountStream('poubelles',
                                  field: 'acces', isEqualTo: 'pokaty'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.list),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Tous les poubelles',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                15), // Espacement fixe entre le texte et le nombre
                                        CircularProgressIndicator(), // Indicateur de chargement
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.list),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Tous les poubelles',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                15), // Espacement fixe entre le texte et le nombre
                                        Text(
                                          'Erreur',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.list),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Tous les poubelles',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                35), // Espacement fixe entre le texte et le nombre
                                        Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // Action lorsque "Tous les poubelles" est tapé
                                      setState(() {
                                        _currentWidget =
                                            PListePoubelles(); // Afficher PListePoubelles
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                            StreamBuilder<int>(
                              stream: getCountStream('poubelles',
                                  field: 'acces', isEqualTo: 'feno'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.delete_sweep),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Les poubelles à vider',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                15), // Espacement fixe entre le texte et le nombre
                                        CircularProgressIndicator(), // Indicateur de chargement
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.delete_sweep),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Les poubelles à vider',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                15), // Espacement fixe entre le texte et le nombre
                                        Text(
                                          'Erreur',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    contentPadding: EdgeInsets.only(left: 40),
                                    leading: Icon(Icons.delete_sweep),
                                    title: Row(
                                      children: [
                                        Text(
                                          'Les poubelles à vider',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                15), // Espacement fixe entre le texte et le nombre
                                        Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                            color: Colors
                                                .green, // Chiffres toujours en vert
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // Action lorsque "Les poubelles à vider" est tapé
                                      setState(() {
                                        _currentWidget =
                                            ListPoubellesAVider(); // Afficher ListPoubellesAVider
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          leading: Icon(Icons.map),
                          title: Text(
                            'La carte',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          onTap: () {
                            // Action lorsque "La carte" est tapée
                            setState(() {
                              _currentWidget =
                                  Carte(); // Afficher la page carte.dart
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Grid à droite
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: _currentWidget, // Afficher le widget actuel
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<int> getCountStream(String collection,
      {String? field, String? isEqualTo}) {
    Query query = FirebaseFirestore.instance.collection(collection);
    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    return query.snapshots().map((snapshot) => snapshot.docs.length);
  }

  Color _getPoubellesAViderColor() {
    return _poubellesAViderCount > 0 ? Colors.red : Colors.green;
  }
}
