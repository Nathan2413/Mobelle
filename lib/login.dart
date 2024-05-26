import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'admin/dashboard.dart'; // Importer le fichier dashboard.dart pour admin
import 'personnel/dashboard.dart'; // Importer le fichier dashboard.dart pour personnel

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = ''; // Message d'erreur
  Color _borderColor = Colors.transparent; // Couleur de la bordure
  bool _obscurePassword = true; // Pour masquer le mot de passe

  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Durée de l'animation (2 secondes)
    );
    _imageAnimation = Tween<double>(
      begin: -1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5,
            curve: Curves.easeInOut), // Courbe de l'animation pour l'image
      ),
    );
    _formAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1,
            curve:
                Curves.easeInOut), // Courbe de l'animation pour le formulaire
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Déterminer si l'application est exécutée sur un téléphone ou dans Chrome
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(''), // Titre de la page de connexion
            iconTheme: IconThemeData(
              color: Colors.grey,
            ), // Couleur de l'icône de retour
          ),
          body: isMobile
              ? buildMobileLayout() // Utiliser la mise en page mobile
              : buildWebLayout(), // Utiliser la mise en page Web
        );
      },
    );
  }

  // Mise en page pour les appareils mobiles
  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width *
                    _imageAnimation
                        .value, // Animation de gauche à droite pour l'image
                0,
                0),
            child: FractionallySizedBox(
              widthFactor: 0.8, // Facteur de taille de l'image
              child: Image.asset('images/pou5.jpg'), // Image en haut
            ),
          ),
          SizedBox(height: 16.0),
          Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width *
                    _formAnimation
                        .value, // Animation de droite à gauche pour le formulaire
                0,
                0),
            child: buildForm(), // Formulaire de connexion
          ),
        ],
      ),
    );
  }

  // Mise en page pour le navigateur Chrome de Visual Studio
  Widget buildWebLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width *
                    _imageAnimation
                        .value, // Animation de gauche à droite pour l'image
                0,
                0),
            child: Image.asset(
                'images/pou5.jpg'), // Image dans la première colonne
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Transform(
              transform: Matrix4.translationValues(
                  MediaQuery.of(context).size.width *
                      _formAnimation
                          .value, // Animation de droite à gauche pour le formulaire
                  0,
                  0),
              child:
                  buildForm(), // Formulaire de connexion dans la deuxième colonne
            ),
          ),
        ),
      ],
    );
  }

  // Construction du formulaire de connexion
  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Ajouter le grand titre "Mo Belle" en haut de l'entrée de l'adresse e-mail
          Text(
            'Mo Belle',
            style: TextStyle(
              fontSize: 40.0, // Taille de la police
              fontWeight: FontWeight.bold, // Gras
              color: Color.fromARGB(255, 35, 223, 126), // Couleur verte
            ),
            textAlign: TextAlign.center, // Alignement central
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: Colors.black), // Couleur du texte
            decoration: InputDecoration(
              labelText: 'Email', // Label du champ email
              prefixIcon: Icon(Icons.email), // Icône de l'e-mail
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _borderColor, // Couleur de la bordure
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _borderColor =
                    Colors.grey; // Changer la couleur de la bordure au clic
              });
            },
            onEditingComplete: () {
              setState(() {
                _borderColor = Colors
                    .transparent; // Rendre la bordure invisible après l'édition
              });
            },
          ),
          SizedBox(height: 16.0), // Espacement entre les champs
          TextFormField(
            controller: _passwordController,
            obscureText:
                _obscurePassword, // Masquer le texte saisi (pour le mot de passe)
            style: TextStyle(color: Colors.black), // Couleur du texte
            decoration: InputDecoration(
              labelText: 'Mot de passe', // Label du champ mot de passe
              prefixIcon: Icon(Icons.lock), // Icône du mot de passe
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _borderColor, // Couleur de la bordure
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword =
                        !_obscurePassword; // Inverser la visibilité du mot de passe
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility, // Icône d'œil
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _borderColor =
                    Colors.grey; // Changer la couleur de la bordure au clic
              });
            },
            onEditingComplete: () {
              setState(() {
                _borderColor = Colors
                    .transparent; // Rendre la bordure invisible après l'édition
              });
            },
          ),
          SizedBox(
              height:
                  16.0), // Espacement entre le champ de mot de passe et le bouton
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Action à effectuer lors du clic sur "Mot de passe oublié"
                // Ajoutez ici la logique pour gérer le mot de passe oublié
              },
              child: Text(
                'Mot de passe oublié',
                style: TextStyle(
                  color: Colors.green, // Couleur du texte verte
                  fontSize: 14.0, // Taille de la police
                  fontStyle: FontStyle.italic, // Style de police italic
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _signInWithEmailAndPassword(); // Appeler la fonction de connexion
            },
            child: Text('Se connecter'), // Texte du bouton "Se connecter"
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(
                    vertical: 16.0), // Espacement interne du bouton
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Bord arrondi du bouton
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.grey[600]!, // Couleur de fond grise plus foncée
              ),
            ),
          ),
          SizedBox(
              height:
                  16.0), // Espacement entre le bouton et le message d'erreur
          Container(
            alignment: Alignment.center,
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red, // Couleur du texte d'erreur
                fontSize: 14.0, // Taille de la police
                fontStyle: FontStyle.italic, // Style de police italic
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour hasher le mot de passe en MD5
  String _generateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // Fonction pour vérifier les informations d'identification
  void _signInWithEmailAndPassword() async {
    try {
      final String hashedPassword = _generateMD5(
          _passwordController.text); // Convertir le mot de passe entré en MD5
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('personnel')
          .where('email', isEqualTo: _emailController.text)
          .where('motDePasse',
              isEqualTo:
                  hashedPassword) // Comparer avec le mot de passe hashé dans la base de données
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        // Si l'utilisateur existe dans la collection personnel
        final role = documents[0]['role'];
        if (role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else if (role == 'personnel') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDashboard()),
          );
        }
      } else {
        // Si l'utilisateur n'existe pas ou si les informations sont incorrectes
        setState(() {
          _errorMessage = 'Email ou mot de passe incorrect';
        });
      }
    } catch (e) {
      // En cas d'erreur, afficher le message d'erreur
      setState(() {
        _errorMessage = 'Erreur de connexion: $e';
      });
    }
  }
}
