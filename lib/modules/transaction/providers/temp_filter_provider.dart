import 'package:flutter/material.dart';

class TempFilterProvider extends ChangeNotifier {
  DateTime? _tempDate;
  bool? _isNewest;

  DateTime? get tempDate => _tempDate;
  set tempDate(DateTime? date) {
    _tempDate = date;
    notifyListeners();
  }

  bool? get isNewest => _isNewest;
  set isNewest(bool? newest) {
    _isNewest = newest;
    notifyListeners();
  }
}
