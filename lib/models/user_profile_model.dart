import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/functions/cloud_functions.dart';


///Model for user public profile
class UserPublicProfile {
  UserPublicProfile(
      {
        required this.cryptoWallets,
        required this.dateCreated,
        required this.displayName,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.uid,
        required this.imageURL});

  factory UserPublicProfile.fromDocument(DocumentSnapshot<Object?> doc) {
    List<dynamic> cryptoWallets = <String>[];
    String displayName = '';
    Timestamp dateCreated = Timestamp.now();
    String email = '';
    String firstName = '';
    String lastName = '';
    String uid = '';
    String imageURL = '';

    try {
      cryptoWallets = doc.get('cryptoWallets') as List<dynamic>;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving User Profile retrieving Crypto Wallets error: ${e.toString()}');
    }
    try {
      dateCreated = doc.get('dateCreated') as Timestamp;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving dateCreated error: ${e.toString()}');
    }
    try {
      displayName = doc.get('displayName') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving Display name error: ${e.toString()}');
    }
    try {
      email = doc.get('email') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving Email error: ${e.toString()}');
    }
    try {
      firstName = doc.get('firstName') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving First name error: ${e.toString()}');
    }
    try {
      firstName = doc.get('lastName') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving First name error: ${e.toString()}');
    }
    try {
      lastName = doc.get('lastName') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving Last name error: ${e.toString()}');
    }
    try {
      uid = doc.get('uid') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving UID error: ${e.toString()}');
    }
    try {
      imageURL = doc.get('imageURL') as String;
    } catch (e) {
      CloudFunction().logError('User Profile retrieving Image url error: ${e.toString()}');
    }
    return UserPublicProfile(
        cryptoWallets: cryptoWallets,
        dateCreated:dateCreated,
        displayName: displayName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        uid: uid,
        imageURL: imageURL);
  }

  List<dynamic> cryptoWallets;
  Timestamp dateCreated;
  String displayName;
  String email;
  String firstName;
  String lastName;
  String uid;
  String imageURL;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cryptoWallets': cryptoWallets,
      'dateCreated': dateCreated,
      'displayName': displayName,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'uid': uid,
      'imageURL': imageURL,
    };
  }
}
// Default profile
UserPublicProfile defaultProfile = UserPublicProfile(
    cryptoWallets: <String>[],
    displayName: 'user',
    email: 'email',
    firstName: 'First',
    lastName: 'Last',
    uid: 'uid',
    imageURL: '',
    dateCreated: Timestamp.now());

///Model for user
class User {
  User({this.displayName, this.email, this.firstName, this.lastName, this.uid});

  final String? displayName;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? uid;
}

///Model for user signup
class UserSignUp {
  UserSignUp(
      {this.displayName, this.email, this.firstName, this.lastName, this.uid});

  String? displayName;
  String? email;
  String? firstName;
  String? lastName;
  String? uid;
}
