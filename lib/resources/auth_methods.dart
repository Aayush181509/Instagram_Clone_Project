import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestrore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestrore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //signup function
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        //add user to our database
        await _firestrore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        //another way to store
        // await _firestrore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
      // } on FirebaseAuthException catch (err) {
      //   if (err.code == 'invalid-email') {
      //     res = 'The email is badly formatted';
      //   } else if (err.code == 'weak-password') {
      //     res = 'Password should be at lease 6 characters';
      //   }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
