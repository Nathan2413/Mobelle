import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'u_dashboard.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    Key? key,
    required this.id,
    required this.nom,
    required this.localisation,
  }) : super(key: key);

  final String id;
  final String nom;
  final String localisation;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final List<DocumentSnapshot> selectedDocuments = [];

  void _updateSelection(DocumentSnapshot document, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedDocuments.add(document);
      } else {
        selectedDocuments.remove(document);
      }
    });
  }

  Future<void> _updatePoubelle(BuildContext context) async {
    int organiqueCount = 0;
    int chimiqueCount = 0;
    double totalMasse = 0;
    double totalVolume = 0;

    for (var document in selectedDocuments) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      totalMasse += data['masse'].toDouble();
      totalVolume += data['volume'].toDouble();
      if (data['type'] == 'Organique') {
        organiqueCount++;
      } else if (data['type'] == 'Chimique') {
        chimiqueCount++;
      }
    }

    try {
      QuerySnapshot poubelleQuery = await FirebaseFirestore.instance
          .collection('poubelles')
          .where('nom', isEqualTo: widget.nom)
          .limit(1)
          .get();

      if (poubelleQuery.docs.isNotEmpty) {
        DocumentReference poubelleRef = poubelleQuery.docs.first.reference;
        Map<String, dynamic> poubelleData =
            poubelleQuery.docs.first.data() as Map<String, dynamic>;

        double newPoidsUtilise =
            (poubelleData['poids_utilise'] as num).toDouble() + totalMasse;
        double newVolumeUtilise =
            (poubelleData['volume_utilise'] as num).toDouble() + totalVolume;

        // Formater les valeurs avec deux chiffres après la virgule
        newPoidsUtilise = double.parse(newPoidsUtilise.toStringAsFixed(2));
        newVolumeUtilise = double.parse(newVolumeUtilise.toStringAsFixed(2));

        double poids = (poubelleData['poids'] as num).toDouble();
        double volume = (poubelleData['volume'] as num).toDouble();

        int currentOrganiqueCount = poubelleData['dcht_organique'] as int;
        int currentChimiqueCount = poubelleData['dcht_chimique'] as int;

        if (newPoidsUtilise > poids || newVolumeUtilise > volume) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Veuillez enlever quelques déchets car la poubelle est déjà remplie.'),
          ));
        } else {
          Map<String, dynamic> updateData = {
            'poids_utilise': newPoidsUtilise,
            'volume_utilise': newVolumeUtilise,
            'dcht_organique': currentOrganiqueCount + organiqueCount,
            'dcht_chimique': currentChimiqueCount + chimiqueCount,
          };

          if (newPoidsUtilise > 0.97 * poids ||
              newVolumeUtilise >= 0.97 * volume) {
            updateData['acces'] = 'feno';
          }

          await poubelleRef.update(updateData);

          if (updateData['acces'] == 'feno') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UDashboard()),
            );
          } else {
            Navigator.of(context).pop(); // Fermer l'alerte après la mise à jour
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Le document poubelle avec le nom ${widget.nom} n\'existe pas.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la mise à jour: $e'),
      ));
    }
  }

  String formatPercentage(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  void _showLocalisationImage(BuildContext context, String localisation) {
    String imagePath = 'images/map/';

    // Assigner le chemin d'image en fonction de la localisation
    switch (localisation) {
      case 'Parkings':
        imagePath += 'parking.png';
        break;
      case 'Restaurant':
        imagePath += 'restaurant.png';
        break;
      case 'Manèges':
        imagePath += 'manege.png';
        break;
      case 'Toboggan':
        imagePath += 'toboggan.png';
        break;
      case 'Etang':
        imagePath += 'etang.png';
        break;
      case 'Cirque':
        imagePath += 'cirque.png';
        break;
      default:
        imagePath += 'carte.png'; // Chemin vers une image par défaut
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
                backgroundDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 165, 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        elevation: 4,
        title: Center(
          child: Text(
            'Mo Belle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UDashboard(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Détails',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.grey[300],
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'images/bg.png',
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('poubelles')
                                  .where('nom', isEqualTo: widget.nom)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Erreur: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (snapshot.data!.docs.isEmpty) {
                                  return Text('Aucune poubelle disponible.');
                                }

                                var poubelle = snapshot.data!.docs.first;
                                Map<String, dynamic> data =
                                    poubelle.data() as Map<String, dynamic>;
                                String id = data['id'];
                                double poids =
                                    (data['poids'] as num).toDouble();
                                double volume =
                                    (data['volume'] as num).toDouble();
                                double poidsUtilise =
                                    (data['poids_utilise'] as num).toDouble();
                                double volumeUtilise =
                                    (data['volume_utilise'] as num).toDouble();

                                double poidsPourcentage =
                                    (poidsUtilise / poids) * 100;
                                double volumePourcentage =
                                    (volumeUtilise / volume) * 100;

                                String poidsPourcentageStr =
                                    formatPercentage(poidsPourcentage);

                                String volumePourcentageStr =
                                    formatPercentage(volumePourcentage);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.blue),
                                        SizedBox(width: 10),
                                        Text('$id',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: Colors.green),
                                        SizedBox(width: 10),
                                        Text('${widget.nom}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () => _showLocalisationImage(
                                          context, widget.localisation),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: Colors.red),
                                          SizedBox(width: 10),
                                          Text('${widget.localisation}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.line_weight,
                                            color: Colors.orange),
                                        SizedBox(width: 10),
                                        Text('$poids kg',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.format_size,
                                            color: Colors.purple),
                                        SizedBox(width: 10),
                                        Text('$volume m³',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Spécifique',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Poids',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 10),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('poubelles')
                                    .where('nom', isEqualTo: widget.nom)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Erreur');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }

                                  if (snapshot.data!.docs.isEmpty) {
                                    return Text('N/A');
                                  }

                                  var poubelle = snapshot.data!.docs.first;
                                  Map<String, dynamic> data =
                                      poubelle.data() as Map<String, dynamic>;
                                  double poids =
                                      (data['poids'] as num).toDouble();
                                  double poidsUtilise =
                                      (data['poids_utilise'] as num).toDouble();

                                  double poidsPourcentage =
                                      (poidsUtilise / poids) * 100;

                                  String poidsPourcentageStr =
                                      formatPercentage(poidsPourcentage);

                                  return Text(
                                    '$poidsPourcentageStr %',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Volume',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 10),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('poubelles')
                                    .where('nom', isEqualTo: widget.nom)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Erreur');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }

                                  if (snapshot.data!.docs.isEmpty) {
                                    return Text('N/A');
                                  }

                                  var poubelle = snapshot.data!.docs.first;
                                  Map<String, dynamic> data =
                                      poubelle.data() as Map<String, dynamic>;
                                  double volume =
                                      (data['volume'] as num).toDouble();
                                  double volumeUtilise =
                                      (data['volume_utilise'] as num)
                                          .toDouble();

                                  double volumePourcentage =
                                      (volumeUtilise / volume) * 100;

                                  String volumePourcentageStr =
                                      formatPercentage(volumePourcentage);

                                  return Text(
                                    '$volumePourcentageStr %',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showDechetsAlert(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 16, 165, 8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Voir les déchets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDechetsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déchets'),
          content: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('dechets').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<Widget> images =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                return _SelectableImage(
                  document: document,
                  onSelected: (bool isSelected) {
                    _updateSelection(document, isSelected);
                  },
                );
              }).toList();

              return SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: images,
                ),
              );
            },
          ),
          actions: <Widget>[
            Container(
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _updatePoubelle(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightGreenAccent),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Bordure de 10%
                      ),
                    ),
                  ),
                  child: Text(
                    'Mise à jour',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SelectableImage extends StatefulWidget {
  final DocumentSnapshot document;
  final ValueChanged<bool> onSelected;

  const _SelectableImage({
    required this.document,
    required this.onSelected,
  });

  @override
  __SelectableImageState createState() => __SelectableImageState();
}

class __SelectableImageState extends State<_SelectableImage> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.document.data() as Map<String, dynamic>;
    String imageName = data['image']; // Changer selon votre base de données
    String imageUrl = 'images/$imageName';
    double masse = (data['masse'] as num).toDouble(); // Convertir en double
    double volume = (data['volume'] as num).toDouble(); // Convertir en double
    String type = data['type'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onSelected(_isSelected);
        });
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isSelected ? Colors.lightGreenAccent : Colors.transparent,
        ),
        child: Column(
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 80,
              fit: BoxFit.contain,
            ),
            Text(
              'Masse: $masse kg\nVolume: $volume m³\nType: $type',
              style: TextStyle(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DetailsPage(
      id: 'id',
      nom: 'nom',
      localisation: 'localisation',
    ),
  ));
}
