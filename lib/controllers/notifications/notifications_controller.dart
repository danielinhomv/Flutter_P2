import 'package:flutter/material.dart';

import '../../models/notification.dart';
import '../../models/user.dart';
import '../../providers/notification/notification_provider.dart';
import '../../utils/shared_pref.dart';

class NotificationsController {
  BuildContext? context;
  late Function refresh;

  final NotificationsProvider _notificationsProvider =
      NotificationsProvider();
  User? user;
  final SharedPref _sharedPref = SharedPref();
  List<NotificationModel>? notificationsRequest = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _notificationsProvider.init(context);
    user = User.fromJson(await _sharedPref.read('user'));
    notificationsRequest = await getNotifications();
    refresh();
  }

  Future<void> updateNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    notificationsRequest = await getNotifications();
    refresh();
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final List<NotificationModel>? results = await _notificationsProvider.getNotifications(user!.userId);
    refresh();
    return results;
  }
  
  Future<void> registrarVisita(int comunicadoId) async {
    await _notificationsProvider.registrarVisita(comunicadoId,user!.userId);
    refresh();
  }
  // goToHomePage() {
  //   Navigator.pushNamed(context!, 'user/home');
  // }
}
