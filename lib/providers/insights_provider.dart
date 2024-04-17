import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';

class InsightProvider extends ChangeNotifier {
  bool _loading = false;
  Map<String, dynamic> _userInsight = {};
  Map<String, dynamic> get userInsight => _userInsight;

  bool get loading => _loading;

  Future<void> fetchInsight() async {
    _loading = true;
    notifyListeners();
    _userInsight = await Service().fetchUserInsight();
    _loading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

