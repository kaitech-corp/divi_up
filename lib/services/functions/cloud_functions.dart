



import 'package:cloud_functions/cloud_functions.dart';

class CloudFunction {

  //Log event
  Future<void> logEvent(String action) async{
    final HttpsCallable functionData = FirebaseFunctions.instance.httpsCallable( 'logEvent');
    functionData(<String,dynamic>{
      'action': action,
    });
  }
// Log Error
  Future<void> logError(String error) async{
    final HttpsCallable functionData = FirebaseFunctions.instance.httpsCallable( 'logError');
    functionData(<String,dynamic>{
      'error': error,
    });
  }
  //Disable account
  Future<void> disableAccount() async {
    final HttpsCallable functionData = FirebaseFunctions.instance.httpsCallable('disableAccount');
    functionData();
  }
}

//const xrpl = require("xrpl");
//const {XummSdk} = require("xumm-sdk");

//exports.paymentRequest = functions.https.onCall(async (data, context) =>{
//  const xumm = new XummSdk(data.key, data.secret);
//  const request = {
//    "TransactionType": "Payment",
//    "Destination": data.destination,
//    "Amount": data.amount,
//    "Memos": [{
//      "Memo": {
//        "MemoData": xrpl.convertStringToHex(data.memo),
//      },
//    }],
//  };
//  const payload = await xumm.payload.create(request, true);
//  console.log(payload);
//
//  return payload;
//});

//* *******************
//*  XUMM sign in ***********
//* *******************

// exports.signInXUMM = functions.https.onCall(async (data, context) => {
//  const xumm = new XummSdk(data.key, data.secret);
//  const request = {
//    "options": {
//      "submit": false,
//      "expire": 240,
//      "return_url": {
//        "app": "https://xrptipbot.com/signin?payload={id}",
//        "web": "https://xrptipbot.com/signin?payload={id}",
//      }
//    },
//    "user_token": "c5bc4ccc-28fa-4080-b702-0d3aac97b993",
//    "txjson": {
//      "TransactionType": "SignIn",
//    },
//  };
// });