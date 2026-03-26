import 'package:flutter/material.dart';

IconData appIcon(String key) {
  switch (key) {
    case 'dumbbell':
      return Icons.fitness_center_rounded;
    case 'gamepad':
      return Icons.sports_esports_rounded;
    case 'book':
      return Icons.menu_book_rounded;
    case 'shirt':
      return Icons.checkroom_rounded;
    case 'watch':
      return Icons.watch_rounded;
    case 'bag':
      return Icons.shopping_bag_rounded;
    case 'repeat':
      return Icons.repeat_rounded;
    case 'globe':
      return Icons.public_rounded;
    case 'leaf':
      return Icons.eco_rounded;
    case 'person_add':
      return Icons.person_add_alt_1_rounded;
    case 'upload':
      return Icons.cloud_upload_rounded;
    case 'search':
      return Icons.search_rounded;
    case 'chat':
      return Icons.chat_bubble_rounded;
    case 'party':
      return Icons.celebration_rounded;
    default:
      return Icons.circle;
  }
}
