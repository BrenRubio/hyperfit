import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hyperfit/paginas/pantalla_principal.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart';
import 'package:flutter_hyperfit/paginas/registro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

        // Verificar si el token de acceso y el ID token no son nulos
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          User? user = userCredential.user;

          if (user != null) {
            // Verificar si el usuario ya existe en Firestore
            final userDoc =
                await _firestore.collection('01').doc(user.uid).get();

            if (!userDoc.exists) {
              // Si el usuario no existe, guardar la información del usuario en Firestore
              await _firestore.collection('01').doc(user.uid).set({
                'nombre': user.displayName ??
                    'Usuario', // Valor predeterminado si displayName es null
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
              String nombre = userDoc.get('nombre') ??
                  'Usuario'; // Valor predeterminado si es null
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaPrincipal(nombre: nombre),
                ),
              );
            }
          }
        } else {
          _showAlert('Error al obtener las credenciales de Google.');
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
          title: const Text('Recuperar contraseña'),
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            padding: const EdgeInsets.all(25.0),
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
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón para iniciar sesión con Google
                ElevatedButton.icon(
                  icon: const Icon(Icons.g_mobiledata),
                  onPressed: _signInWithGoogle,
                  label: const Text('Iniciar con Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 221, 39, 48),
                    foregroundColor: Colors.white,
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
                          onPressed: () async {
                            String email = _emailController.text;
                            if (email.isEmpty) {
                              _showAlert(
                                  'Por favor ingresa tu correo electrónico');
                              return;
                            }

                            try {
                              await _auth.sendPasswordResetEmail(email: email);
                              _showAlert(
                                  'Se ha enviado un correo para restablecer tu contraseña');
                            } catch (e) {
                              _showAlert(
                                  'Error al enviar el correo: ${e.toString()}');
                            }
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
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
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
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
      ),
    );
  }
}
