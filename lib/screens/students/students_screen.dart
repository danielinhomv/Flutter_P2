import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../controllers/students/students_controller.dart';
import '../../models/student.dart';
import '../../utils/my_colors.dart';

class StudentsListScreen extends StatefulWidget {
  final bool isNewsletter;

  const StudentsListScreen({super.key, required this.isNewsletter});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final StudentsController _con = StudentsController();
  late bool isNewsletter;

  @override
  void initState() {
    super.initState();
    isNewsletter = widget.isNewsletter;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Student>? studentsRequest;

    final Future<List<Student>?> requests = Future<List<Student>?>.delayed(
      const Duration(seconds: 1),
      () {
        studentsRequest = _con.studentsRequest;
        return studentsRequest;
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(isNewsletter ? 'Boletines' : 'Calificaciones'),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyColors.primaryColor,
        strokeWidth: 4.0,
        onRefresh: _con.updateStudents,
        child: FutureBuilder<List<Student>?>(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error al cargar las solicitudes',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay solicitudes disponibles.',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Seleccione un estudiante:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _cardStudentRequest(
                            snapshot.data![index], index);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _cardStudentRequest(Student? request, index) {
    return GestureDetector(
      onTap: () {
        
        if (isNewsletter) {
          Navigator.pushNamed(
            context,
            'home/students/newsletters',
            arguments: {
              'student': request,
            },
          );
        } else {
          Navigator.pushNamed(
            context,
            'home/students/qualifications',
            arguments: {
              'student': request,
            },
          );
        }
        
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.1), // Color de la sombra con opacidad
              spreadRadius: 1, // Extensión de la sombra
              blurRadius: 5, // Radio de desenfoque de la sombra
              offset: const Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                // margin: const EdgeInsets.only(top: 10),
                height: 140,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/img/placeholder-image.png'),
                          image: request?.foto != null
                              ? NetworkImage(request!.foto!)
                              : const AssetImage(
                                      'assets/img/placeholder-image.png')
                                  as ImageProvider,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 200,
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            width: double.infinity,
                            child: Wrap(
                              children: [
                                const Text(
                                  'Nombre: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.nombre}',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: Wrap(
                              children: [
                                const Text(
                                  'Apellido: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.apellidos}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
