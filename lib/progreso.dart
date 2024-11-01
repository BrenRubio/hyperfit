import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Progreso extends StatefulWidget {
  @override
  _ProgresoState createState() => _ProgresoState();
}

class _ProgresoState extends State<Progreso> {
  int totalCalorias = 0;
  int totalTiempo = 0;
  int totalAgilidad = 0;
  int totalCarga = 0;
  List<_ActividadPorFecha> data = [];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    obtenerCaloriasTotal();
    obtenerResistenciaTotal();
    obtenerFlexibilidadTotal();
    obtenerCargaTotal();
    obtenerDatosGrafico();
  }

  Future<void> obtenerCaloriasTotal() async {
    if (user == null) return;

    int totalCaloriasTemp = 0;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['calorias'] != null) {
        totalCaloriasTemp += (data['calorias'] as num).toInt();
      }
    }
    setState(() {
      totalCalorias = totalCaloriasTemp;
    });
  }

  Future<void> obtenerResistenciaTotal() async {
    if (user == null) return; // Retorna si el usuario no está autenticado

    int totalTiempoTemp = 0;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['tiempo'] != null) {
        if (data['tiempo'] is num) {
          totalTiempoTemp += (data['tiempo'] as num)
              .toInt(); // Asegúrate de que este valor sea en minutos
        }
      }
    }

    setState(() {
      totalTiempo = totalTiempoTemp; // El valor total debe ser el mismo
    });
  }

  Future<void> obtenerFlexibilidadTotal() async {
    if (user == null) return;

    int totalAgilidadTemp = 0;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['agilidad'] != null) {
        totalAgilidadTemp += (data['agilidad'] as num).toInt();
      }
    }
    setState(() {
      totalAgilidad = totalAgilidadTemp;
    });
  }

  Future<void> obtenerCargaTotal() async {
    if (user == null) return;

    int totalCargaTemp = 0;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['carga'] != null) {
        totalCargaTemp += (data['carga'] as num).toInt();
      }
    }
    setState(() {
      totalCarga = totalCargaTemp;
    });
  }

  Future<void> obtenerDatosGrafico() async {
    if (user == null) return;

    List<_ActividadPorFecha> tempData = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    Map<String, int> actividadesPorFecha = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['fecha'] != null) {
        DateTime fecha = (data['fecha'] as Timestamp).toDate();
        String fechaString = "${fecha.day}/${fecha.month}/${fecha.year}";

        actividadesPorFecha.update(fechaString, (value) => value + 1,
            ifAbsent: () => 1);
      }
    }

    actividadesPorFecha.forEach((fecha, cantidad) {
      tempData.add(_ActividadPorFecha(fecha, cantidad));
    });

    setState(() {
      data = tempData;
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
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Actividades Completadas por Día'),
                  series: <LineSeries<_ActividadPorFecha, String>>[
                    LineSeries<_ActividadPorFecha, String>(
                      dataSource: data,
                      xValueMapper: (_ActividadPorFecha actividad, _) =>
                          actividad.fecha,
                      yValueMapper: (_ActividadPorFecha actividad, _) =>
                          actividad.cantidad,
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                    children: [
                      buildCard('Peso perdido', Icons.fitness_center,
                          '$totalCalorias kcal'),
                      buildCard('Resistencia', Icons.speed, '$totalTiempo min'),
                      buildCard('Flexibilidad', Icons.accessibility,
                          '$totalAgilidad mm'),
                      buildCard(
                          'Carga soportada', Icons.scale, '$totalCarga kcal'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, IconData icon, String value) {
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$title: $value',
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
  }
}

class _ActividadPorFecha {
  final String fecha;
  final int cantidad;
  _ActividadPorFecha(this.fecha, this.cantidad);
}
