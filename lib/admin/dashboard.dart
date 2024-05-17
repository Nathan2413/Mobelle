import 'package:flutter/material.dart';
import '../login.dart';
import 'grid/ajou_belle.dart'; // Importer la page ajou_belle.dart
import '../carte.dart'; // Importer la page carte.dart
import 'grid/ajou_per.dart';
import 'grid/list_perso.dart';
import 'grid/list_pou.dart';
import 'grid/ajou_dcht.dart'; // Importer la page ajou_dcht.dart
import 'grid/list_dcht.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _currentWidget =
      SizedBox(); // Widget actuel à afficher dans le côté droit

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
                // Texte "Administrateur"
                Text(
                  'Administrateur',
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
                        Container(
                          color: Color.fromARGB(255, 93, 233, 98),
                          child: ListTile(
                            leading: Icon(Icons.dashboard),
                            title: Text(
                              'Tableau de bord',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ExpansionTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            'Personnel',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.add),
                              title: Text(
                                'Ajouter du personnel',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Ajouter du personnel" est tapé
                                setState(() {
                                  _currentWidget =
                                      AjouterPersonnelPage(); // Afficher la page ajout_personnel.dart
                                });
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.list),
                              title: Text(
                                'Liste des personnels',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Liste des personnels" est tapé
                                setState(() {
                                  _currentWidget =
                                      ListPersonnel(); // Afficher la page liste_personnels.dart
                                });
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: Icon(Icons.delete),
                          title: Text(
                            'Poubelle',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.add),
                              title: Text(
                                'Ajouter des poubelles',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Ajouter des poubelles" est tapé
                                setState(() {
                                  _currentWidget =
                                      AjoutPoubellePage(); // Afficher la page ajout_belle.dart
                                });
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.list),
                              title: Text(
                                'Tous les poubelles',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Tous les poubelles" est tapé
                                setState(() {
                                  _currentWidget =
                                      ListPoubelles(); // Afficher la page ajout_belle.dart
                                });
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: Icon(Icons.delete),
                          title: Text(
                            'Déchets',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.add),
                              title: Text(
                                'Ajouter un déchet',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Ajouter un déchet" est tapé
                                setState(() {
                                  _currentWidget =
                                      AjouterDechetPage(); // Afficher la page ajou_dcht.dart
                                });
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.list),
                              title: Text(
                                'Tous les déchets',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Action lorsque "Ajouter un déchet" est tapé
                                setState(() {
                                  _currentWidget =
                                      ListDechets(); // Afficher la page ajou_dcht.dart
                                });
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          leading: Icon(Icons.map),
                          title: Text(
                            'La carte',
                            style: TextStyle(
                              fontSize: 20,
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
                    child:
                        _currentWidget, // Afficher le widget actuel (vide ou la page ajout_belle.dart ou la page carte.dart)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
