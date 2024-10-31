import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hyperfit/objetivos.dart';
import 'package:flutter_hyperfit/paginas/inicio_sesion.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart';
import 'package:flutter_hyperfit/progreso.dart';

class PantallaPrincipal extends StatefulWidget {
  final String nombre; // Variable para almacenar el nombre

  const PantallaPrincipal(
      {super.key, required this.nombre}); // Constructor que recibe el nombre

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final int _currentIndex =
      0; // Variable para controlar el índice de la pestaña seleccionada
  Map<String, dynamic>?
      userData; // Variable para almacenar los datos del usuario

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Llama a la función para obtener datos del usuario al iniciar
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance.collection('01').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data(); // Guarda los datos del usuario
        });
      }
    }
  }

  final List<Widget> _pages = [
    const Center(
        child:
            CircularProgressIndicator()), // Temporariamente muestra un cargador
    const Center(child: Text('Plan')),
    const Center(child: Text('Progreso')),
  ];

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 0) {
      // Actualiza el contenido de la página principal según los datos del usuario
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // Evita que se muestre la flecha de retroceso
          title: const Center(
            child: Text(
              '     Pantalla principal',
              style: TextStyle(color: Colors.white), // Color del texto
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white, // Color del icono
              ),
              onPressed: () async {
                // Mostrar un diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmar salida'),
                      content: const Text('¿Realmente desea salir?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Cierra el diálogo sin hacer nada
                          },
                        ),
                        TextButton(
                          child: const Text('Aceptar'),
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
                    );
                  },
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
                Colors.black,
                Color.fromARGB(255, 18, 40, 51),
                Colors.black,
              ],
            ),
          ),
          child: userData == null
              ? const Center(
                  child:
                      CircularProgressIndicator(), // Muestra un indicador de carga
                )
              : _buildMainPage(), // Llama a la función para construir la página principal
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerfilUsuario(
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
              } else if (index == 2) {
                // Agregamos la condición para "Progreso"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Progreso(), // Cambia 'ProgresoScreen' por tu pantalla de progreso
                  ),
                );
              }
              // En caso de que no se seleccione ningún índice, no es necesario actualizar _currentIndex aquí
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
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        ),
      );
    } else {
      return _pages[_currentIndex]; // Regresa la página seleccionada
    }
  }

  // Función para construir la página principal con las tarjetas centradas
  Widget _buildMainPage() {
    // Calcula el IMC, MB y el porcentaje de grasa corporal basados en los datos
    double imc = _calculateIMC(userData!['peso'], userData!['estatura']);
    double mb = _calculateMB(
        userData!['peso'], userData!['estatura'], userData!['sexo']);
    double porcentajeGrasa = _calculateBodyFat(
        userData!['peso'], userData!['estatura'], userData!['sexo']);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra las tarjetas verticalmente
        children: [
          _buildCard('Índice de Masa Corporal: ${imc.toStringAsFixed(2)}',
              Icons.calculate),
          const SizedBox(height: 20), // Separación entre tarjetas
          _buildCard('Metabolismo Basal: ${mb.toStringAsFixed(2)} kcal',
              Icons.local_fire_department),
          const SizedBox(height: 20), // Separación entre tarjetas
          _buildCard(
              'Porcentaje de Grasa Corporal: ${porcentajeGrasa.toStringAsFixed(2)} %',
              Icons.fitness_center),
        ],
      ),
    );
  }

  // Función para calcular el IMC
  double _calculateIMC(int peso, int estatura) {
    double estaturaMetros = estatura / 100; // Convierte estatura a metros
    return peso / (estaturaMetros * estaturaMetros);
  }

  // Función para calcular el MB (Metabolismo Basal)
  double _calculateMB(int peso, int estatura, String sexo) {
    // Fórmula de Harris-Benedict para calcular el MB
    if (sexo == 'Masculino') {
      return 88.362 +
          (13.397 * peso) +
          (4.799 * estatura) -
          (5.677 * 30); // Suponiendo una edad de 30 años
    } else {
      return 447.593 +
          (9.247 * peso) +
          (3.098 * estatura) -
          (4.330 * 30); // Suponiendo una edad de 30 años
    }
  }

  // Función para calcular el porcentaje de grasa corporal
  double _calculateBodyFat(int peso, int estatura, String sexo) {
    // Utiliza una fórmula simple como ejemplo, puedes ajustar según sea necesario
    return (peso / (estatura * estatura)) * 100; // Simplemente un ejemplo
  }

  // Función para construir una tarjeta centrada con un ícono a la izquierda y texto a la derecha
  static Widget _buildCard(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30), // Margen para que no ocupen todo el ancho
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Ícono a la izquierda
            children: [
              Icon(icon,
                  size: 50, color: const Color.fromARGB(255, 255, 123, 0)),
              const SizedBox(width: 20), // Espacio entre el ícono y el texto
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
