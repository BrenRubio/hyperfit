import 'package:flutter/material.dart';
import 'package:flutter_hyperfit/paginas/perfil_usuario.dart';
import 'package:flutter_hyperfit/paginas/registro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InicioSesion(),
    );
  }
}

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Inicio de Sesión',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 60),
              // Campo de correo con estilo de cristal anaranjado traslúcido
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 123, 0)
                      .withOpacity(0.9), // Color anaranjado traslúcido
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18), // Tamaño de la caja
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Campo de contraseña con estilo de cristal anaranjado traslúcido
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 123, 0)
                      .withOpacity(0.9), // Color anaranjado traslúcido
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18), // Tamaño de la caja
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
              // Botón estilizado con sombra y bordes redondeados
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilUsuario()),
                  );
                  // Aquí se puede manejar la lógica de inicio de sesión
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900], // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 10, // Sombra del botón
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra los textos
                children: [
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centra verticalmente
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navegar a pantalla de "Olvidaste tu contraseña"
                        },
                        child: Text('¿Olvidaste tu contraseña?'),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Registro()), // Navega a InicioSesion
                          );
                          // Navegar a pantalla de "Registrarse"
                        },
                        child: Text('Registrarse'),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
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
