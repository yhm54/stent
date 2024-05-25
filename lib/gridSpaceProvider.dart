// ignore_for_file: unnecessary_this, unused_import

// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stent/grid_spaces.dart';

class GSProvider extends ChangeNotifier {
  String _id = '';
  String _sN = '';
  String _pw = '';
  int _cols = 5;

  List _counterPositions = [];

  int _positionForEntry = 0;

  List<GridSpace> _gridMap = [];

  List _selGS = [];

  // List<List> _selGSInventory = [];

  bool first = true;

  List help = [];

  void addCounterPosition() {
    _counterPositions.add(9999);
    notifyListeners();
  }

  void removeCounterPosition() {
    _counterPositions.length != 0 ? _counterPositions.removeLast() : ();
    notifyListeners();
  }

  void removeSelGS(int x) {
    print('running');
    var index = _gridMap.indexWhere((element) => element.i == x);
    print(index);
    _gridMap[index] = GridSpace(
      index,
      Colors.white,
      Colors.blue[900]!,
    );
    _selGS.removeWhere((element) => element['key'] == x);
    notifyListeners();
  }

  void setCounterPositions(int x) {
    print('running');
    _counterPositions[
        _counterPositions.lastIndexWhere((element) => element == 9999)] = x;
    notifyListeners();
  }

  List get counterPositions {
    return _counterPositions;
  }

  int get cols {
    if (first) {
      createGridMap();
      first = false;
    }

    // createGridMap(_cols);
    return _cols;
  }

  void setPosition(int pos) {
    _positionForEntry = pos;
  }

  void setId(String str) {
    _id = str;
  }

  void setSN(String str) {
    _sN = str;
  }

  void setPw(String str) {
    _pw = str;
  }

  String get id {
    return _id;
  }

  int get positionForEntry {
    return _positionForEntry;
  }

  String get sN {
    return _sN;
  }

  String get pw {
    return _pw;
  }

  void createGridMap() {
    _gridMap = [];
    for (int i = 0; i < (_cols * _cols); i++) {
      _gridMap.add(
        GridSpace(
          i,
          Colors.white,
          Colors.blue[900]!,
        ),
      );
    }
    // notifyListeners();
  }

  List<GridSpace> get gridMap {
    return _gridMap;
  }

  void incrementCols() {
    _cols > 25 ? () : _cols++;
    _selGS = [];

    _gridMap = [];
    _counterPositions = [];

    createGridMap();
    notifyListeners();
  }

  void decrementCols() {
    _cols <= 1 ? () : _cols--;
    _selGS = [];
    _gridMap = [];
    _counterPositions = [];
    createGridMap();
    notifyListeners();
  }

  void reset() {
    String _id = '';
    String _sN = '';
    String _pw = '';
    int _cols = 5;

    List _counterPositions = [];

    int _positionForEntry = 0;

    List<GridSpace> _gridMap = [];

    List _selGS = [];

    // List<List> _selGSInventory = [];

    bool first = true;
  }

  void changeGS(int key) {
    var index = _gridMap.indexWhere((element) => element.i == key);
    _gridMap[index] =
        GridSpace(key, Color.fromARGB(107, 41, 130, 203), Colors.white);
    _selGS.add(
      {
        'key': key,
        'list': [],
        'category': '',
      },
    );
    notifyListeners();
    // print(_selGS);
  }

  void addCategory(key, category) {
    var index = _selGS.indexWhere((element) => element['key'] == key);
    _selGS[index]['category'] = category;
    notifyListeners();
  }

  void addInventory(int key, String itemName, int count, String category) {
    _selGS.indexWhere((element) => element['key'] == key) != -1
        ? _selGS[_selGS.indexWhere((element) => element['key'] == key)]['list']
            .add(
            {
              'itemNo':
                  _selGS[_selGS.indexWhere((element) => element['key'] == key)]
                          ['list']
                      .length,
              'name': itemName,
              'count': count,
              'description': [],
            },
          )
        : _selGS.add({
            'key': key,
            'list': [
              {
                'itemNo': 0,
                'name': itemName,
                'count': count,
                'description': [],
              }
            ],
            'category': category,
          });
  }

  List get selGS {
    return _selGS;
  }

  bool isSel(int b) {
    for (int i = 0; i < _selGS.length; i++) {
      if (_selGS[i]['key'] == b) {
        return true;
      }
    }
    ;
    return false;
  }

  int indexOfInSelGS(int x) {
    for (var i = 0; i < _selGS.length; i++) {
      if (_selGS[i]['key'] == x) {
        return i;
      }
    }
    ;
    return -1;
  }

  // void addInventory(int i, String s) {
  //   _selGS[_selGS.indexOf((element) => element['key'] == i)]['list'].add({});
  //   print(_selGS);
  // }

  void addSpaceforNewInventory(int i) {
    // print(i);
    var f;

    for (int j = 0; j < _selGS.length; j++) {
      if (_selGS[j]['key'] == i) {
        f = j;
      }
    }

    _selGS[f]['list'].add({
      'itemNo': _selGS[f]['list'].length,
      'name': String,
      'count': 0,
      'description': [],
      // 'price': int,
      // 'description': []
    });
    notifyListeners();
  }

  void addDescription() {}

  void incrementCount(int x, int y) {
    var ind = indexOfInSelGS(x);
    _selGS[ind]['list'][y]['count']++;
    notifyListeners();
  }

  void decrementCount(int x, int y) {
    var ind = indexOfInSelGS(x);

    _selGS[ind]['list'][y]['count']--;
    notifyListeners();
  }

  void addItem(int x, int y, String s) {
    var ind = indexOfInSelGS(x);

    _selGS[ind]['list'][y]['name'] = s;
    // print(_selGS[ind]['list'][y]);
    notifyListeners();
  }

  String getCategory(int x) {
    var ind = indexOfInSelGS(x);
    return _selGS[ind]['category'];
  }

  // void addDescription
}
