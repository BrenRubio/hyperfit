import 'package:flutter/material.dart';
import 'package:flutter_hyperfit/paginas/plan_flexibilidad.dart';
import 'package:flutter_hyperfit/paginas/plan_fuerza.dart';
import 'package:flutter_hyperfit/paginas/plan_peso.dart';
import 'package:flutter_hyperfit/paginas/plan_resistencia.dart';

class ObjetivoScreen extends StatelessWidget {
  const ObjetivoScreen({super.key});

  // Colores de la aplicación
  static const Color _primaryColor = Colors.black;
  static const Color _accentColor = Color.fromARGB(255, 255, 123, 0);
  static const LinearGradient _backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.black, Color.fromARGB(255, 18, 40, 51), Colors.black],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        title: const Center(
          child: Text(
            'Objetivos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: _primaryColor,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: _backgroundGradient),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ObjetivoButton(
                        label: 'Perder peso',
                        imagePath: 'assets/peso.jpg',
                        targetPage: const PlanPeso(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ObjetivoButton(
                        label: 'Resistencia',
                        imagePath: 'assets/resistencia.jpg',
                        targetPage: const PlanResistencia(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ObjetivoButton(
                        label: 'Flexibilidad',
                        imagePath: 'assets/flexibilidad.jpg',
                        targetPage: const PlanFlexibilidad(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ObjetivoButton(
                        label: 'Fuerza',
                        imagePath: 'assets/fuerza.jpg',
                        targetPage: const PlanFuerza(),
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
}

// Widget reutilizable para botones de objetivos
class ObjetivoButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final Widget targetPage;

  const ObjetivoButton({
    required this.label,
    required this.imagePath,
    required this.targetPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16.0, color: ObjetivoScreen._accentColor),
        ),
        const SizedBox(height: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: ElevatedButton(
            onPressed: () {
              // Navegar a la página correspondiente
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
              semanticLabel: label, // Mejora la accesibilidad
            ),
          ),
        ),
      ],
    );
  }
}
