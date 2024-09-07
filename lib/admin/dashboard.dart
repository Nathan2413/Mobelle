import 'package:flutter/material.dart';
import '../login.dart';
import 'grid/ajou_belle.dart';
import '../carte.dart';
import 'grid/ajou_per.dart';
import 'grid/list_perso.dart';
import 'grid/list_pou.dart';
import 'grid/ajou_dcht.dart';
import 'grid/list_dcht.dart';
import 'grid/dcht_vide.dart';
import 'grid/dash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _currentWidget = DashPage();

  Stream<int> _getPoubellesCount(String acces) {
    return FirebaseFirestore.instance
        .collection('poubelles')
        .where('acces', isEqualTo: acces)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> _getPersonnelCount() {
    return FirebaseFirestore.instance
        .collection('personnel')
        .where('role', isEqualTo: 'personnel')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                Text(
                  'Administrateur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
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
                            setState(() {
                              _currentWidget = DashPage();
                            });
                          },
                        ),
                        StreamBuilder<int>(
                          stream: _getPersonnelCount(),
                          builder: (context, snapshot) {
                            final countPersonnel = snapshot.data ?? 0;
                            return ExpansionTile(
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
                                    setState(() {
                                      _currentWidget = AjouterPersonnelPage();
                                    });
                                  },
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 40),
                                  leading: Icon(Icons.list),
                                  title: Row(
                                    children: [
                                      Text(
                                        'Liste des personnels',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        '$countPersonnel',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _currentWidget = ListPersonnel();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        StreamBuilder<int>(
                          stream: _getPoubellesCount('feno'),
                          builder: (context, snapshotFeno) {
                            final countFeno = snapshotFeno.data ?? 0;
                            return ExpansionTile(
                              leading: Icon(Icons.delete),
                              title: Row(
                                children: [
                                  Text(
                                    'Poubelle',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 6,
                                    backgroundColor: countFeno > 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ],
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
                                    setState(() {
                                      _currentWidget = AjoutPoubellePage();
                                    });
                                  },
                                ),
                                StreamBuilder<int>(
                                  stream: _getPoubellesCount('pokaty'),
                                  builder: (context, snapshotPokaty) {
                                    final countPokaty =
                                        snapshotPokaty.data ?? 0;
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
                                          SizedBox(width: 15),
                                          Text(
                                            '$countPokaty',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _currentWidget = ListPoubelles();
                                        });
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 40),
                                  leading: Icon(Icons.delete_sweep),
                                  title: Row(
                                    children: [
                                      Text(
                                        'Poubelles à vider',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(width: 28),
                                      Text(
                                        '$countFeno',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _currentWidget = ListPoubellesAVider();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
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
                                setState(() {
                                  _currentWidget = AjouterDechetPage();
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
                                setState(() {
                                  _currentWidget = ListDechets();
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
                            setState(() {
                              _currentWidget = Carte();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: _currentWidget,
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
