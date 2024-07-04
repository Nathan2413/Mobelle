import 'package:flutter/material.dart';
import '../ecran.dart'; // Importation de "../ecran.dart"
import 'fako.dart'; // Importation de "../fako.dart"

class UDashboard extends StatefulWidget {
  @override
  _UDashboardState createState() => _UDashboardState();
}

class _UDashboardState extends State<UDashboard>
    with SingleTickerProviderStateMixin {
  bool _showImage = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Durée de l'animation
    );
    _animation = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Commence en bas de l'écran
      end: Offset.zero, // Se termine en haut de l'écran
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 165, 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        elevation: 4,
        shadowColor: Colors.grey[400],
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyApp(), // Redirection vers MyApp() de "../ecran.dart"
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 16, 165, 8),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Poubelles'),
              onTap: () {
                setState(() {
                  _showImage = false;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Carte'),
              onTap: () {
                setState(() {
                  _showImage = true;
                });
                _controller.forward(); // Démarrer l'animation
                Navigator.pop(context); // Ferme le rideau (drawer)
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Couleur de fond blanc
        child: _showImage ? _buildImageWithAnimation() : FakoScreen(),
      ),
    );
  }

  Widget _buildImageWithAnimation() {
    return SlideTransition(
      position: _animation, // Appliquer l'animation de bas en haut
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0), // Padding ajusté à 80
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Carte',
                style: TextStyle(
                  color:
                      Colors.grey[700], // Couleur de texte gris professionnel
                  fontSize: 36, // Taille de police 36
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 12 / 12,
              child: Image.asset(
                'images/carte.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
