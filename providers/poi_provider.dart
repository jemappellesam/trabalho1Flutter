import 'package:flutter/material.dart';
import '../models/poi.dart';

class POIProvider extends ChangeNotifier {
  final List<PointOfInterest> _pois = [];

  List<PointOfInterest> get pois => _pois;

  void addPOI(PointOfInterest poi) {
    _pois.add(poi);
    notifyListeners();
  }
}