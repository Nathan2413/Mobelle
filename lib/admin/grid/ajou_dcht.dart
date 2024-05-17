import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjouterDechetPage extends StatefulWidget {
  const AjouterDechetPage({Key? key}) : super(key: key);

  @override
  _AjouterDechetPageState createState() => _AjouterDechetPageState();
}

class _AjouterDechetPageState extends State<AjouterDechetPage> {
  String? _selectedType;
  final TextEditingController _nomDechetController = TextEditingController();
  final TextEditingController _masseController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  String? _selectedFileName;
  int _nextDechetId = 1;
  Map<String, String> _errorMessages = {
    'nom': '',
    'masse': '',
    'volume': '',
    'type': '',
  };

  @override
  void initState() {
    super.initState();
    _fetchNextDechetId();
  }

  void _fetchNextDechetId() {
    FirebaseFirestore.instance
        .collection('dechets')
        .orderBy('id_dechet', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        _nextDechetId = (querySnapshot.docs.first.data()
                as Map<String, dynamic>)['id_dechet'] +
            1;
      }
    }).catchError((error) {
      print(
          "Erreur lors de la récupération de l'ID du prochain déchet: $error");
    });
  }

  @override
  void dispose() {
    _nomDechetController.dispose();
    _masseController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  void _ajouterDechet() {
    String nom = _nomDechetController.text.trim();
    double masse = double.tryParse(_masseController.text.trim()) ?? 0.0;
    double volume = double.tryParse(_volumeController.text.trim()) ?? 0.0;
    String? image = _selectedFileName;

    if (nom.isNotEmpty && masse > 0 && volume > 0 && _selectedType != null) {
      sendToDatabase(nom, masse, volume, _selectedType, image);
      _clearFields();
    } else {
      setState(() {
        if (nom.isEmpty) {
          _errorMessages['nom'] = 'Veuillez saisir le nom du déchet';
        } else {
          _errorMessages['nom'] = '';
        }
        if (masse <= 0) {
          _errorMessages['masse'] = 'Veuillez saisir la masse du déchet';
        } else {
          _errorMessages['masse'] = '';
        }
        if (volume <= 0) {
          _errorMessages['volume'] = 'Veuillez saisir le volume du déchet';
        } else {
          _errorMessages['volume'] = '';
        }
        if (_selectedType == null) {
          _errorMessages['type'] = 'Veuillez sélectionner le type du déchet';
        } else {
          _errorMessages['type'] = '';
        }
      });
    }
  }

  void _prendreImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    } else {
      print('Aucun fichier sélectionné.');
    }
  }

  void sendToDatabase(
      String nom, double masse, double volume, String? type, String? image) {
    FirebaseFirestore.instance.collection('dechets').add({
      'id_dechet': _nextDechetId,
      'nom': nom,
      'masse': masse,
      'volume': volume,
      'type': type,
      'image': image,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content:
                Text('Les informations de vos déchets sont bien enregistrées.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _clearFields();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      _nextDechetId++; // Incrémenter pour le prochain déchet
    }).catchError((error) {
      print("Erreur lors de l'ajout du déchet: $error");
    });
  }

  void _clearFields() {
    setState(() {
      _nomDechetController.clear();
      _masseController.clear();
      _volumeController.clear();
      _selectedType = null;
      _selectedFileName = null;
      _errorMessages = {
        'nom': '',
        'masse': '',
        'volume': '',
        'type': '',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Ajouter un déchet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: _nomDechetController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nom du déchet',
                  prefixIcon: Icon(Icons.article),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  errorText: _errorMessages['nom'],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _masseController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Masse (en kg)',
                        prefixIcon: Icon(Icons.line_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        errorText: _errorMessages['masse'],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _volumeController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Volume (en m³)',
                        prefixIcon: Icon(Icons.volume_up),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        errorText: _errorMessages['volume'],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  errorText: _errorMessages['type'],
                ),
                items: ['Organique', 'Chimique'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _prendreImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Prendre une image'),
                ),
                SizedBox(width: 10),
                if (_selectedFileName != null)
                  Text(
                    '$_selectedFileName sélectionné',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _ajouterDechet,
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
