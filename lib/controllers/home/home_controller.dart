import 'package:flutter/material.dart';

import '../../models/count_notifications_students.dart';
import '../../models/user.dart';
import '../../providers/home/home_provider.dart';
import '../../utils/shared_pref.dart';

class HomeController {
  BuildContext? context;
  final SharedPref _sharedPref = SharedPref();
  late Function refresh;
  User? user;

  final HomeProvider _homeProvider = HomeProvider();
  CountNotificationsStudents? countNotificationsStudentsRequest;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _homeProvider.init(context);
    user = User.fromJson(await _sharedPref.read('user'));
    countNotificationsStudentsRequest = await getCountNotificationsStudents();
    refresh();
  }

  logout() {
    _sharedPref.logout(context!);
  }
  
  Future<void> updateCountNotificationsStudents() async {
    await Future.delayed(const Duration(seconds: 1));
    countNotificationsStudentsRequest = await getCountNotificationsStudents();
    refresh();
  }

  Future<CountNotificationsStudents?> getCountNotificationsStudents() async {
    final results =
        await _homeProvider.getCountNotificationsStudents(user!.userId);
    refresh();
    return results;
  }

  goToStudentsScreen() {
    updateCountNotificationsStudents();
    // Navigator.pop(context!); // Cierra el Drawer
    Navigator.pushNamed(
      context!,
      'home/students',
      arguments: {
        'isNewsletter': false,
      },
    );
  }

  goToNewsletterScreen() {
    updateCountNotificationsStudents();
    // Navigator.pop(context!); // Cierra el Drawer
    Navigator.pushNamed(
      context!,
      'home/students',
      arguments: {
        'isNewsletter': true,
      },
    );
  }

  goToHomeScreen() {
    updateCountNotificationsStudents();
    Navigator.pop(context!); // Cierra el Drawer
    // Navigator.pushNamed(context!, 'home');
  }

  goToNotificationsScreen() {
    updateCountNotificationsStudents();
    // Navigator.pop(context!); // Cierra el Drawer
    Navigator.pushNamed(context!, 'home/notifications');
  }
}
