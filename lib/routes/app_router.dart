import 'package:flutter/material.dart';

import '../screens/add_item_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/seller_profile_screen.dart';

class RouteNames {
  static const String onboarding = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String browse = '/browse';
  static const String add = '/add';
  static const String messages = '/messages';
  static const String profile = '/profile';
  static const String product = '/product';
  static const String chat = '/chat';
  static const String seller = '/seller';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    if (name == RouteNames.onboarding) {
      return _page(const OnboardingScreen(), settings);
    }
    if (name == RouteNames.auth) {
      return _page(const LoginScreen(), settings);
    }
    if (name == RouteNames.login) {
      return _page(const LoginScreen(), settings);
    }
    if (name == RouteNames.signup) {
      return _page(const SignupScreen(), settings);
    }
    if (name == RouteNames.home) {
      return _page(const HomeScreen(), settings);
    }
    if (name == RouteNames.browse) {
      return _page(const BrowseScreen(), settings);
    }
    if (name == RouteNames.add) {
      return _page(const AddItemScreen(), settings);
    }
    if (name == RouteNames.messages) {
      return _page(const MessagesScreen(), settings);
    }
    if (name == RouteNames.profile) {
      return _page(const ProfileScreen(), settings);
    }

    if (name.startsWith('${RouteNames.product}/')) {
      final id = name.replaceFirst('${RouteNames.product}/', '');
      return _page(ProductDetailScreen(productId: id), settings);
    }

    if (name.startsWith('${RouteNames.chat}/')) {
      final id = name.replaceFirst('${RouteNames.chat}/', '');
      return _page(ChatScreen(chatId: id), settings);
    }

    if (name.startsWith('${RouteNames.seller}/')) {
      final id = name.replaceFirst('${RouteNames.seller}/', '');
      return _page(SellerProfileScreen(sellerId: id), settings);
    }

    return _page(const NotFoundScreen(), settings);
  }

  static MaterialPageRoute _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
