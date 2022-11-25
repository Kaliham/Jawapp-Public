import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerProvider extends ChangeNotifier {
  Set<Marker> _allMarkers = {};
  MapMarkerProvider(this._allMarkers);
  Set<Marker> get allMarkers => _allMarkers;
  Marker getMarker(index) => _allMarkers.elementAt(index);

  void add(Marker marker) {
    _allMarkers.add(marker);
    notifyListeners();
  }

  void set(Set<Marker> allMarkers) {
    _allMarkers = allMarkers;
    notifyListeners();
  }
}

class LimitedMapMarker extends MapMarkerProvider {
  LimitedMapMarker(Set<Marker> allMarkers) : super(allMarkers);
}

class AreaMapMarker extends MapMarkerProvider {
  AreaMapMarker(Set<Marker> allMarkers) : super(allMarkers);
}
