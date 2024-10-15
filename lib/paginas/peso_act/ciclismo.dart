import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Ciclismo(),
    );
  }
}

class Ciclismo extends StatefulWidget {
  @override
  _CiclismoState createState() => _CiclismoState();
}

class _CiclismoState extends State<Ciclismo> {
  // Lista de actividades con títulos y descripciones únicas
  final List<Activity> activities = [
    Activity(
        title: 'Ciclismo por la montaña',
        description:
            'Explora rutas montañosas y disfruta de vistas espectaculares.'),
    Activity(
        title: 'Ciclismo urbano',
        description: 'Recorre la ciudad y descubre lugares nuevos.'),
    Activity(
        title: 'Ciclismo de ruta',
        description: 'Entrenamiento en carreteras largas y rectas.'),
    Activity(
        title: 'Ciclismo de montaña',
        description: 'Desafíos en terrenos irregulares y senderos.'),
    Activity(
        title: 'Ciclismo nocturno',
        description: 'Disfruta de paseos en bicicleta bajo la luna.'),
    Activity(
        title: 'Ciclismo de competición',
        description: 'Entrena para competencias y mejora tus habilidades.'),
    Activity(
        title: 'Ciclismo recreativo',
        description: 'Un paseo relajante para disfrutar con amigos.'),
    Activity(
        title: 'Ciclismo en grupo',
        description: 'Salidas organizadas con otros ciclistas.'),
    Activity(
        title: 'Ciclismo en familia',
        description: 'Paseos en bicicleta para toda la familia.'),
    Activity(
        title: 'Ciclismo de larga distancia',
        description: 'Desafía tus límites con rutas largas.'),
    Activity(
        title: 'Ciclismo de velocidad',
        description: 'Mejora tus tiempos en distancias cortas.'),
    Activity(
        title: 'Ciclismo en senderos',
        description: 'Explora caminos naturales y escénicos.'),
    Activity(
        title: 'Ciclismo por la costa',
        description: 'Disfruta de vistas al mar mientras pedaleas.'),
    Activity(
        title: 'Ciclismo en el parque',
        description: 'Relájate y pedalea en un ambiente tranquilo.'),
    Activity(
        title: 'Ciclismo con amigos',
        description: 'Diviértete mientras haces ejercicio en buena compañía.'),
    Activity(
        title: 'Ciclismo por la naturaleza',
        description: 'Conéctate con la naturaleza mientras pedaleas.'),
    Activity(
        title: 'Ciclismo en el campo',
        description: 'Explora caminos rurales y paisajes hermosos.'),
    Activity(
        title: 'Ciclismo en caminos de tierra',
        description: 'Desafía tu habilidad en terrenos de tierra.'),
    Activity(
        title: 'Ciclismo de montaña extremo',
        description: 'Para los aventureros que buscan retos extremos.'),
    Activity(
        title: 'Ciclismo para principiantes',
        description: 'Una introducción suave al ciclismo.'),
    Activity(
        title: 'Ciclismo de downhill',
        description: 'Descenso rápido en colinas y montañas.'),
    Activity(
        title: 'Ciclismo en climas fríos',
        description:
            'Disfruta del ciclismo en invierno con el equipo adecuado.'),
    Activity(
        title: 'Ciclismo con música',
        description: 'Escucha tu música favorita mientras pedaleas.'),
    Activity(
        title: 'Ciclismo por senderos forestales',
        description: 'Explora la tranquilidad de los bosques.'),
    Activity(
        title: 'Ciclismo en carreteras secundarias',
        description: 'Tranquilidad en rutas menos transitadas.'),
    Activity(
        title: 'Ciclismo en ferias locales',
        description: 'Visita ferias y mercados locales en bicicleta.'),
    Activity(
        title: 'Ciclismo por rutas históricas',
        description: 'Recorre caminos con historia y patrimonio.'),
    Activity(
        title: 'Ciclismo a lo largo de ríos',
        description: 'Disfruta de vistas panorámicas a lo largo de un río.'),
    Activity(
        title: 'Ciclismo de entrenamiento en intervalos',
        description: 'Mejora tu resistencia con entrenamientos de intervalos.'),
    Activity(
        title: 'Ciclismo de montaña en verano',
        description: 'Aprovecha el clima cálido para explorar senderos.'),
    Activity(
        title: 'Ciclismo con paradas',
        description: 'Disfruta de paradas en lugares interesantes.'),
    Activity(
        title: 'Ciclismo en eventos benéficos',
        description: 'Participa en eventos de ciclismo para una causa.'),
    Activity(
        title: 'Ciclismo en vacaciones',
        description: 'Explora nuevos lugares en bicicleta durante tus viajes.'),
    Activity(
        title: 'Ciclismo por la noche con luces',
        description: 'Asegúrate de ser visible mientras pedaleas de noche.'),
    Activity(
        title: 'Ciclismo con entrenamiento de fuerza',
        description: 'Combina ciclismo con ejercicios de fuerza.'),
    Activity(
        title: 'Ciclismo de aventura',
        description: 'Lleva tu bicicleta a nuevas aventuras y desafíos.'),
    Activity(
        title: 'Ciclismo en carreteras escénicas',
        description:
            'Disfruta de la belleza de la naturaleza mientras pedaleas.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Actividades de Ciclismo'),
        backgroundColor: Colors.black,
      ),
      body: Container(
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
        child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CheckboxListTile(
                title: Text(
                  activities[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  activities[index].description,
                  style: const TextStyle(color: Colors.white),
                ),
                value: activities[index].isCompleted,
                activeColor: Colors.green,
                checkColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    activities[index].isCompleted = value ?? false;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Clase para representar una actividad
class Activity {
  final String title;
  final String description;
  bool isCompleted;

  Activity({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
