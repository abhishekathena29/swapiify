import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final int swaps;
  final double rating;
  final int followers;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.photoUrl,
    this.swaps = 0,
    this.rating = 0,
    this.followers = 0,
  });

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return AppUser(
      id: doc.id,
      name: (data['displayName'] as String?)?.trim().isNotEmpty == true
          ? data['displayName'] as String
          : 'User',
      email: (data['email'] as String?) ?? '',
      photoUrl: data['photoUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      swaps: (data['swaps'] as num?)?.toInt() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      followers: (data['followers'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'swaps': swaps,
      'rating': rating,
      'followers': followers,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    int? swaps,
    double? rating,
    int? followers,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      swaps: swaps ?? this.swaps,
      rating: rating ?? this.rating,
      followers: followers ?? this.followers,
    );
  }
}
