import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ActividadesNatacion(),
    );
  }
}

class Actividad {
  String nombre;
  String descripcion;
  int duracion; // en minutos
  String intensidad;
  int calorias; // calorías quemadas

  Actividad(this.nombre, this.descripcion, this.duracion, this.intensidad,
      this.calorias);
}

class ActividadesNatacion extends StatelessWidget {
  final List<Actividad> actividades = [
    Actividad("Actividad1", "Descripción", 1, "Baja", 300),
    Actividad("Actividad2", "Descripción", 45, "Media", 250),
    Actividad("Actividad3", "Descripción", 30, "Alta", 350),
    Actividad("Actividad4", "Descripción", 60, "Media", 400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Actividades',
            style: TextStyle(
                color: Colors.white), // Cambia el color del texto aquí
          ),
        ),
        backgroundColor: Colors.black, // Azul vibrante
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 18, 40, 51),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: actividades.length,
          itemBuilder: (context, index) {
            final actividad = actividades[index];
            return _buildCard(context, actividad);
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Actividad actividad) {
    return Container(
      margin:
          EdgeInsets.all(8), // Reducir margen para hacer la tarjeta más pequeña
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 2), // Menos sombra para un diseño más compacto
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            vertical: 12, horizontal: 16), // Ajustar padding
        title: Text(
          actividad.nombre,
          style: TextStyle(
            fontSize: 20, // Tamaño de fuente más pequeño
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 20, 0, 133),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              actividad.descripcion,
              style: TextStyle(
                fontSize: 14, // Tamaño de fuente más pequeño
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('Intensidad:', actividad.intensidad),
            _buildInfoRow('Calorías:', '${actividad.calorias} kcal'),
            _buildInfoRow('Duración:', '${actividad.duracion} min'),
          ],
        ),
        onTap: () => _mostrarConfirmacion(context, actividad),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // Tamaño de fuente más pequeño
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14, // Tamaño de fuente más pequeño
              color: Color.fromARGB(255, 0, 17, 65),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarConfirmacion(BuildContext context, Actividad actividad) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Iniciar Actividad'),
          content: Text('¿Deseas realizar ${actividad.nombre}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TemporizadorScreen(actividad: actividad),
                  ),
                );
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class TemporizadorScreen extends StatefulWidget {
  final Actividad actividad;

  TemporizadorScreen({required this.actividad});

  @override
  _TemporizadorScreenState createState() => _TemporizadorScreenState();
}

class _TemporizadorScreenState extends State<TemporizadorScreen> {
  int segundosRestantes = 0;
  late Timer _timer;
  double progreso = 1.0;

  @override
  void initState() {
    super.initState();
    segundosRestantes = widget.actividad.duracion * 60;
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (segundosRestantes > 0) {
        setState(() {
          segundosRestantes--;
          progreso = segundosRestantes / (widget.actividad.duracion * 60);
        });
      } else {
        _timer.cancel();
        _mostrarActividadCompletada();
      }
    });
  }

  void _mostrarActividadCompletada() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Actividad Completada'),
          content:
              Text('Has completado la actividad: ${widget.actividad.nombre}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Volver a la pantalla anterior
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temporizador: ${widget.actividad.nombre}',
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Azul vibrante
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 18, 40, 51),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tiempo restante: ${_formatearTiempo(segundosRestantes)}',
                style: TextStyle(
                    fontSize: 28,
                    color:
                        Color.fromARGB(255, 255, 123, 0)), // Color anaranjado
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                value: progreso, // Valor entre 0 y 1
                strokeWidth: 8,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(height: 20),
              Text(
                'Duración total: ${widget.actividad.duracion} minutos',
                style: TextStyle(
                    fontSize: 20,
                    color:
                        Color.fromARGB(255, 255, 123, 0)), // Color anaranjado
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearTiempo(int segundos) {
    int minutos = segundos ~/ 60;
    int segundosRestantes = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundosRestantes.toString().padLeft(2, '0')}';
  }
}
