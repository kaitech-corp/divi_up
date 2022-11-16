import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/amount_model.dart';
import '../models/item_model.dart';
import '../models/user_profile_model.dart';
import 'functions/cloud_functions.dart';

///Database class for all firebase api functions
class DatabaseService {
  DatabaseService({this.uid, this.itemDocID});
  ///uid parameter
  String? uid;
  ///itemDocID parameter
  String? itemDocID;

  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// All collection references

  final CollectionReference<Object?> userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Object?> userPublicProfileCollection =
      FirebaseFirestore.instance.collection('userPublicProfile');
  final Query<Object?> allUsersCollection = FirebaseFirestore.instance
      .collection('userPublicProfile')
      .orderBy('displayName');
  final CollectionReference<Object?> tokensCollection =
      FirebaseFirestore.instance.collection('tokens');
  final CollectionReference<Object?> addReviewCollection =
      FirebaseFirestore.instance.collection('addReview');
  final CollectionReference<Object?> versionCollection =
      FirebaseFirestore.instance.collection('version');
  final CollectionReference<Object?> itemCollection =
  FirebaseFirestore.instance.collection('items');
  final CollectionReference<Object?> amountCollection =
  FirebaseFirestore.instance.collection('amount');

  /// Shows latest app version to display in main menu.
  Future<String> getVersion() async {
    try {
      // TODO(Randy): change version doc for new releases
      final DocumentSnapshot<Object?> ref =
          await versionCollection.doc('version1_0_0').get();
      final Map<String, dynamic> data = ref.data()! as Map<String, dynamic>;
      final String version = data['version'] as String;
      if (version.isNotEmpty) {
        return version;
      } else {
        return '';
      }
    } catch (e) {
      CloudFunction().logError('Error retrieving version:  ${e.toString()}');
      return '';
    }
  }

  /// Get document key
  String getFirestoreKey()  {
    return userCollection.doc().id;
  }
///Save device token to use in cloud messaging.
//   Future<void> saveDeviceToken() async {
//     try {
//       /// Get the token for this device
//       final String? fcmToken = await _fcm.getToken();
//       final DocumentSnapshot<Map<String, dynamic>> ref = await tokensCollection.doc(uid).collection('tokens')
//           .doc(fcmToken).get();
//       /// Save it to Firestore
//       if (!ref.exists || ref.id != fcmToken) {
//         if (fcmToken != null) {
//           final DocumentReference<Map<String, dynamic>> tokens = tokensCollection
//               .doc(uid)
//               .collection('tokens')
//               .doc(fcmToken);
//
//           await tokens.set(<String, dynamic>{
//             'token': fcmToken,
//             'createdAt': FieldValue.serverTimestamp(), /// optional
//             'platform': Platform.operatingSystem /// optional
//           });
//         }
//       }
//     } catch (e) {
//       CloudFunction().logError('Error saving token:  ${e.toString()}');
//     }
//   }


  Future<UserPublicProfile> getUserProfile(String uid) async {
    try {
      final DocumentSnapshot<Object?> userData =
          await userPublicProfileCollection.doc(uid).get();
      if (userData.exists) {
        // final Map<String, dynamic> data = userData.data()! as Map<String, dynamic>;
        return UserPublicProfile.fromDocument(userData);
      }
    } catch (e) {
      CloudFunction()
          .logError('Error retrieving single user profile:  ${e.toString()}');
    }
    return defaultProfile;
  }

  ///Creates user info
  Future<void> createUser() async {
    try {
      const String action = 'Updating User data.';
      CloudFunction().logEvent(action);
      return await userCollection.doc(uid).set(<String, dynamic>{
        'uid': uid
      });
    } catch (e) {
      CloudFunction().logError('Error updating user data:  ${e.toString()}');
    }
  }

  ///Updates user info after signup
  Future<void> updateUserData(String? firstName, String? lastName,
      String? email) async {
    try {
      const String action = 'Updating User data.';
      CloudFunction().logEvent(action);
      return await userCollection.doc(uid).set(<String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'uid': uid
      });
    } catch (e) {
      CloudFunction().logError('Error updating user data:  ${e.toString()}');
    }
  }

  ////Checks whether user has a Public Profile on Firestore to know whether to
  //// send user to complete profile page or not.
  Future<bool> checkUserHasProfile() async {
    final DocumentReference<Object?> ref = userCollection.doc(uid);
    final DocumentSnapshot<Object?> refSnapshot = await ref.get();
    return refSnapshot.exists;
  }

  ////Updates public profile after sign up
  Future<void> updateUserPublicProfileData(
      UserPublicProfile userPublicProfile, File imageURL) async {
    final DocumentReference<Object?> ref = userPublicProfileCollection.doc(uid);
    try {
      const String action = 'Updating public profile after sign up';
      CloudFunction().logEvent(action);
      await ref.set(userPublicProfile.toJson());
    } catch (e) {
      CloudFunction()
          .logError('Error creating public profile:  ${e.toString()}');
    }
    if (imageURL != null && imageURL.path.isNotEmpty) {
      String urlForImage;

      try {
        const String action = 'Saving and updating User profile picture';
        CloudFunction().logEvent(action);
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('users/$uid');
        final UploadTask uploadTask = storageReference.putFile(imageURL);

        return await ref.update(<String, dynamic>{
          'imageURL': await storageReference.getDownloadURL().then((String fileURL) {
            urlForImage = fileURL;
            return urlForImage;
          })
        });
      } catch (e) {
        CloudFunction()
            .logError('Error saving image for public profile:  '
            '${e.toString()}');
      }
    }
  }

  /// Save item data
  Future<String?> saveItem(ItemData itemData) async {
    try {
      final String docID = itemCollection.doc().id;
      itemCollection.doc(docID).set(itemData.toJson());
      final DocumentReference<Object?> ref = itemCollection.doc(docID);
      ref.update(<String, dynamic>{
        'docID': docID,
        'dateCreated': FieldValue.serverTimestamp(),
        'ownerID': FirebaseAuth.instance.currentUser?.uid,
      });
      return docID;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  /// Update item data
  Future<void> updateItem(ItemData itemData) async {
    try {
      itemCollection.doc(itemData.docID).update(itemData.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
  /// Update item data
  Future<void> deleteItem() async {
    try {
      itemCollection.doc(itemDocID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
  /// Save amount data
  Future<void> saveAmount(List<AmountDataBloc> amount, String docID) async {
    try {
      for(final AmountDataBloc user in amount){
        final DocumentReference<Object?> ref = amountCollection.doc(docID).collection('amount').doc(user.uid);
        ref.set(<String, dynamic>{
          'amount': user.amount.value,
          'displayName': user.displayName.value,
          'docID': docID,
          'dateCreated': FieldValue.serverTimestamp(),
          'walletAddress': user.walletAddress.value,
          'uid': user.uid,
        });
      }
    } catch (e) {
      print(e.toString());
      CloudFunction().logError('Error updating user data:  ${e.toString()}');
    }
  }
}
