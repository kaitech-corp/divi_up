import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/functions/cloud_functions.dart';

///Model for split item data
class ItemData {
  static final ItemData _instance = defaultItemData;
  static ItemData get instance => _instance;

  ItemData(
      {required this.geoPoint,
      required this.dateCreated,
      required this.itemName,
      required this.evenSplit,
      required this.ownerID,
      required this.docID,
      required this.total,
      required this.location,
      required this.type,
      required this.accessUsers});

  factory ItemData.fromDocument(DocumentSnapshot<Object?> doc) {
    String type = '';
    String ownerID = '';
    bool evenSplit = true;
    GeoPoint geoPoint = const GeoPoint(10, 10);
    Timestamp dateCreated = Timestamp.now();
    String docID = '';
    double total = 0.0;
    String location = '';
    String itemName = '';
    List<String> accessUsers = <String>[];
    try {
      type = doc.get('type') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field Retrieving item data field type error: ${e.toString()}');
    }
    try {
      ownerID = doc.get('ownerID') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field ownerID error: ${e.toString()}');
    }
    try {
      evenSplit = doc.get('evenSplit') as bool;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field evenSplit error: ${e.toString()}');
    }
    try {
      geoPoint = doc.get('geoPoint') as GeoPoint;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field geoPoint error: ${e.toString()}');
    }
    try {
      dateCreated = doc.get('dateCreated') as Timestamp;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field dateCreated error: ${e.toString()}');
    }
    try {
      docID = doc.get('docID') as String;
    } catch (e) {
      CloudFunction()
          .logError('Retrieving item data field docID error: ${e.toString()}');
    }
    try {
      total = doc.get('total') as double;
    } catch (e) {
      CloudFunction()
          .logError('Retrieving item data field total error: ${e.toString()}');
    }
    try {
      location = doc.get('location') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field location error: ${e.toString()}');
    }
    try {
      itemName = doc.get('itemName') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field itemName error: ${e.toString()}');
    }
    try {
      var accessUsers = doc.get('accessUsers') as List<dynamic>;
      accessUsers.forEach((dynamic element) {
        accessUsers.add(element.toString());
      });
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field accessUsers error: ${e.toString()}');
    }
    return ItemData(
        geoPoint: geoPoint,
        dateCreated: dateCreated,
        evenSplit: evenSplit,
        itemName: itemName,
        ownerID: ownerID,
        docID: docID,
        total: total,
        location: location,
        type: type,
        accessUsers: accessUsers);
  }

  String type;
  String ownerID;
  bool evenSplit;
  GeoPoint geoPoint;
  Timestamp dateCreated;
  String docID;
  double total;
  String location;
  String itemName;
  List<String> accessUsers;

  ItemData update({
    String? type,
    String? ownerID,
    bool? evenSplit,
    GeoPoint? geoPoint,
    Timestamp? dateCreated,
    String? docID,
    double? total,
    String? location,
    String? itemName,
    List<String>? accessUsers,
  }) {
    return ItemData(
        geoPoint: geoPoint ?? this.geoPoint,
        dateCreated: dateCreated ?? this.dateCreated,
        itemName: itemName ?? this.itemName,
        evenSplit: evenSplit ?? this.evenSplit,
        ownerID: ownerID ?? this.ownerID,
        docID: docID ?? this.docID,
        total: total ?? this.total,
        location: location ?? this.location,
        type: type ?? this.type,
        accessUsers: accessUsers ?? this.accessUsers);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'ownerID': ownerID,
      'evenSplit': evenSplit,
      'geoPoint': geoPoint,
      'dateCreated': dateCreated,
      'docID': docID,
      'total': total,
      'location': location,
      'itemName': itemName,
      'accessUsers': accessUsers,
    };
  }
}

ItemData defaultItemData = ItemData(
    geoPoint: const GeoPoint(10, 10),
    dateCreated: Timestamp.now(),
    itemName: 'New Item',
    evenSplit: true,
    ownerID: '',
    docID: '',
    total: 0.00,
    location: '',
    type: 'Item',
    accessUsers: <String>[]);
