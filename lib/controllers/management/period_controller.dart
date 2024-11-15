import 'package:flutter/material.dart';

import '../../models/period.dart';
import '../../providers/management/period_provider.dart';

class PeriodController {
  BuildContext? context;
  late Function refresh;

  final PeriodProvider _periodsProvider =
      PeriodProvider();
  List<Period>? periodsRequest = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _periodsProvider.init(context);
    periodsRequest = await getPeriods();
    refresh();
  }

  Future<void> updatePeriod() async {
    await Future.delayed(const Duration(seconds: 1));
    periodsRequest = await getPeriods();
    refresh();
  }

  Future<List<Period>?> getPeriods() async {
    final List<Period>? results = await _periodsProvider.getPeriods();
    refresh();
    return results;
  }

}
