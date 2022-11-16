import 'package:cloud_firestore/cloud_firestore.dart';

///Model for Google Places
class GoogleData {
  GoogleData({this.location, this.geoLocation});

  String? location;
  GeoPoint? geoLocation;
}