import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ActividadesSenderismo(),
    );
  }
}

class Actividad {
  String nombre;
  String descripcion;
  int duracion; // en minutos
  String intensidad;
  int tiempo; // tiempo de resistencia

  Actividad(this.nombre, this.descripcion, this.duracion, this.intensidad,
      this.tiempo);
}

class ActividadesSenderismo extends StatelessWidget {
  final List<Actividad> actividades = [
    Actividad("Actividad1", "Descripción", 1, "Baja", 300),
    Actividad("Actividad2", "Descripción", 45, "Media", 250),
    Actividad("Actividad3", "Descripción", 30, "Alta", 350),
    Actividad("Actividad4", "Descripción", 60, "Media", 400),
  ];

  ActividadesSenderismo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Actividades',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 26),
        title: Text(
          actividad.nombre,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 8, 80, 212),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            Text(
              actividad.descripcion,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 1),
            _buildInfoRow('Intensidad:', actividad.intensidad),
            _buildInfoRow('Tiempo:', '${actividad.tiempo} min'),
            _buildInfoRow('Duración:', '${actividad.duracion} min'),
          ],
        ),
        onTap: () => _mostrarConfirmacion(context, actividad),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
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
          title: const Text('Iniciar Actividad'),
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
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class TemporizadorScreen extends StatefulWidget {
  final Actividad actividad;

  const TemporizadorScreen({super.key, required this.actividad});

  @override
  _TemporizadorScreenState createState() => _TemporizadorScreenState();
}

class _TemporizadorScreenState extends State<TemporizadorScreen> {
  int segundosRestantes = 0;
  late Timer _timer;
  double progreso = 1.0;
  bool _estaPausado = false;

  @override
  void initState() {
    super.initState();
    segundosRestantes = widget.actividad.duracion * 60;
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_estaPausado && segundosRestantes > 0) {
        setState(() {
          segundosRestantes--;
          progreso = segundosRestantes / (widget.actividad.duracion * 60);
        });
      } else if (segundosRestantes == 0) {
        _timer.cancel();
        _registrarActividadCompletada();
      }
    });
  }

  void _pausarTemporizador() {
    setState(() {
      _estaPausado = true;
    });
  }

  void _reanudarTemporizador() {
    setState(() {
      _estaPausado = false;
    });
  }

  void _reiniciarTemporizador() {
    setState(() {
      segundosRestantes = widget.actividad.duracion * 60;
      progreso = 1.0;
      _estaPausado = false;
    });
  }

  Future<bool> _onWillPop() async {
    bool? cancelar = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar Actividad'),
          content:
              const Text('¿Estás seguro de que deseas cancelar la actividad?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No cancelar
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Cancelar
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
    return cancelar ?? false; // Devuelve false si el usuario no responde
  }

  void _registrarActividadCompletada() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('01')
          .doc(user.uid)
          .collection('actividades_completadas')
          .add({
        'nombre': widget.actividad.nombre,
        'descripcion': widget.actividad.descripcion,
        'duracion': widget.actividad.duracion,
        'intensidad': widget.actividad.intensidad,
        'tiempo': widget.actividad.tiempo,
        'fecha': DateTime.now(),
      });
    }

    _mostrarActividadCompletada();
  }

  void _mostrarActividadCompletada() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Actividad Completada'),
          content:
              Text('Has completado la actividad: ${widget.actividad.nombre}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Volver a la pantalla anterior
              },
              child: const Text('Aceptar'),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Temporizador: ${widget.actividad.nombre}'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        body: Container(
          decoration: const BoxDecoration(
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
                  _formatearTiempo(segundosRestantes),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Color del temporizador
                  ),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  value: progreso,
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(
                          255, 255, 102, 0)), // Color de la barra circular
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pausarTemporizador,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pausar'),
                    ),
                    const SizedBox(height: 10), // Espacio entre botones
                    ElevatedButton.icon(
                      onPressed: _reanudarTemporizador,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reanudar'),
                    ),
                    const SizedBox(height: 10), // Espacio entre botones
                    ElevatedButton.icon(
                      onPressed: _reiniciarTemporizador,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reiniciar'),
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

  String _formatearTiempo(int segundos) {
    final minutos = segundos ~/ 60;
    final segundosRestantes = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundosRestantes.toString().padLeft(2, '0')}';
  }
}
