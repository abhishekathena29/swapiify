import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late final StreamSubscription<User?> _authSub;

  bool _isLoading = false;
  String? _error;
  User? _user;
  AppUser? _profile;

  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance {
    _authSub = _auth.authStateChanges().listen(_handleAuthChanged);
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  AppUser? get profile => _profile;
  bool get isAuthenticated => _user != null;

  Future<void> _handleAuthChanged(User? user) async {
    _user = user;
    if (user == null) {
      _profile = null;
      notifyListeners();
      return;
    }
    await _ensureProfile(user);
  }

  Future<void> _ensureProfile(User user, {String? providedName}) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (doc.exists) {
      _profile = AppUser.fromDoc(doc);
      final safeProvided = providedName?.trim();
      final displayName = user.displayName?.trim();
      final desiredName = (safeProvided != null && safeProvided.isNotEmpty)
          ? safeProvided
          : (displayName != null && displayName.isNotEmpty
                ? displayName
                : null);
      final currentName = _profile?.name.trim();
      if (desiredName != null &&
          (currentName == null ||
              currentName.isEmpty ||
              currentName == 'User')) {
        await docRef.set({'displayName': desiredName}, SetOptions(merge: true));
        _profile = _profile?.copyWith(name: desiredName);
      }
    } else {
      final safeProvided = providedName?.trim();
      final displayName = user.displayName?.trim();
      final resolvedName = (safeProvided != null && safeProvided.isNotEmpty)
          ? safeProvided
          : (displayName != null && displayName.isNotEmpty
                ? displayName
                : 'User');
      final profile = AppUser(
        id: user.uid,
        name: resolvedName,
        email: user.email ?? '',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        swaps: 0,
        rating: 0,
        followers: 0,
      );
      await docRef.set(profile.toMap());
      _profile = profile;
    }
    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Unable to sign in.';
      return _error;
    } catch (_) {
      _error = 'Unable to sign in.';
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();
      await _ensureProfile(credential.user!, providedName: name.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Unable to create account.';
      return _error;
    } catch (_) {
      _error = 'Unable to create account.';
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
