import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

//for save user in firebase
Future<void> userSetup(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  users.add({'displayName': displayName, "uid": uid});
  return;
}

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail({String email, String Password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: Password);

    final User user = res.user;
    return user;
  }

  static signUpWithEmail({
    String email,
    String Password,
  }) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: Password);
    final User user = res.user;
    return user;
  }

  static logOut() {
    return _auth.signOut();
  }
}

//for firebase
class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      //"displayName": user.displayName,
      "email": user.email,
      "role": "user",
      "build_number": buildNumber,
    };
    //USR ALREADY EXIST OR NOT
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "build_number": buildNumber,
      });
    } else {
      await userRef.set(userData);
    }
  }
}

class TUserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      "displayName": user.displayName,
      "email": user.email,
      "role": "user",
      "build_number": buildNumber,
    };
    //USR ALREADY EXIST OR NOT
    final userRef = _db.collection("Teacher").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "build_number": buildNumber,
      });
    } else {
      await userRef.set(userData);
    }
  }
}
