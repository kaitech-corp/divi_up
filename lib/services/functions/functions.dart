
import 'package:cloud_firestore/cloud_firestore.dart';

int getIndex(int num){
  return num-1;
}

Timestamp? getTimestamp(DateTime? dateTime){
  try{
    return Timestamp.fromMillisecondsSinceEpoch(dateTime!.millisecondsSinceEpoch);
  } catch(e) {
    return null;
  }
}