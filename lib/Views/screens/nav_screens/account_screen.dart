import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      EasyLoading.show(status: 'Cargando...');
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('buyers').doc(user.uid).get();

        setState(() {
          userData = userDoc.data();
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener los datos del usuario: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    // Navegar a la pantalla de inicio o de login después de cerrar sesión
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Center( // Centra todo el contenido en la pantalla
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
            children: [
              Text(
                'Información del Usuario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              userData!['profileImage'] != ""
                  ? Image.network(userData!['profileImage'], height: 100)
                  : Icon(Icons.account_circle, size: 100),
              SizedBox(height: 20),
              Text(
                'Nombre: ${userData!['fullName']}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Correo electrónico: ${userData!['email']}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Ciudad: ${userData!['city']}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Estado: ${userData!['state']}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40), // Espacio adicional antes del botón
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
