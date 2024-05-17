import 'package:flutter/material.dart';
import 'login.dart';
import 'utilisateur/u_dashboard.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mo Belle',
      theme: ThemeData(
        // Thème de votre application
        appBarTheme: AppBarTheme(
          backgroundColor:
              const Color.fromARGB(0, 33, 33, 33), // Couleur de l'AppBar
          elevation: 0, // Supprime l'ombre de l'AppBar
          iconTheme: IconThemeData(
              color: Colors.white), // Couleur de l'icône de l'AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.green), // Couleur du bouton
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // Couleur du texte
            textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 18.0)), // Style du texte
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 24.0), // Marge interne du bouton
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Bord arrondi du bouton (50%)
              ),
            ),
            shadowColor: MaterialStateProperty.all<Color>(
                Colors.black.withOpacity(0.5)), // Couleur de l'ombre
            elevation:
                MaterialStateProperty.all<double>(8.0), // Élévation du bouton
          ),
        ),
      ),
      home: const MyHomePage(), // Retirez le titre de MyHomePage
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds:
              1500), // Augmenter la durée à 1500 millisecondes (1.5 secondes)
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: null, // Supprime l'AppBar
      body: Stack(
        fit: StackFit.expand, // Ajuste l'image à la taille de l'écran
        children: [
          Image.asset(
            'images/pou4.jpg', // Chemin de l'image de fond
            fit: BoxFit.cover, // Ajuste l'image pour couvrir toute la surface
            color:
                const Color.fromARGB(136, 0, 0, 0), // Assombrir l'arrière-plan
            colorBlendMode: BlendMode
                .darken, // Mode de fusion pour assombrir l'arrière-plan
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .center, // Centrez les éléments horizontalement
            children: <Widget>[
              SizedBox(
                  height: 24.0), // Ajout d'un espace entre l'AppBar et le titre
              Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(0, 100 * (1 - _animation.value)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            isWeb ? 'Mo Belle' : 'Mo Belle', // Titre "Mo Belle"
                            style: TextStyle(
                              fontSize: isWeb ? 100.0 : 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          if ((isMobile || isWeb) &&
                              isWeb) // Afficher la ligne verte sur mobile et web
                            Container(
                              width: 100, // Largeur de la ligne verte
                              height: 10, // Épaisseur de la ligne verte
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0), // Marge verticale
                              color: Colors.green, // Couleur de la ligne verte
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 32.0), // Ajout d'un espace entre le titre et le texte
              Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(-100 * (1 - _animation.value), 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Une route propre ne dépend pas seulement de l'efficacité du service de nettoyage, mais aussi de l'éducation des personnes qui y passent.",
                      textAlign: TextAlign.center,
                      style: isMobile // Vérifie si c'est un appareil mobile
                          ? TextStyle(
                              fontSize: 25.0, // Taille du texte principal
                              color: Colors.white, // Couleur du texte principal
                              fontStyle: FontStyle
                                  .italic, // Style italique pour mobile
                            )
                          : TextStyle(
                              fontSize: isWeb ? 60.0 : 25.0,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      60.0), // Ajout d'un espace entre le texte et le bouton
              Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(0, -100 * (1 - _animation.value)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UDashboard()),
                      );
                    },
                    child: Text(
                      'Les poubelles disponibles',
                      style: TextStyle(fontSize: isWeb ? 30.0 : 18.0),
                    ),
                  ),
                ),
              ),
              if (!isMobile)
                SizedBox(
                    height:
                        10.0), // Ajout d'un espace entre le bouton et le texte "Développeur"
              if (!isMobile)
                Align(
                  alignment: Alignment.bottomRight, // Aligner en bas à droite
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Login()), // Naviguer vers login.dart
                      );
                    },
                    child: Opacity(
                      opacity: _animation.value,
                      child: Transform.translate(
                        offset: Offset(100 * (1 - _animation.value), 0),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 16.0, right: 16.0),
                          child: Text(
                            'Développeur',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
