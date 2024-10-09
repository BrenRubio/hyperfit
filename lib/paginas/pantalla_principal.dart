import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/inicio_sesion.dart'; // Asegúrate de importar tu página de inicio de sesión

class PantallaPrincipal extends StatelessWidget {
  final String nombre; // Variable para almacenar el nombre

  PantallaPrincipal({required this.nombre}); // Constructor que recibe el nombre

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Cerrar sesión con Firebase
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InicioSesion()), // Redirigir a la pantalla de inicio de sesión
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bienvenido, $nombre', // Mostrar el nombre del usuario
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
