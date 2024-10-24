import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hyperfit/paginas/pantalla_principal.dart';
// Para los inputFormatters

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key, required String nombre});

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  String _sexo = 'Masculino'; // Valor predeterminado
  bool _modoEdicion = false; // Controla si se puede editar o no

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil(); // Carga los datos al iniciar la pantalla
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarDatosPerfil(); // Carga los datos cada vez que se muestra la pantalla
  }

  Future<void> _cargarDatosPerfil() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('01')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          // Asigna los valores a los controladores
          _nombreController.text = snapshot.data()?['nombre'] ?? '';
          _edadController.text = snapshot.data()?['edad']?.toString() ?? '';
          _pesoController.text = snapshot.data()?['peso']?.toString() ?? '';
          _estaturaController.text =
              snapshot.data()?['estatura']?.toString() ?? '';
          _sexo = snapshot.data()?['sexo'] ?? 'Masculino';
          setState(() {}); // Refresca la UI

          // Muestra un mensaje indicando que se necesita modificar el perfil
          if (_nombreController.text.isEmpty ||
              _edadController.text.isEmpty ||
              _pesoController.text.isEmpty ||
              _estaturaController.text.isEmpty) {
            _mostrarAlerta();
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar el perfil')),
      );
    }
  }

  void _mostrarAlerta() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Perfil incompleto'),
          content: const Text(
              'Por favor, modifica tu perfil para completar tu cuenta.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        title: const Center(
          child: Text(
            'Perfil usuario',
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 2),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/perfil.png'),
                    ),
                    const SizedBox(height: 20),
                    _crearCampoTexto('Nombre', _nombreController,
                        readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Edad', _edadController,
                        isNumber: true, maxLength: 3, readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Peso (Kg)', _pesoController,
                        isNumber: true, maxLength: 4, readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Estatura (Mtrs)', _estaturaController,
                        isNumber: true, maxLength: 4, readOnly: !_modoEdicion),
                    const SizedBox(height: 5),
                    _crearCampoDropdown('Sexo', ['Masculino', 'Femenino'],
                        readOnly: !_modoEdicion),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _modoEdicion
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                _guardarPerfil();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _modoEdicion ? Colors.blue[900] : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadowColor: Colors.black.withOpacity(0.5),
                        elevation: 10,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          'Guardar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _modoEdicion = !_modoEdicion;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 236, 193, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadowColor: Colors.black.withOpacity(0.5),
                        elevation: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text(
                          _modoEdicion ? 'Cancelar' : 'Modificar',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearCampoTexto(String label, TextEditingController controller,
      {bool isNumber = false, bool readOnly = false, int? maxLength}) {
    return Container(
      width: double.infinity,
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        readOnly: readOnly,
        inputFormatters: isNumber
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ]
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _crearCampoDropdown(String label, List<String> opciones,
      {bool readOnly = false}) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        value: _sexo,
        isExpanded: true,
        dropdownColor: const Color.fromARGB(255, 18, 40, 51),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        items: opciones
            .map((opcion) => DropdownMenuItem(
                  value: opcion,
                  child:
                      Text(opcion, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: readOnly
            ? null
            : (value) {
                setState(() {
                  _sexo = value!;
                });
              },
        validator: (value) {
          if (value == null) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _guardarPerfil() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('01').doc(user.uid).set({
          'nombre': _nombreController.text,
          'edad': int.tryParse(_edadController.text),
          'peso': int.tryParse(_pesoController.text),
          'estatura': int.tryParse(_estaturaController.text),
          'sexo': _sexo,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil guardado')),
        );

        // Navega a la Pantalla Principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const PantallaPrincipal(
                    nombre: '',
                  )),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el perfil')),
      );
    }
  }
}
