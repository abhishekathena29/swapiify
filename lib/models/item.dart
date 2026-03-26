import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class Item {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String category;
  final String condition;
  final String location;
  final String wantsInReturn;
  final String ownerId;
  final String ownerName;
  final String? ownerAvatar;
  final double ownerRating;
  final int ownerSwaps;
  final DateTime createdAt;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.condition,
    required this.location,
    required this.wantsInReturn,
    required this.ownerId,
    required this.ownerName,
    required this.createdAt,
    this.ownerAvatar,
    this.ownerRating = 0,
    this.ownerSwaps = 0,
  });

  factory Item.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Item(
      id: doc.id,
      title: (data['title'] as String?) ?? 'Untitled Item',
      description: (data['description'] as String?) ?? '',
      images:
          (data['images'] as List?)?.whereType<String>().toList() ??
          const <String>[],
      category: (data['category'] as String?) ?? 'Misc',
      condition: (data['condition'] as String?) ?? 'Good',
      location: (data['location'] as String?) ?? 'Nearby',
      wantsInReturn: (data['wantsInReturn'] as String?) ?? 'Open to offers',
      ownerId: (data['ownerId'] as String?) ?? '',
      ownerName: (data['ownerName'] as String?) ?? 'Seller',
      ownerAvatar: data['ownerAvatar'] as String?,
      ownerRating: (data['ownerRating'] as num?)?.toDouble() ?? 0,
      ownerSwaps: (data['ownerSwaps'] as num?)?.toInt() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'images': images,
      'category': category,
      'condition': condition,
      'location': location,
      'wantsInReturn': wantsInReturn,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerAvatar': ownerAvatar,
      'ownerRating': ownerRating,
      'ownerSwaps': ownerSwaps,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Seller toSeller() {
    return Seller(name: ownerName, rating: ownerRating, swaps: ownerSwaps);
  }

  Product toProduct() {
    return Product(
      id: id,
      name: title,
      description: description,
      images: images.isEmpty ? const <String>[] : images,
      category: category,
      condition: condition,
      location: location,
      postedAgo: '',
      wantsInReturn: wantsInReturn,
      seller: toSeller(),
    );
  }
}
