import '../models/conversation.dart';
import '../models/message.dart';
import '../models/product.dart';

class HeroItem {
  final String id;
  final String title;
  final String description;
  final String image;

  const HeroItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });
}

class CategoryItem {
  final String name;
  final String icon;

  const CategoryItem({required this.name, required this.icon});
}

class FeatureItem {
  final String title;
  final String description;
  final String icon;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class HowItWorksStep {
  final int step;
  final String title;
  final String icon;

  const HowItWorksStep({
    required this.step,
    required this.title,
    required this.icon,
  });
}

class BrowseProduct {
  final String id;
  final String name;
  final String image;
  final String category;
  final String location;

  const BrowseProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.location,
  });
}

class RecentItem {
  final String id;
  final String name;
  final String image;
  final String category;
  final String location;

  const RecentItem({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.location,
  });
}

const String handbagImg = 'assets/products/handbag.png';
const String earringsImg = 'assets/products/earrings.png';
const String toyCarImg = 'assets/products/toy-car.png';
const String sneakersImg = 'assets/products/sneakers.png';
const String cameraImg = 'assets/products/camera.png';
const String bookImg = 'assets/products/book.png';

const heroItems = <HeroItem>[
  HeroItem(
    id: '1',
    title: 'Red Leather Handbag',
    description:
        'This vibrant red handbag adds a bold pop of color to any outfit.',
    image: handbagImg,
  ),
  HeroItem(
    id: '2',
    title: 'Golden Hoop Earrings',
    description: 'Elegant and timeless, perfect for any occasion.',
    image: earringsImg,
  ),
  HeroItem(
    id: '3',
    title: 'Vintage Leather Book',
    description:
        'A beautiful leather-bound classic for collectors and book lovers.',
    image: bookImg,
  ),
];

const categories = <CategoryItem>[
  CategoryItem(name: 'Sports', icon: 'dumbbell'),
  CategoryItem(name: 'Toys', icon: 'gamepad'),
  CategoryItem(name: 'Books', icon: 'book'),
  CategoryItem(name: 'Clothes', icon: 'shirt'),
  CategoryItem(name: 'Accessories', icon: 'watch'),
  CategoryItem(name: 'Bags', icon: 'bag'),
];

const features = <FeatureItem>[
  FeatureItem(
    title: 'Seamless Barter',
    description: 'Swap items easily — no cash required.',
    icon: 'repeat',
  ),
  FeatureItem(
    title: 'Diverse Marketplace',
    description: 'From books to jewelry, find it all.',
    icon: 'globe',
  ),
  FeatureItem(
    title: 'Sustainable Trading',
    description: 'Give your items a second life.',
    icon: 'leaf',
  ),
];

const howItWorks = <HowItWorksStep>[
  HowItWorksStep(step: 1, title: 'Create Profile', icon: 'person_add'),
  HowItWorksStep(step: 2, title: 'List Items', icon: 'upload'),
  HowItWorksStep(step: 3, title: 'Find Matches', icon: 'search'),
  HowItWorksStep(step: 4, title: 'Make Offers', icon: 'chat'),
  HowItWorksStep(step: 5, title: 'Swap & Enjoy!', icon: 'party'),
];

const recentItems = <RecentItem>[
  RecentItem(
    id: '1',
    name: 'Red Leather Handbag',
    image: handbagImg,
    category: 'Bags',
    location: '1.2 km',
  ),
  RecentItem(
    id: '2',
    name: 'Golden Hoop Earrings',
    image: earringsImg,
    category: 'Accessories',
    location: '2.5 km',
  ),
  RecentItem(
    id: '3',
    name: 'Vintage Toy Car',
    image: toyCarImg,
    category: 'Toys',
    location: '0.8 km',
  ),
  RecentItem(
    id: '4',
    name: 'Vintage Sneakers',
    image: sneakersImg,
    category: 'Clothes',
    location: '3.1 km',
  ),
  RecentItem(
    id: '5',
    name: 'Retro Film Camera',
    image: cameraImg,
    category: 'Electronics',
    location: '4.0 km',
  ),
  RecentItem(
    id: '6',
    name: 'Classic Literature',
    image: bookImg,
    category: 'Books',
    location: '1.5 km',
  ),
];

const browseCategories = <String>[
  'All',
  'Electronics',
  'Fashion',
  'Books',
  'Sports',
  'Home',
  'Toys',
];

const browseProducts = <BrowseProduct>[
  BrowseProduct(
    id: '1',
    name: 'Vintage Camera',
    image: cameraImg,
    category: 'Electronics',
    location: '2.5 km',
  ),
  BrowseProduct(
    id: '2',
    name: 'Designer Handbag',
    image: handbagImg,
    category: 'Fashion',
    location: '1.2 km',
  ),
  BrowseProduct(
    id: '3',
    name: 'Classic Novel Set',
    image: bookImg,
    category: 'Books',
    location: '3.8 km',
  ),
  BrowseProduct(
    id: '4',
    name: 'Running Sneakers',
    image: sneakersImg,
    category: 'Sports',
    location: '0.8 km',
  ),
  BrowseProduct(
    id: '5',
    name: 'Gold Earrings',
    image: earringsImg,
    category: 'Fashion',
    location: '4.1 km',
  ),
  BrowseProduct(
    id: '6',
    name: 'Toy Car Collection',
    image: toyCarImg,
    category: 'Toys',
    location: '1.5 km',
  ),
];

