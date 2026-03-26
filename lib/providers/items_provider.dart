import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/item.dart';

class AddItemInput {
  final String title;
  final String description;
  final String category;
  final String condition;
  final String location;
  final String wantsInReturn;
  final List<String> images;

  const AddItemInput({
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.location,
    required this.wantsInReturn,
    required this.images,
  });
}

class ItemsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  ItemsProvider({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Item>> itemsStream({String? category}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('items')
        .orderBy('createdAt', descending: true);
    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Item.fromDoc(doc)).toList(),
    );
  }

  Stream<Item?> itemStream(String id) {
    return _firestore.collection('items').doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Item.fromDoc(doc);
    });
  }

  Future<String> addItem({
    required AddItemInput input,
    required AppUser owner,
  }) async {
    final doc = await _firestore.collection('items').add({
      'title': input.title,
      'description': input.description,
      'category': input.category,
      'condition': input.condition,
      'location': input.location,
      'wantsInReturn': input.wantsInReturn,
      'images': input.images,
      'ownerId': owner.id,
      'ownerName': owner.name,
      'ownerAvatar': owner.photoUrl,
      'ownerRating': owner.rating,
      'ownerSwaps': owner.swaps,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }
}
