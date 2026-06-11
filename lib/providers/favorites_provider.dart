import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Saved/favorite items, persisted per signed-in user under
/// `users/{uid}/saved/{itemId}` so they survive restarts and can be
/// filtered by user on the Saved Items screen.
class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _savedSub;

  Set<String> _favorites = <String>{};
  String? _uid;

  FavoritesProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance {
    _authSub = _auth.authStateChanges().listen(_handleAuthChanged);
  }

  Set<String> get savedIds => Set.unmodifiable(_favorites);

  bool isFavorite(String id) => _favorites.contains(id);

  void _handleAuthChanged(User? user) {
    _uid = user?.uid;
    _savedSub?.cancel();
    _favorites = <String>{};
    notifyListeners();

    final uid = _uid;
    if (uid == null) return;

    _savedSub = _savedCollection(uid).snapshots().listen((snapshot) {
      _favorites = snapshot.docs.map((doc) => doc.id).toSet();
      notifyListeners();
    });
  }

  Future<void> toggle(String id) async {
    final uid = _uid;
    if (uid == null) return;

    final ref = _savedCollection(uid).doc(id);
    final wasFavorite = _favorites.contains(id);

    // Optimistic update for an instant UI response; the snapshot
    // listener reconciles with the server shortly after.
    if (wasFavorite) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();

    try {
      if (wasFavorite) {
        await ref.delete();
      } else {
        await ref.set({'savedAt': FieldValue.serverTimestamp()});
      }
    } catch (_) {
      // Revert on failure.
      if (wasFavorite) {
        _favorites.add(id);
      } else {
        _favorites.remove(id);
      }
      notifyListeners();
    }
  }

  CollectionReference<Map<String, dynamic>> _savedCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('saved');
  }

  @override
  void dispose() {
    _savedSub?.cancel();
    _authSub.cancel();
    super.dispose();
  }
}
