import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/objetivos.dart';
import 'package:flutter_hyperfit/paginas/inicio_sesion.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart'; // Importa PerfilUsuario

class PantallaPrincipal extends StatefulWidget {
  final String nombre; // Variable para almacenar el nombre

  const PantallaPrincipal(
      {super.key, required this.nombre}); // Constructor que recibe el nombre

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _currentIndex =
      0; // Variable para controlar el índice de la pestaña seleccionada

  final List<Widget> _pages = [
    Center(child: Text('Perfil')),
    Center(child: Text('Plan')), // Este será reemplazado por ObjetivoScreen
    Center(child: Text('Progreso')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const InicioSesion(),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color.fromARGB(255, 18, 40, 51),
              Colors.black,
            ],
          ),
        ),
        child: _currentIndex == 1
            ? ObjetivoScreen() // Navega a ObjetivoScreen cuando el índice es 1
            : _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilUsuario(
                    nombre: 'Perfil',
                  ), // Navega a PerfilUsuario
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ObjetivoScreen(), // Navega a ObjetivoScreen
                ),
              );
            } else {
              _currentIndex =
                  index; // Actualiza el índice de la pestaña seleccionada
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Progreso',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 255, 123, 0),
      ),
    );
  }
}
