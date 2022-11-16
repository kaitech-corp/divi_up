
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../services/functions/cloud_functions.dart';

class AmountData {
  AmountData({
    required this.amount,
    required this.docID,
    required this.displayName,
    required this.paid,
    this.walletAddress,
    this.uid,
  });

  factory AmountData.fromDocument(DocumentSnapshot<Object?> doc) {
    String uid = '';
    double amount = 0.00;
    bool paid = false;
    String docID = '';
    String displayName = '';
    String walletAddress = '';

    try {
      uid = doc.get('uid') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field Retrieving item data field uid error: ${e.toString()}');
    }
    try {
      amount = doc.get('amount') as double;
    } catch (e) {
      CloudFunction()
          .logError('Retrieving item data field amount error: ${e.toString()}');
    }
    try {
      displayName = doc.get('displayName') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field displayName error: ${e.toString()}');
    }
    try {
      docID = doc.get('docID') as String;
    } catch (e) {
      CloudFunction()
          .logError('Retrieving item data field docID error: ${e.toString()}');
    }
    try {
      paid = doc.get('paid') as bool;
    } catch (e) {
      CloudFunction()
          .logError('Retrieving item data field paid error: ${e.toString()}');
    }
    try {
      walletAddress = doc.get('walletAddress') as String;
    } catch (e) {
      CloudFunction().logError(
          'Retrieving item data field walletAddress error: ${e.toString()}');
    }
    return AmountData(
      amount: amount,
      docID: docID,
      displayName: displayName,
      paid: paid,
      walletAddress: walletAddress,
      uid: uid,
    );
  }

  double amount;
  String docID;
  String displayName;
  String? walletAddress;
  String? uid;
  bool? paid;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'amount': amount,
      'displayName': displayName,
      'docID': docID,
      'paid':paid,
      'walletAddress': walletAddress,
    };
  }
}

AmountData defaultAmountData = AmountData(
  amount: 0.00,
  docID: '',
  displayName: 'displayName',
  paid: false,
  walletAddress: 'walletAddress',
  uid: 'uid',
);

class AmountDataBloc
    extends GroupFieldBloc<FieldBloc<FieldBlocStateBase>, dynamic> {
  AmountDataBloc(
      {required this.amount,
      required this.displayName,
      required this.walletAddress,
      required this.uid})
      : super(fieldBlocs: <FieldBloc<FieldBlocStateBase>>[
          amount,
          displayName,
          walletAddress
        ]);

  TextFieldBloc<double> amount;
  TextFieldBloc<String> displayName;
  TextFieldBloc<String> walletAddress;
  String uid;
}
