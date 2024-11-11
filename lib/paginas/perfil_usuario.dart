import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/pantalla_principal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';

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
  File? _imageFile; // Para almacenar la imagen seleccionada

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
          _imageFile = snapshot.data()?['imageUrl'] != null
              ? File(snapshot.data()!['imageUrl'])
              : null; // Cargar la imagen desde Firestore
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

  Future<void> _pickImage() async {
    // Solicitar permisos
    PermissionStatus permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      // Permiso concedido, se puede acceder a la galería
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else if (permissionStatus.isDenied) {
      // Permiso denegado, mostrar alerta
      _showPermissionDeniedAlert();
    }
  }

  Future<void> _showPermissionDeniedAlert() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permiso Denegado'),
          content: const Text(
              'Para seleccionar una imagen, es necesario otorgar permiso de acceso a tus fotos.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Abrir la configuración para otorgar permisos
              },
              child: const Text('Ir a Configuración'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
    PermissionStatus permissionStatus = await Permission.photos.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.photos.request();
    }

    if (permissionStatus.isGranted) {
      // El permiso fue concedido completamente
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else {
      _showPermissionDeniedAlert();
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null; // Quitar la imagen del perfil
    });
  }

  Future<void> _eliminarCuenta() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('01')
            .doc(user.uid)
            .delete();
        await user.delete();

        // Mostrar un mensaje informando que la cuenta fue eliminada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta eliminada con éxito')),
        );

        // Mostrar la alerta de confirmación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cuenta eliminada'),
              content: const Text(
                  'Tu cuenta ha sido eliminada. Por favor, cierra sesión para salir.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navegar a la pantalla de inicio de sesión
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaPrincipal(
                          nombre: '',
                        ),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Deshabilitar toda la interfaz excepto el botón de cerrar sesión
        setState(() {
          // Puedes usar un estado booleano para deshabilitar otros botones
          // Por ejemplo, establecemos un flag "soloCerrarSesion" en true
          // que puedes usar para deshabilitar otros widgets.
          // Ejemplo:
          // soloCerrarSesion = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar la cuenta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        title: const Center(
          child: Text(
            '      Perfil usuario',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete,
                color: Color.fromARGB(255, 228, 25, 25)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Eliminar cuenta"),
                    content: const Text(
                        "¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                        },
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar el diálogo
                          _eliminarCuenta(); // Ejecutar la función de eliminación
                        },
                        child: const Text("Eliminar",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                    GestureDetector(
                      onTap: _modoEdicion
                          ? _pickImage
                          : null, // Solo permite seleccionar imagen en modo edición
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/perfil.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _crearCampoTexto('Nombre', _nombreController,
                        readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Edad', _edadController,
                        isNumber: true, maxLength: 3, readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Peso (Kg)', _pesoController,
                        isNumber: true, maxLength: 3, readOnly: !_modoEdicion),
                    const SizedBox(height: 10),
                    _crearCampoTexto('Estatura (Cm)', _estaturaController,
                        isNumber: true, maxLength: 3, readOnly: !_modoEdicion),
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
                        backgroundColor: const Color.fromARGB(255, 236, 193, 0),
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
                    const SizedBox(height: 10),
                    if (_modoEdicion && _imageFile != null)
                      ElevatedButton(
                        onPressed: _removeImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.black.withOpacity(0.5),
                          elevation: 10,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Quitar foto',
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        readOnly: readOnly,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly] // Solo permite números
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),

          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 102, 0), width: 2),
          ),
          counterText: '', // Oculta el contador de caracteres
        ),
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
      child: DropdownButtonFormField<String>(
        value: _sexo,
        onChanged: readOnly
            ? null
            : (newValue) {
                setState(() {
                  _sexo = newValue!;
                });
              },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 102, 0), width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        items: opciones.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _guardarPerfil() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('01').doc(user.uid).set(
          {
            'nombre': _nombreController.text,
            'edad': int.tryParse(_edadController.text),
            'peso': int.tryParse(_pesoController.text),
            'estatura': int.tryParse(_estaturaController.text),
            'sexo': _sexo,
            'imageUrl': _imageFile?.path, // Guardar la ruta de la imagen
          },
          SetOptions(merge: true), // Combina datos sin eliminar otros campos
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil guardado con éxito')),
        );
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
