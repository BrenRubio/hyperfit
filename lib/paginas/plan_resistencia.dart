import 'package:flutter/material.dart';
import 'package:flutter_hyperfit/paginas/resistencia_act/circuito.dart';
import 'package:flutter_hyperfit/paginas/resistencia_act/cuerda.dart';
import 'package:flutter_hyperfit/paginas/resistencia_act/escalera.dart';
import 'package:flutter_hyperfit/paginas/resistencia_act/senderismo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan - Resistencia',
      home: PlanResistencia(),
    );
  }
}

class PlanResistencia extends StatelessWidget {
  const PlanResistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        title: const Center(
          child: Text(
            'Plan - Resistencia',
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
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                ActivityItem(
                  imageUrl: 'assets/circuito.jpg',
                  buttonText: 'Entrenamiento en circuito',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesCircuito()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/escalera.jpg',
                  buttonText: 'Entrenamiento en escalera',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesEscalera()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/senderismo.jpg',
                  buttonText: 'Senderismo',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesSenderismo()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/cuerda.jpg',
                  buttonText: 'Saltar la cuerda',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesCuerda()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String imageUrl;
  final String buttonText;
  final VoidCallback onTap;

  const ActivityItem({
    super.key,
    required this.imageUrl,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl), // Cambiar a AssetImage
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(120, 40),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
