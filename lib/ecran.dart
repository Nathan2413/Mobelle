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
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(0, 33, 33, 33),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            textStyle:
                MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18.0)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            shadowColor:
                MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.5)),
            elevation: MaterialStateProperty.all<double>(8.0),
          ),
        ),
      ),
      home: const MyHomePage(),
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
      duration: Duration(milliseconds: 1500),
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
      appBar: null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/pou4.jpg',
            fit: BoxFit.cover,
            color: const Color.fromARGB(136, 0, 0, 0),
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 24.0),
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
                            isWeb ? 'Mo Belle' : 'Mo Belle',
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
                          // Afficher une ligne plus grande et arrondie sur mobile uniquement
                          if (isMobile)
                            Container(
                              width: 80, // Largeur de la ligne
                              height: 6, // Hauteur de la ligne
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                    8), // Bord arrondi à 10%
                              ),
                            ),
                          // Afficher une ligne arrondie sur le web
                          if ((isMobile || isWeb) && isWeb)
                            Container(
                              width: 100, // Largeur de la ligne sur le web
                              height: 10, // Hauteur de la ligne sur le web
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                    8), // Bord arrondi à 10%
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(-100 * (1 - _animation.value), 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Une route propre ne dépend pas seulement de l'efficacité du service de nettoyage, mais aussi de l'éducation des personnes qui y passent.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 25.0 : (isWeb ? 60.0 : 25.0),
                        color: Colors.white,
                        fontStyle: FontStyle.italic, // Texte en italique
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              if (!isWeb)
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
              if (!isMobile) SizedBox(height: 10.0),
              if (!isMobile)
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
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
