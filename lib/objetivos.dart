import 'package:flutter/material.dart';
import 'package:flutter_hyperfit/paginas/plan_flexibilidad.dart';
import 'package:flutter_hyperfit/paginas/plan_fuerza.dart';
import 'package:flutter_hyperfit/paginas/plan_peso.dart';
import 'package:flutter_hyperfit/paginas/plan_resistencia.dart';

class ObjetivoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Objetivos',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildButtonColumn(
                        'Perder peso',
                        'assets/peso.jpg',
                        context,
                        PlanPeso(), // Pantalla a la que se dirige
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildButtonColumn(
                        'Resistencia',
                        'assets/resistencia.jpg',
                        context,
                        PlanResistencia(), // Pantalla a la que se dirige
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildButtonColumn(
                        'Flexibilidad',
                        'assets/flexibilidad.jpg',
                        context,
                        PlanFlexibilidad(), // Pantalla a la que se dirige
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildButtonColumn(
                        'Fuerza',
                        'assets/fuerza.jpg',
                        context,
                        PlanFuerza(), // Pantalla a la que se dirige
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildButtonColumn(
      String label, String imagePath, BuildContext context, Widget targetPage) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Color.fromARGB(255, 255, 123, 0),
          ),
        ),
        const SizedBox(height: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: ElevatedButton(
            onPressed: () {
              // Navegar a la página correspondiente según el objetivo
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetPage),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              minimumSize: const Size(150, 200),
            ),
            child: Image.asset(
              imagePath,
              height: 200.0,
              width: 150.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
