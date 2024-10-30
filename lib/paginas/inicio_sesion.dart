import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/pantalla_principal.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart';
import 'package:flutter_hyperfit/paginas/registro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Importa Google Sign-In

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const inicio_sesion());
}

class inicio_sesion extends StatelessWidget {
  const inicio_sesion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InicioSesion(),
    );
  }
}

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función para iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Verificar si el usuario ya existe en Firestore
          final userDoc = await _firestore.collection('01').doc(user.uid).get();

          if (!userDoc.exists) {
            // Si el usuario no existe, guardar la información del usuario en Firestore
            await _firestore.collection('01').doc(user.uid).set({
              'nombre': user.displayName,
              'correo': user.email,
            });

            // Redirigir a la pantalla de crear perfil, pasando el nombre de Google
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PerfilUsuario(
                  nombre: user.displayName ?? '',
                ),
              ),
            );
          } else {
            // Si el usuario ya existe, redirigir a la pantalla principal
            String nombre = userDoc.get('nombre');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaPrincipal(nombre: nombre),
              ),
            );
          }
        }
      }
    } catch (e) {
      _showAlert('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Obtener el nombre del usuario desde Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('01').doc(user.uid).get();
        String nombre = userDoc.get('nombre');

        // Redirigir a la pantalla principal pasando el nombre
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaPrincipal(nombre: nombre),
          ),
        );
      }
    } catch (e) {
      _showAlert(
          'Datos incorrectos. Por favor, verifica tu correo y contraseña.');
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Inicio de Sesión',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              // Campo de correo
              Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de contraseña
              Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 255, 123, 0).withOpacity(0.9),
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
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 10,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botón para iniciar sesión con Google
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                onPressed: _signInWithGoogle,
                label: const Text('Iniciar sesión con Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Olvidaste contraseña
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Registro(),
                            ),
                          );
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        child: const Text('Registrarse'),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
