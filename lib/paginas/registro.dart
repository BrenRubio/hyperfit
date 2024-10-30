import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hyperfit/paginas/inicio_sesion.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart'; // Importar la pantalla de perfil_usuario

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;

  // Función para validar el formato del correo electrónico
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Función para validar la contraseña
  bool _isValidPassword(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> _register() async {
    // Validar campos vacíos
    if (_nameController.text.trim().isEmpty) {
      _showAlert('El nombre es obligatorio');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showAlert('El correo electrónico es obligatorio');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showAlert('La contraseña es obligatoria');
      return;
    }
    if (_confirmPasswordController.text.trim().isEmpty) {
      _showAlert('Debes confirmar tu contraseña');
      return;
    }

    // Validar formato de correo electrónico
    if (!_isValidEmail(_emailController.text.trim())) {
      _showAlert('Por favor, ingresa un correo electrónico válido');
      return;
    }

    // Validar requisitos de la contraseña
    if (!_isValidPassword(_passwordController.text.trim())) {
      _showAlert(
          'La contraseña debe tener al menos 8 caracteres, una mayúscula y un símbolo');
      return;
    }

    // Validar coincidencia de contraseñas
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showAlert('Las contraseñas no coinciden');
      return;
    }

    try {
      // Registrar usuario con Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Guardar la información del usuario en Firestore
      await _firestore.collection('01').doc(userCredential.user?.uid).set({
        'nombre': _nameController.text.trim(),
        'correo': _emailController.text.trim(),
      });

      // Redirige a la pantalla de perfil_usuario, pasando el nombre
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PerfilUsuario(nombre: _nameController.text.trim()),
        ),
      );
    } catch (e) {
      _showAlert('Error al registrar: ${e.toString()}');
    }
  }

  // Método para mostrar alertas
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Asegura que el contenido se ajusta cuando el teclado está abierto
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        // Añadido SafeArea
        child: SingleChildScrollView(
          // Envuelve el contenido en SingleChildScrollView
          child: Container(
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
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                // Asegura que el Column ocupe el espacio mínimo
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Campo de nombre
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nombre',
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    // Campo de correo
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    // Campo de contraseña
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo de confirmar contraseña
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar Contraseña',
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Botón de Registrarse
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
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
                          'Registrarse',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón de Cancelar
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const inicio_sesion()), // Navegar a Registro
                        );
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Cancelar'),
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

  // Método para construir campos de texto reutilizables
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
