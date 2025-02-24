import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Create or update user document
        await _createUserDocument(user);
      }

      notifyListeners();
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
      }

      notifyListeners();
    } catch (e) {
      print('Error signing in with email and password: $e');
      rethrow;
    }
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        // Create user document
        await _createUserDocument(userCredential.user!, name: name);
      }

      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        // Create user document
        await _createUserDocument(userCredential.user!, name: name);
      }

      notifyListeners();
    } catch (e) {
      print('Error registering with email and password: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  Future<void> _createUserDocument(User user, {String? name}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final userData = await userDoc.get();

    if (!userData.exists) {
      await userDoc.set({
        'email': user.email,
        'name': name ?? user.displayName ?? 'User',
        'created_at': FieldValue.serverTimestamp(),
        'last_login': FieldValue.serverTimestamp(),
      });
    } else {
      await userDoc.update({
        'last_login': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateCarbonDataPreferences(List<String> categories) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'carbon_preferences': categories,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating carbon preferences: $e');
      rethrow;
    }
  }

  Future<List<String>> getCarbonDataPreferences() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      final userData = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (!userData.exists) return [];

      final preferences = userData.data()?['carbon_preferences'];
      if (preferences == null) return [];

      return List<String>.from(preferences);
    } catch (e) {
      print('Error getting carbon preferences: $e');
      return [];
    }
  }

  Future<void> deleteAccount() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      // Delete user data
      await _firestore.collection('users').doc(currentUser!.uid).delete();
      
      // Delete user authentication
      await currentUser!.delete();
      
      notifyListeners();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (!doc.exists) {
        return {
          'email': currentUser!.email,
          'name': currentUser!.displayName ?? 'User',
          'created_at': DateTime.now(),
          'last_login': DateTime.now(),
        };
      }
      return doc.data() ?? {};
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }
} 