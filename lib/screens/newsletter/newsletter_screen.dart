import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/utils/my_colors.dart';

import '../../controllers/management/management_controller.dart';
import '../../controllers/management/period_controller.dart';
import '../../controllers/newsletter/newsletter_controller.dart';
import '../../models/management.dart';
import '../../models/newsletter/average_subject.dart';
import '../../models/newsletter/newsletters.dart';
import '../../models/period.dart';
import '../../models/student.dart';

class NewsletterScreen extends StatefulWidget {
  final Student student;

  const NewsletterScreen({super.key, required this.student});

  @override
  State<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  final PeriodController _periodController = PeriodController();
  final ManagementController _managementController = ManagementController();
  final NewsletterController _newslettersController = NewsletterController();

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _periodController.init(context, refresh);
      _managementController.init(context, refresh);
      _newslettersController.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Period>? periods = _periodController.periodsRequest;
    List<Management>? managements = _managementController.managementsRequest;
    Newsletter? newslettersRequest;

    _newslettersController.selectedStudent = widget.student;

    final Future<Newsletter?> newslettersResponse = Future<Newsletter?>.delayed(
      const Duration(seconds: 1),
      () {
        newslettersRequest = _newslettersController.newslettersSubjectRequest;
        return newslettersRequest;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletines de calificaciones'),
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
                _newslettersController.isLoading
                    ? const Center(
                        heightFactor: 3,
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder<Newsletter?>(
                        future: newslettersResponse,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              heightFactor: 3,
                              // child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            return buildNotasList(snapshot.data!);
                          } else {
                            return const Center(
                              heightFactor: 5,
                              child: Text("No hay resultados"),
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
                value: _newslettersController.selectedPeriod,
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
                    _newslettersController.selectedPeriod = newValue;
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
                value: _newslettersController.selectedManagement,
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
                    _newslettersController.selectedManagement = newValue;
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
        onPressed: _newslettersController.getNewsletterByStudent,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text('Obtener Boletin'),
      ),
    );
  }

  Widget buildNotasList(Newsletter boletin) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.primarySwatch[50],
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
                    'BOLETIN DE NOTAS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'ESTUDIANTE: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      Text(
                        boletin.alumno.toUpperCase(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'CURSO: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      Text(
                        boletin.curso.toUpperCase(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'PERIODO: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      Text(
                        boletin.periodo.toUpperCase(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'GESTIÓN: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      Text(
                        boletin.gestion.toUpperCase(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Table(
              border: TableBorder.all(color: MyColors.primaryColor, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'ÁREAS CURRICULARES',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'PROMEDIO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                for (var materia in boletin.materiasPromedio)
                  _buildTableRow(materia),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'PROMEDIO FINAL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        boletin.promedioGeneral.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(AverageSubject materia) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(materia.materia.toUpperCase()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            materia.promedioMateria.toStringAsFixed(1),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
