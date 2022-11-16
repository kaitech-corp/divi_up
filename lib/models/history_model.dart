import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/functions/cloud_functions.dart';


///Model for activity data
class HistoryData {
  HistoryData(
      {
        required this.displayName,
        required this.walletAddress,
        required this.uid,
        });

  factory HistoryData.fromDocument(DocumentSnapshot<Object?> doc) {
    String displayName = '';
    String walletAddress = '';
    String uid = '';

    try {
      displayName = doc.get('displayName') as String;
    } catch (e) {
      CloudFunction().logError('Display name error: ${e.toString()}');
    }
    try {
      walletAddress = doc.get('walletAddress') as String;
    } catch (e) {
      CloudFunction().logError('walletAddress error: ${e.toString()}');
    }
    try {
      uid = doc.get('uid') as String;
    } catch (e) {
      CloudFunction().logError('UID error: ${e.toString()}');
    }
    return HistoryData(
        displayName: displayName,
        walletAddress: walletAddress,
        uid: uid,
    );
  }


  String displayName;
  String walletAddress;
  String uid;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'displayName': displayName,
      'walletAddress': walletAddress,
      'uid': uid,
    };
  }
}

HistoryData defaultHistoryData = HistoryData(
    displayName: 'user',
    walletAddress: '1234567890asdfghjkl',
    uid: 'uid',);
