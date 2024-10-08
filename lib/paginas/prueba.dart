import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ObjetivoEntrenamiento(),
    );
  }
}

class ObjetivoEntrenamiento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color.fromARGB(255, 18, 40, 51),
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                'Objetivo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // Dos columnas para las tarjetas
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 26.0,
                  children: <Widget>[
                    buildTarjetasObjetivo(
                        'Perder peso', 'assets/hyperfit_logo.png'),
                    buildTarjetasObjetivo(
                        'Musculo', 'assets/hyperfit_logo.png'),
                    buildTarjetasObjetivo(
                        'Tonificación', 'assets/hyperfit_logo.png'),
                    buildTarjetasObjetivo('Fuerza', 'assets/hyperfit_logo.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTarjetasObjetivo(String titulo, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Texto en la parte superior
            Container(
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Imagen en la parte inferior
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Ajusta la imagen para llenar la tarjeta
              ),
            ),
          ],
        ),
      ),
    );
  }
}
