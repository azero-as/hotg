import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      print(FirebaseAuth.instance.currentUser());
      return true;
    }else {
      return false;
    }
  }

  Future<void> addFitnessLevel(fitnesslevel, userid)async {
    if (isLoggedIn()) {
      Firestore.instance.collection('Users').document(userid).setData(fitnesslevel).catchError( (e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

}