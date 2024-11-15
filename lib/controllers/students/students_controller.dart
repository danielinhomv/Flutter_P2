import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../../models/user.dart';
import '../../providers/students/students_provider.dart';
import '../../utils/shared_pref.dart';

class StudentsController {
  BuildContext? context;
  late Function refresh;

  final StudentsProvider _studentsProvider =
      StudentsProvider();
  User? user;
  final SharedPref _sharedPref = SharedPref();
  List<Student>? studentsRequest = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _studentsProvider.init(context);
    user = User.fromJson(await _sharedPref.read('user'));
    studentsRequest = await getStudents();
    refresh();
  }

  Future<void> updateStudents() async {
    await Future.delayed(const Duration(seconds: 1));
    studentsRequest = await getStudents();
    refresh();
  }

  Future<List<Student>?> getStudents() async {
    final List<Student>? results = await _studentsProvider.getStudents(user!.userId);
    refresh();
    return results;
  }

  // goToRegisterStudentsPage() {
  //   Navigator.pushNamed(context!, 'user/home/request/create');
  // }

  // goToHomePage() {
  //   Navigator.pushNamed(context!, 'user/home');
  // }
}
