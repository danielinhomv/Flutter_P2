import 'package:flutter/material.dart';
import '/models/student.dart';

import '../../models/management.dart';
import '../../models/newsletter/newsletters.dart';
import '../../models/period.dart';
import '../../providers/newsletter/newsletters_provider.dart';
import '../../utils/my_snackbar.dart';

class NewsletterController {
  BuildContext? context;
  late Function refresh;

  Management? selectedManagement;
  Period? selectedPeriod;
  Student? selectedStudent;
  bool isLoading = false;

  final NewslettersProvider _qualificationsProvider = NewslettersProvider();

  // User? user;
  // final SharedPref _sharedPref = SharedPref();
  List<Newsletter>? newslettersRequest = [];
  Newsletter? newslettersSubjectRequest;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _qualificationsProvider.init(context);
    // user = User.fromJson(await _sharedPref.read('user'));
    // qualificationsRequest = await getNewsletter();
    // refresh();
  }

  Future<void> updateNewsletterSubject(
      int alumnoId, int gestionId, int periodoId) async {
    // await Future.delayed(const Duration(seconds: 1));
    newslettersSubjectRequest =
        await getNewsletterSubject(alumnoId, gestionId, periodoId);
    refresh();
  }

  Future<Newsletter?> getNewsletterSubject(
      int alumnoId, int gestionId, int periodoId) async {
    final Newsletter? results = await _qualificationsProvider
        .getNewsletters(alumnoId, gestionId, periodoId);
    refresh();
    return results;
  }

  void getNewsletterByStudent() {
    
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
    
    updateNewsletterSubject(
        selectedStudent!.id, selectedManagement!.id, selectedPeriod!.id).whenComplete(() => updateLoading(false));
  }
  
  void updateLoading(bool value) {
    isLoading = value;
    refresh();
  }
}
