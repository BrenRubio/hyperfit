import 'package:flutter/material.dart';
import 'package:flutter_hyperfit/paginas/peso_act/aerobics.dart';
import 'package:flutter_hyperfit/paginas/peso_act/caminata.dart';
import 'package:flutter_hyperfit/paginas/peso_act/ciclismo.dart';
import 'package:flutter_hyperfit/paginas/peso_act/natacion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Plan - Perder peso',
      home: PlanPeso(),
    );
  }
}

class PlanPeso extends StatelessWidget {
  const PlanPeso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        title: const Center(
          child: Text(
            'Plan - Perder peso',
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
                  imageUrl: 'assets/ciclismo.jpg',
                  buttonText: 'Ciclismo',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesCiclismo()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/caminata.jpg',
                  buttonText: 'Caminata rápida',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesCaminata()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/aerobics.jpg',
                  buttonText: 'Aeróbics',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesAerobics()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ActivityItem(
                  imageUrl: 'assets/natacion.jpg',
                  buttonText: 'Natación',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadesNatacion()),
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
