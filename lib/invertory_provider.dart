import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:stent/grid_spaces.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryProvider extends ChangeNotifier {
  final url = Uri.https(
    'stent-ebe62-default-rtdb.firebaseio.com',
    'stent-db.json',
  );
  // var response = http.get(url);
}
