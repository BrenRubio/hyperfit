import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/pantalla_principal.dart'; // Importa tu pantalla principal

class PerfilUsuario extends StatefulWidget {
  final String nombre; // Recibir nombre como parámetro

  PerfilUsuario({required this.nombre}); // Constructor

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  late TextEditingController _nombreController;
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  String _sexo = 'Masculino'; // Valor predeterminado

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador del nombre con el nombre que se pasó desde el registro
    _nombreController = TextEditingController(text: widget.nombre);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    super.dispose();
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/perfil.jpg'),
                ),
                SizedBox(height: 20),
                _crearCampoTexto('Nombre', _nombreController), // Nombre autocompletado
                SizedBox(height: 15),
                _crearCampoTexto('Edad', _edadController, isNumber: true),
                SizedBox(height: 15),
                _crearCampoTexto('Peso (kg)', _pesoController, isNumber: true),
                SizedBox(height: 15),
                _crearCampoTexto('Estatura (m)', _estaturaController, isNumber: true),
                SizedBox(height: 15),
                _crearCampoDropdown('Sexo', ['Masculino', 'Femenino']),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _guardarPerfil();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text('Guardar Perfil', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearCampoTexto(String label, TextEditingController controller, {bool isNumber = false}) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _crearCampoDropdown(String label, List<String> opciones) {
    return Container(
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _sexo,
        onChanged: (String? nuevoValor) {
          setState(() {
            _sexo = nuevoValor!;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        items: opciones
            .map((opcion) => DropdownMenuItem<String>(
                  value: opcion,
                  child: Text(opcion, style: TextStyle(color: Colors.black)),
                ))
            .toList(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> _guardarPerfil() async {
    // Validar campos vacíos
    if (_nombreController.text.isEmpty) {
      _showAlert('El nombre es obligatorio');
      return;
    }
    if (_edadController.text.isEmpty) {
      _showAlert('La edad es obligatoria');
      return;
    }
    if (_pesoController.text.isEmpty) {
      _showAlert('El peso es obligatorio');
      return;
    }
    if (_estaturaController.text.isEmpty) {
      _showAlert('La estatura es obligatoria');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('01').doc(user.uid).set({
          'correo': user.email,
          'nombre': _nombreController.text,
          'edad': int.parse(_edadController.text),
          'peso': double.parse(_pesoController.text),
          'estatura': double.parse(_estaturaController.text),
          'sexo': _sexo,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil guardado correctamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaPrincipal(nombre: _nombreController.text),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el perfil: $e')),
      );
    }
  }

  // Método para mostrar alertas
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
