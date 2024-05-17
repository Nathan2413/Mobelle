import 'package:flutter/material.dart';
import '../ecran.dart';
import '../carte.dart';

class UDashboard extends StatefulWidget {
  const UDashboard({Key? key}) : super(key: key);

  @override
  _UDashboardState createState() => _UDashboardState();
}

class _UDashboardState extends State<UDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _navigateToCarte() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Carte()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mo Belle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 93, 233, 98),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.grey[400],
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
          onPressed: _toggleMenu,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Text('Contenu du tableau de bord utilisateur'),
            ),
          ),
          Positioned(
            top: kToolbarHeight,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1.0, 0),
                end: Offset(0, 0),
              ).animate(_animation),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    SizedBox(height: 16.0),
                    ListTile(
                      title: Text(
                        'Poubelles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      leading: Text(
                        '🗑️', // Emoji pour la poubelle
                        style: TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ListTile(
                      title: Text(
                        'Carte',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      leading: Text(
                        '🗺️', // Emoji pour la carte
                        style: TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      onTap:
                          _navigateToCarte, // Naviguer vers la page "Carte" lors du clic
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
