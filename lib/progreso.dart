import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Progreso extends StatefulWidget {
  const Progreso({super.key});

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
    _obtenerTotales();
    _obtenerDatosGrafico();
  }

  /// Obtiene los valores totales de calorías, resistencia, agilidad y carga.
  Future<void> _obtenerTotales() async {
    if (user == null) return;

    final valores = await _obtenerValoresTotales(
        ['calorias', 'tiempo', 'agilidad', 'carga']);
    setState(() {
      totalCalorias = valores['calorias'] ?? 0;
      totalTiempo = valores['tiempo'] ?? 0;
      totalAgilidad = valores['agilidad'] ?? 0;
      totalCarga = valores['carga'] ?? 0;
    });
  }

  /// Función que consolida la obtención de los totales en una sola llamada a Firebase.
  Future<Map<String, int>> _obtenerValoresTotales(List<String> campos) async {
    final valoresTotales = {for (var campo in campos) campo: 0};
    final snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      for (var campo in campos) {
        if (data != null && data[campo] != null) {
          valoresTotales[campo] =
              valoresTotales[campo]! + (data[campo] as num).toInt();
        }
      }
    }
    return valoresTotales;
  }

  /// Obtiene los datos necesarios para mostrar el gráfico.
  Future<void> _obtenerDatosGrafico() async {
    if (user == null) return;

    final tempData = <_ActividadPorFecha>[];
    final snapshot = await FirebaseFirestore.instance
        .collection('01')
        .doc(user!.uid)
        .collection('actividades_completadas')
        .orderBy('fecha')
        .get();

    if (snapshot.docs.isEmpty) return;

    final fechaInicial = (snapshot.docs.first['fecha'] as Timestamp).toDate();
    final fechaFinal = (snapshot.docs.last['fecha'] as Timestamp).toDate();
    final actividadesPorFecha = <String, int>{};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['fecha'] != null) {
        final fecha = (data['fecha'] as Timestamp).toDate();
        final fechaString = "${fecha.day}/${fecha.month}/${fecha.year}";
        actividadesPorFecha.update(fechaString, (value) => value + 1,
            ifAbsent: () => 1);
      }
    }

    var fechaIterador = fechaInicial;
    while (!fechaIterador.isAfter(fechaFinal)) {
      final fechaString =
          "${fechaIterador.day}/${fechaIterador.month}/${fechaIterador.year}";
      tempData.add(_ActividadPorFecha(
          fechaString, actividadesPorFecha[fechaString] ?? 0));
      fechaIterador = fechaIterador.add(const Duration(days: 1));
    }

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
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                _buildGrafico(),
                const SizedBox(height: 15),
                _buildResultados(),
                const SizedBox(height: 25),
                Expanded(
                  child: _buildGridResultados(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrafico() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        autoScrollingMode: AutoScrollingMode.end,
        autoScrollingDelta: 4,
      ),
      primaryYAxis: const NumericAxis(
        interval: 1,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
      ),
      title: const ChartTitle(text: 'Actividades realizadas por día'),
      series: <LineSeries<_ActividadPorFecha, String>>[
        LineSeries<_ActividadPorFecha, String>(
          dataSource: data,
          xValueMapper: (_ActividadPorFecha actividad, _) => actividad.fecha,
          yValueMapper: (_ActividadPorFecha actividad, _) => actividad.cantidad,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildResultados() {
    return Align(
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
          const SizedBox(height: 6),
          Container(
            height: 4,
            width: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.white],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridResultados() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 18.0,
      mainAxisSpacing: 18.0,
      childAspectRatio: 1.5,
      children: [
        _buildCard('Peso perdido', Icons.fitness_center, '$totalCalorias kcal'),
        _buildCard('Tiempo de resistencia', Icons.speed, '$totalTiempo min'),
        _buildCard('Agilidad', Icons.accessibility, '  ' '$totalAgilidad mm'),
        _buildCard('Carga soportada', Icons.scale, '$totalCarga kcal'),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, String value) {
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
            Icon(icon, color: const Color.fromARGB(255, 18, 40, 51), size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$title: $value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