final productsById = <String, Product>{
  '1': Product(
    id: '1',
    name: 'Red Leather Handbag',
    description:
        'This vibrant red handbag adds a bold pop of color to any outfit. Stylish and versatile, it\'s perfect for both casual outings and evening events. Excellent condition with minimal wear.',
    images: [handbagImg, handbagImg],
    category: 'Bags',
    condition: 'Like New',
    location: 'Downtown, 1.2 km',
    postedAgo: '2 hours ago',
    wantsInReturn: 'Accessories, Jewelry, or Scarves',
    seller: const Seller(name: 'Sarah Miller', rating: 4.8, swaps: 24),
  ),
  '2': Product(
    id: '2',
    name: 'Golden Hoop Earrings',
    description:
        'Elegant and timeless, these golden hoop earrings add a sophisticated touch to any outfit. Perfect for any occasion from casual to formal.',
    images: [earringsImg, earringsImg],
    category: 'Accessories',
    condition: 'New',
    location: 'Midtown, 2.5 km',
    postedAgo: '5 hours ago',
    wantsInReturn: 'Books, Fashion items',
    seller: const Seller(name: 'Emily Chen', rating: 4.9, swaps: 31),
  ),
  '3': Product(
    id: '3',
    name: 'Vintage Toy Car',
    description:
        'Race into adventure with this vibrant red toy car! Durable and perfect for hours of fun. A great collectible piece.',
    images: [toyCarImg, toyCarImg],
    category: 'Toys & Games',
    condition: 'Good',
    location: 'Uptown, 0.8 km',
    postedAgo: '1 day ago',
    wantsInReturn: 'Board games, Books',
    seller: const Seller(name: 'Mike Wilson', rating: 4.5, swaps: 12),
  ),
  '4': Product(
    id: '4',
    name: 'Vintage Sneakers',
    description:
        'Stylish vintage sneakers in excellent condition. Perfect for casual everyday wear. Size 10.',
    images: [sneakersImg, sneakersImg],
    category: 'Clothes',
    condition: 'Good',
    location: 'East Side, 3.1 km',
    postedAgo: '3 days ago',
    wantsInReturn: 'Other sneakers, Electronics',
    seller: const Seller(name: 'John Davis', rating: 4.7, swaps: 18),
  ),
  '5': Product(
    id: '5',
    name: 'Retro Film Camera',
    description:
        'A beautiful vintage analog camera for photography enthusiasts and collectors alike. Fully functional with a clear lens.',
    images: [cameraImg, cameraImg],
    category: 'Electronics',
    condition: 'Like New',
    location: 'West End, 4.0 km',
    postedAgo: '1 week ago',
    wantsInReturn: 'Tech gadgets, Books',
    seller: const Seller(name: 'Lisa Brown', rating: 4.6, swaps: 9),
  ),
  '6': Product(
    id: '6',
    name: 'Classic Literature',
    description:
        'A beautifully bound classic novel. Perfect for book lovers and collectors. Hardcover edition in great shape.',
    images: [bookImg, bookImg],
    category: 'Books',
    condition: 'Good',
    location: 'Central, 1.5 km',
    postedAgo: '4 days ago',
    wantsInReturn: 'Other books, Art supplies',
    seller: const Seller(name: 'Emily Chen', rating: 4.9, swaps: 31),
  ),
};

const conversations = <Conversation>[
  Conversation(
    id: '1',
    name: 'Sarah Miller',
    lastMessage: 'Is the camera still available?',
    time: '2m ago',
    unread: 2,
  ),
  Conversation(
    id: '2',
    name: 'John Davis',
    lastMessage: 'Great! Let\'s meet tomorrow then.',
    time: '1h ago',
    unread: 0,
  ),
  Conversation(
    id: '3',
    name: 'Emily Chen',
    lastMessage: 'Would you trade for the book set?',
    time: '3h ago',
    unread: 1,
  ),
  Conversation(
    id: '4',
    name: 'Mike Wilson',
    lastMessage: 'Thanks for the swap! \ud83c\udf89',
    time: 'Yesterday',
    unread: 0,
  ),
  Conversation(
    id: '5',
    name: 'Lisa Brown',
    lastMessage: 'Can you send more photos?',
    time: '2 days ago',
    unread: 0,
  ),
];

const mockMessages = <ChatMessage>[
  ChatMessage(
    id: 1,
    text: 'Hi! Is the camera still available?',
    sender: 'other',
    time: '10:30 AM',
  ),
  ChatMessage(
    id: 2,
    text: 'Yes it is! Are you interested in swapping?',
    sender: 'me',
    time: '10:32 AM',
  ),
  ChatMessage(
    id: 3,
    text:
        'Definitely! I have a set of vintage books I could trade. Would that interest you?',
    sender: 'other',
    time: '10:33 AM',
  ),
  ChatMessage(
    id: 4,
    text: 'That sounds great! Can you send me some photos?',
    sender: 'me',
    time: '10:35 AM',
  ),
  ChatMessage(
    id: 5,
    text: 'Sure, let me take some pics. Give me a minute \ud83d\udcf8',
    sender: 'other',
    time: '10:36 AM',
  ),
  ChatMessage(
    id: 6,
    text: 'Here they are! All in excellent condition.',
    sender: 'other',
    time: '10:40 AM',
  ),
  ChatMessage(
    id: 7,
    text: 'These look amazing! I\'d love to swap. When can we meet?',
    sender: 'me',
    time: '10:42 AM',
  ),
];
