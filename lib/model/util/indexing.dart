import 'package:flutter/material.dart';

class IndexChangeNotifier extends ChangeNotifier {
  int _index;
  IndexChangeNotifier(this._index);
  int get index => _index;
  void setIndex(index) {
    _index = index;
    notifyListeners();
  }
}
