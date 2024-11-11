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
      home: ActividadesAerobics(),
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

class ActividadesAerobics extends StatelessWidget {
  final List<Actividad> actividades = [
    Actividad("Aeróbicos suaves",
        "Caminar rápido o realizar movimientos suaves", 30, "Baja", 5),
    Actividad(
        "Aeróbicos de ritmo rápido",
        "Bailar o realizar movimientos de cardio intenso con poco descanso.",
        55,
        "Media",
        10),
    Actividad(
        "Aeróbicos de alta intensidad",
        "Saltos y carreras en el lugar para elevar el ritmo cardíaco.",
        30,
        "Alta",
        25),
    Actividad(
        "Aeróbicos con saltos",
        "Incorporación de saltos y giros en los movimientos.",
        40,
        "Muy alta",
        37),
  ];

  ActividadesAerobics({super.key});

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
            _buildInfoRow('Calorías:', '${actividad.calorias} kcal'),
            _buildInfoRow('Duración:', '${actividad.duracion} min'),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TemporizadorScreen(actividad: actividad),
            ),
          );
        },
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
        'calorias': widget.actividad.calorias,
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

  Future<bool> _mostrarAlertaCancelar() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar Actividad'),
          content: const Text('¿Deseas cancelar la actividad?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cancelar = await _mostrarAlertaCancelar();
        return cancelar; // Si el usuario dice que sí, se permite salir
      },
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
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Color del temporizador
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100, // Ajusta el ancho según sea necesario
                  height: 100, // Ajusta la altura según sea necesario
                  child: CircularProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 123, 0)),
                    strokeWidth: 10, // Puedes ajustar el grosor si lo deseas
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _pausarTemporizador,
                      icon: const Icon(Icons.pause,
                          size: 50, color: Color.fromARGB(106, 192, 206, 203)),
                      tooltip: 'Pausar',
                    ),
                    IconButton(
                      onPressed: _reanudarTemporizador,
                      icon: const Icon(Icons.play_arrow,
                          size: 50, color: Color.fromARGB(106, 192, 206, 203)),
                      tooltip: 'Reanudar',
                    ),
                    IconButton(
                      onPressed: _reiniciarTemporizador,
                      icon: const Icon(Icons.refresh,
                          size: 50, color: Color.fromARGB(106, 192, 206, 203)),
                      tooltip: 'Reiniciar',
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
    final minutos = (segundos ~/ 60).toString().padLeft(2, '0');
    final segundosRestantes = (segundos % 60).toString().padLeft(2, '0');
    return '$minutos:$segundosRestantes';
  }
}
