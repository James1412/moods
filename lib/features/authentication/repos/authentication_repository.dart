import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> deleteAccount() async {
    await _db
        .collection('moods')
        .where("creatorUid", isEqualTo: _firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    try {
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
final authStateStream = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
