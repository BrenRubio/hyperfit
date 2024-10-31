import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Progreso extends StatefulWidget {
  @override
  _ProgresoState createState() => _ProgresoState();
}

class _ProgresoState extends State<Progreso> {
  int totalCalorias = 0; // Cambiado a int

  // Lista editable de textos para cada caja
  final List<String> textos = [
    'Peso perdido',
    'Resistencia',
    'Agilidad',
    'Carga soportada',
  ];

  // Lista de íconos para cada tarjeta
  final List<IconData> iconos = [
    Icons.fitness_center,
    Icons.speed,
    Icons.accessibility,
    Icons.scale,
  ];

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    obtenerCaloriasTotal();
  }

  Future<void> obtenerCaloriasTotal() async {
    // Verifica que el usuario esté autenticado
    if (user == null) {
      return; // Retorna si el usuario no está autenticado
    }

    int totalCaloriasTemp = 0; // Cambiado a int

    // Accede a la colección de Firestore usando el uid del usuario
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['calorias'] != null) {
        // Verifica que el campo calorias sea de tipo num
        if (data['calorias'] is num) {
          // Convierte a int antes de sumar
          totalCaloriasTemp += (data['calorias'] as num)
              .toInt(); // Asegúrate de usar toInt() aquí
        }
      }
    }

    setState(() {
      totalCalorias = totalCaloriasTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Progreso',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resultados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: List.generate(4, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 123, 0)
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                iconos[index],
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  index == 0 ? '$totalCalorias' : textos[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
