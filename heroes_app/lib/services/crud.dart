import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      print(FirebaseAuth.instance.currentUser());
      return true;
    } else {
      return false;
    }
  }

  bool finishedSavingUser = false;

  Future<void> addFitnessLevel(fitnesslevel, userid) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection('Users')
          .document(userid)
          .setData(fitnesslevel)
          .then((_) => {
            finishedSavingUser = true
          })
          .catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }
}
