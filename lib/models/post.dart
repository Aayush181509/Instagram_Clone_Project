import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String profImage;
  final String postUrl;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.postId,
    required this.profImage,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postUrl": postUrl,
        "postId": postId,
        "profImage": profImage,
        "datePublished": datePublished,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
