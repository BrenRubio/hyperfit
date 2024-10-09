import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/inicio_sesion.dart'; // Asegúrate de importar tu página de inicio de sesión

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
    // Agrega las páginas correspondientes a cada opción aquí
    Center(child: Text('Perfil')),
    Center(child: Text('Plan')),
    Center(child: Text('Progreso')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Eliminamos el fondo del Scaffold para usar el Container con degradado
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        backgroundColor: Colors.transparent, // Hacemos la AppBar transparente
        elevation: 0, // Eliminamos la sombra de la AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut(); // Cerrar sesión con Firebase
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const InicioSesion(), // Redirigir a la pantalla de inicio de sesión
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar:
          true, // Permite que el cuerpo se extienda detrás de la AppBar
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
        child: Center(
          child: Text(
            'Bienvenido, ${widget.nombre}', // Mostrar el nombre del usuario
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice de la pestaña seleccionada
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Actualiza el índice de la pestaña seleccionada
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icono de perfil
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Icono de plan
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment), // Icono de progreso
            label: 'Progreso',
          ),
        ],
      ),
    );
  }
}
