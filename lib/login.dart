import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'admin/dashboard.dart';
import 'personnel/dashboard.dart';
import 'mdp_oub.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  Color _borderColor = Colors.transparent;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _formAnimation;

  final Color _primaryColor = Color(0xFF4CAF50); // Couleur verte principale
  final Color _accentColor =
      Color(0xFF2E7D32); // Couleur verte foncée pour les accents
  final Color _textColor = Colors.grey[800]!; // Couleur du texte en gris foncé

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _imageAnimation = Tween<double>(
      begin: -1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _formAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.easeInOut),
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
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: _textColor,
            ),
          ),
          body: isMobile ? buildMobileLayout() : buildWebLayout(),
        );
      },
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width * _imageAnimation.value,
                0,
                0),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Image.asset('images/pou5.jpg'),
            ),
          ),
          SizedBox(height: 16.0),
          Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width * _formAnimation.value, 0, 0),
            child: buildForm(),
          ),
        ],
      ),
    );
  }

  Widget buildWebLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Transform(
            transform: Matrix4.translationValues(
                MediaQuery.of(context).size.width * _imageAnimation.value,
                0,
                0),
            child: Image.asset('images/pou5.jpg'),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Transform(
              transform: Matrix4.translationValues(
                  MediaQuery.of(context).size.width * _formAnimation.value,
                  0,
                  0),
              child: buildForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Mo Belle',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: _textColor),
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email, color: _accentColor),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _borderColor,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _borderColor = Colors.grey;
              });
            },
            onEditingComplete: () {
              setState(() {
                _borderColor = Colors.transparent;
              });
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(color: _textColor),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock, color: _accentColor),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _borderColor,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: _accentColor,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _borderColor = Colors.grey;
              });
            },
            onEditingComplete: () {
              setState(() {
                _borderColor = Colors.transparent;
              });
            },
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MotDePasseOublie()),
                );
              },
              child: Text(
                'Mot de passe oublié',
                style: TextStyle(
                  color: _accentColor,
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _signInWithEmailAndPassword();
            },
            child: Text(
              'Se connecter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 16.0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(_primaryColor),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            alignment: Alignment.center,
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _signInWithEmailAndPassword() async {
    try {
      final String hashedPassword = _generateMD5(_passwordController.text);
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('personnel')
          .where('email', isEqualTo: _emailController.text)
          .where('motDePasse', isEqualTo: hashedPassword)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
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
        setState(() {
          _errorMessage = 'Email ou mot de passe incorrect';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion: $e';
      });
    }
  }
}
