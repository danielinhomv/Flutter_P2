import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/utils/my_colors.dart';
import '../../controllers/management/management_controller.dart';
import '../../controllers/management/period_controller.dart';
import '../../controllers/qualifications/qualifications_controller.dart';
import '../../models/management.dart';
import '../../models/period.dart';
import '../../models/qualifications/qualifications.dart';
import '../../models/qualifications/subject.dart';
import '../../models/student.dart';

class QualificationScreen extends StatefulWidget {
  final Student student;

  const QualificationScreen({super.key, required this.student});

  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  final PeriodController _periodController = PeriodController();
  final ManagementController _managementController = ManagementController();
  final QualificationsController _qualificationsController =
      QualificationsController();

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _periodController.init(context, refresh);
      _managementController.init(context, refresh);
      _qualificationsController.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Period>? periods = _periodController.periodsRequest;
    List<Management>? managements = _managementController.managementsRequest;
    Qualifications? qualificationsRequest;

    _qualificationsController.selectedStudent = widget.student;

    final Future<Qualifications?> qualificationsResponse =
        Future<Qualifications?>.delayed(
      const Duration(seconds: 1),
      () {
        qualificationsRequest =
            _qualificationsController.qualificationsSubjectRequest;
        return qualificationsRequest;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
      ),
      body: SizedBox(
        width: double.infinity, // Ocupar todo el ancho
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                _dropDownManagements(managements),
                const SizedBox(height: 10),
                _dropDownPeriods(periods),
                const SizedBox(height: 10),
                _buttonSend(),
                const SizedBox(height: 10),
                _qualificationsController.isLoading
                    ? const Center(
                        heightFactor: 3,
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder<Qualifications?>(
                        future: qualificationsResponse,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              heightFactor: 3,
                              child:
                                  _qualificationsController.isLoading == false
                                      ? const CircularProgressIndicator()
                                      : null,
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.materias.isEmpty) {
                              return const Center(
                                heightFactor: 5,
                                child: Text(
                                    "No hay resultados",
                                    style: TextStyle(fontSize: 15),
                                  ),
                              );
                            }
                            return buildNotasList(snapshot.data!.materias);
                          } else {
                            return const Center(
                              heightFactor: 5,
                              // child: Text("No hay resultados"),
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropDownPeriods(List<Period>? periods) {
    return Material(
      elevation: 2.0,
      color: MyColors.primarySwatch[50],
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.search,
                  color: MyColors.primaryColor,
                ),
                const SizedBox(width: 15),
                Text(
                  'Períodos',
                  style: TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<Period>(
                value: _qualificationsController.selectedPeriod,
                underline: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_drop_down_circle,
                    color: MyColors.primaryColor,
                  ),
                ),
                elevation: 3,
                isExpanded: true,
                hint: Text(
                  'Seleccione un período',
                  style: TextStyle(color: MyColors.primaryColor, fontSize: 16),
                ),
                items: periods?.map((Period? period) {
                  return DropdownMenuItem<Period>(
                      value: period, child: Text(period?.descripcion ?? ''));
                }).toList(),
                onChanged: (Period? newValue) {
                  setState(() {
                    _qualificationsController.selectedPeriod = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownManagements(List<Management>? managements) {
    return Material(
      elevation: 2.0,
      color: MyColors.primarySwatch[50],
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.search,
                  color: MyColors.primaryColor,
                ),
                const SizedBox(width: 15),
                Text(
                  'Gestiones',
                  style: TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<Management>(
                value: _qualificationsController.selectedManagement,
                underline: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_drop_down_circle,
                    color: MyColors.primaryColor,
                  ),
                ),
                elevation: 3,
                isExpanded: true,
                hint: Text(
                  'Seleccione una gestión',
                  style: TextStyle(color: MyColors.primaryColor, fontSize: 16),
                ),
                items: managements?.map((Management? management) {
                  return DropdownMenuItem<Management>(
                      value: management, child: Text(management?.year ?? ''));
                }).toList(),
                onChanged: (Management? newValue) {
                  setState(() {
                    _qualificationsController.selectedManagement = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSend() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _qualificationsController.getQualificationsByStudent,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text('Obtener calificaciones'),
      ),
    );
  }

  Widget buildNotasList(List<Subject> materias) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:
              materias.map((materia) => buildMateriaTable(materia)).toList(),
        ),
      ),
    );
  }

  Widget buildMateriaTable(Subject materia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: MyColors.primarySwatch[50],
            // border: Border.all(color: MyColors.primaryColor, width: 1),
            border: Border(
              top: BorderSide(color: MyColors.primaryColor, width: 1),
              left: BorderSide(color: MyColors.primaryColor, width: 1),
              right: BorderSide(color: MyColors.primaryColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                materia.materia,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColors.primaryColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profesor/a: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    materia.details.isNotEmpty
                        ? materia.details.first.profesor
                        : '',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: MyColors.primaryColor, width: 1),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            // TableRow(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(8.0),
            //       child: const Text('Profesor'),
            //     ),
            //     Container(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         materia.details.isNotEmpty
            //             ? materia.details.first.profesor
            //             : '',
            //       ),
            //     ),
            //   ],
            // ),
            ...materia.details.map((calificacion) {
              return TableRow(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(calificacion.descripcion),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      calificacion.nota.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }).toList(),
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Promedio'.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    materia.promedioMateria.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20), // Espacio entre las tablas
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
