import 'package:flutter/material.dart';

import '../../models/management.dart';
import '../../providers/management/management_provider.dart';

class ManagementController {
  BuildContext? context;
  late Function refresh;

  final ManagementProvider _managementsProvider =
      ManagementProvider();
  List<Management>? managementsRequest = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _managementsProvider.init(context);
    managementsRequest = await getManagement();
    refresh();
  }

  Future<void> updateManagement() async {
    await Future.delayed(const Duration(seconds: 1));
    managementsRequest = await getManagement();
    refresh();
  }

  Future<List<Management>?> getManagement() async {
    final List<Management>? results = await _managementsProvider.getManagements();
    refresh();
    return results;
  }

}
