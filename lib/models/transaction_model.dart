import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/functions/cloud_functions.dart';

///Model for transaction data
class TransactionData {
  TransactionData({
    required this.timestamp,
    required this.itemDocID,
    required this.success,
    required this.details,
    required this.transactionID,
  });

  factory TransactionData.fromDocument(DocumentSnapshot<Object?> doc) {
    bool success = true;
    Timestamp timestamp = Timestamp.now();
    String details = '';
    String transactionID = '';
    String itemDocID = '';

    try {
      success = doc.get('success') as bool;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field success error: ${e.toString()}');
    }
    try {
      timestamp = doc.get('timestamp') as Timestamp;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field timestamp error: ${e.toString()}');
    }
    try {
      details = doc.get('details') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field details error: ${e.toString()}');
    }
    try {
      transactionID = doc.get('transactionID') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field transactionID error: ${e.toString()}');
    }
    try {
      itemDocID = doc.get('itemDocID') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field itemDocID error: ${e.toString()}');
    }

    return TransactionData(
      timestamp: timestamp,
      itemDocID: itemDocID,
      success: success,
      details: details,
      transactionID: transactionID,
    );
  }

  bool success;
  Timestamp timestamp;
  String details;
  String transactionID;
  String itemDocID;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'timestamp': timestamp,
      'details': details,
      'transactionID': transactionID,
      'itemDocID': itemDocID,
    };
  }
}

TransactionData defaultTransactionData = TransactionData(
  timestamp: Timestamp.now(),
  itemDocID: 'New Item',
  success: true,
  details: 'log data',
  transactionID: 'arfergrdgadg',
);
