import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjoutPoubellePage extends StatefulWidget {
  const AjoutPoubellePage({Key? key}) : super(key: key);

  @override
  _AjoutPoubellePageState createState() => _AjoutPoubellePageState();
}

class _AjoutPoubellePageState extends State<AjoutPoubellePage> {
  static const List<String> localisations = [
    'Chambre 1',
    'Chambre 2',
    'Bureau',
    'Cuisine',
    'Garage',
    'Terrasse',
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _volumeController =
      TextEditingController(); // Renommer en volume
  String? _selectedLocalisation;

  Future<int> _getNextCounter() async {
    final QuerySnapshot<Map<String, dynamic>> poubelles =
        await FirebaseFirestore.instance.collection('poubelles').get();
    return poubelles.size + 1;
  }

  void _ajouterPoubelle() async {
    if (_formKey.currentState!.validate()) {
      int _counter = await _getNextCounter();
      String id = 'mob${_counter.toString().padLeft(3, '0')}';

      FirebaseFirestore.instance.collection('poubelles').add({
        'id': id,
        'nom': _nomController.text,
        'poids': double.parse(_poidsController.text),
        'volume': double.parse(_volumeController.text),
        'poids_utilise': 0,
        'volume_utilise': 0,
        'localisation': _selectedLocalisation,
        'dechets': '', // Champ de déchets vide par défaut
        'acces': 'pokaty', // Par défaut, l'accès est "pokaty"
      }).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Poubelle ajoutée avec succès.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    _nomController.clear();
                    _poidsController.clear();
                    _volumeController.clear();
                    _selectedLocalisation = null;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(
                  'Une erreur s\'est produite lors de l\'ajout de la poubelle.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _poidsController.dispose();
    _volumeController.dispose(); // Disposer le contrôleur de volume
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ajouter des poubelles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nom de la poubelle',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                          color: Colors.grey[700],
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer le nom de la poubelle';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _poidsController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Poids maximum (en kg)',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: Icon(
                          Icons.line_weight,
                          color: Colors.grey[700],
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer le poids maximum de la poubelle';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller:
                          _volumeController, // Utiliser le contrôleur de volume
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Volume (en m³)', // Modifier en volume
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: Icon(
                          Icons.volume_up, // Changer l'icône en icône de volume
                          color: Colors.grey[700],
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer le volume de la poubelle';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedLocalisation,
                      decoration: InputDecoration(
                        labelText: 'Localisation',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.grey[700],
                        ),
                      ),
                      items: localisations.map((String localisation) {
                        return DropdownMenuItem<String>(
                          value: localisation,
                          child: Text(localisation),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedLocalisation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une localisation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _ajouterPoubelle,
                      child: Text('Ajouter'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
