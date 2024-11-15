import 'package:flutter/material.dart';
import '/models/student.dart';

import '../../models/management.dart';
import '../../models/period.dart';
import '../../models/qualification.dart';
import '../../models/qualifications/qualifications.dart';
import '../../providers/qualifications/qualifications_provider.dart';
import '../../utils/my_snackbar.dart';

class QualificationsController {
  BuildContext? context;
  late Function refresh;

  Management? selectedManagement;
  Period? selectedPeriod;
  Student? selectedStudent;
  bool isLoading = false;

  final QualificationsProvider _qualificationsProvider = QualificationsProvider();

  // User? user;
  // final SharedPref _sharedPref = SharedPref();
  List<Qualification>? qualificationsRequest = [];
  Qualifications? qualificationsSubjectRequest;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _qualificationsProvider.init(context);
    // user = User.fromJson(await _sharedPref.read('user'));
    // qualificationsRequest = await getQualifications();
    // refresh();
  }

  Future<void> updateQualificationsSubject(
      int alumnoId, int gestionId, int periodoId) async {
    // await Future.delayed(const Duration(seconds: 1));
    qualificationsSubjectRequest =
        await getQualificationsSubject(alumnoId, gestionId, periodoId);
    refresh();
  }

  Future<Qualifications?> getQualificationsSubject(
      int alumnoId, int gestionId, int periodoId) async {
    final Qualifications? results = await _qualificationsProvider
        .getQualificationsSubject(alumnoId, gestionId, periodoId);
    refresh();
    return results;
  }

  void getQualificationsByStudent() {
    if (selectedStudent == null) {
      MySnackbar.show(context, 'Debe seleccionar un estudiante');
      return;
    } else if (selectedManagement == null) {
      MySnackbar.show(context, 'Debe seleccionar una gestión');
      return;
    }
    if (selectedPeriod == null) {
      MySnackbar.show(context, 'Debe seleccionar un periodo');
      return;
    }
    
    updateLoading(true);
    
    updateQualificationsSubject(
        selectedStudent!.id, selectedManagement!.id, selectedPeriod!.id).whenComplete(() => updateLoading(false));
  }
  
  void updateLoading(bool value) {
    isLoading = value;
    refresh();
  }
}
