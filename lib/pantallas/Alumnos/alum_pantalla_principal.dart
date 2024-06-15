

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/curso_widget.dart';
import 'package:http/http.dart' as http;

import '../../widgets/custom_navigationbar.dart';
import '../../widgets/random_lightcolor.dart';


class EstMainMenuScreen extends StatefulWidget {
  const EstMainMenuScreen({super.key});

  @override
  State<EstMainMenuScreen> createState() => _EstMainMenuScreenState();
}

class _EstMainMenuScreenState extends State<EstMainMenuScreen> {

  String _nombre = "";
  List<dynamic> _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchCoursedta();

  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://kunan.onrender.com/usuario_info/info/OuVmuk1gaojmulu9AnhQ'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombre = data['nombres'];
          _isLoading = false;
        });
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  Future<void> _fetchCoursedta() async {
    try {
      final response = await http.get(
        Uri.parse('https://kunan.onrender.com/usuario_info/user/OuVmuk1gaojmulu9AnhQ'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final courses = data['cursos'] as List<dynamic>;
        final courseNames = courses.map((course) => course['nombre'].toString()).toList();
        setState(() {
          _cursos = courseNames;
          _isLoading = false;
          print(_cursos);
        });
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        color: const Color.fromRGBO(1,6,24,1),
        child: Column(
          children: [
            //LOGO
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/imagenes/sombrero-de-graduacion.png'),
                        ),
                        const Text(
                          'Kunan',
                          style: TextStyle(
                            fontSize: 50,
                            color: Color.fromRGBO(178,219,144,1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),


            Column(
              children: [

                //BIENVENIDA
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¡Hola!',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _nombre,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      width: 115,
                      height: 115,
                      child: Image.asset('assets/imagenes/fotoperfil2.png'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //EN CURSO
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En Curso',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(178,219,144,1),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),

                    CursoWidget(
                      curso: 'Taller de Software Movil',
                      siglas: 'TM',
                      color: Color.fromRGBO(255,194,120,1),
                      estado: 'Asistencia',
                      usuario: 'Alumno',
                    ),

                  ],
                ),

                const SizedBox(height: 30),

                //MIS CURSOS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ' Mis Cursos',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(178,219,144,1),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: 410,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _cursos.length,
                          itemBuilder: (context, index) {
                          final cursoNombre = _cursos[index];
                          final siglas = cursoNombre.substring(0, 2).toUpperCase();
                          final Color color = getRandomLightColor();
                          const estado = 'Sin estado';
                          const usuario = 'Alumno';
                        
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CursoWidget(
                                curso: cursoNombre,
                                siglas: siglas,
                                color: color,
                                estado: estado,
                                usuario: usuario,
                            ),
                          );
                        },
                        ),
                      ),

                  ],
                ),

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Alumno',
      ),
    );
  }
}
