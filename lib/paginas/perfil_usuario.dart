import 'package:flutter/material.dart';

class PerfilUsuario extends StatelessWidget {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Alineación centrada
              children: <Widget>[
                // Botón de regreso
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.orange),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Foto de perfil
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/perfil.jpg'), // Coloca la ruta de la imagen aquí
                ),
                SizedBox(height: 20),
                // Campos de perfil con etiquetas fuera de los recuadros
                labelYCampoPerfil('Nombre:', 'Juan Pérez'),
                SizedBox(height: 15),
                labelYCampoPerfil('Edad:', '30'),
                SizedBox(height: 15),
                labelYCampoPerfil('Sexo:', 'Masculino'),
                SizedBox(height: 15),
                labelYCampoPerfil('Peso:', '75 kg'),
                SizedBox(height: 15),
                labelYCampoPerfil('Estatura:', '1.80 m'),
                SizedBox(height: 30),
                // Campo de Expediente médico
                Text(
                  'Expediente médico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Caja de texto para el expediente médico
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 123, 0)
                        .withOpacity(0.9), // Color anaranjado traslúcido
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Historial médico del usuario...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir los campos del perfil con las etiquetas fuera de los recuadros
  Widget labelYCampoPerfil(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Alinea todo en el centro
      children: [
        // Etiqueta del campo
        Text(
          label,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(width: 10),
        // Contenedor del valor del campo
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign:
                  TextAlign.center, // Texto centrado dentro del contenedor
            ),
          ),
        ),
      ],
    );
  }
}
