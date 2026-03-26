class Seller {
  final String name;
  final double rating;
  final int swaps;

  const Seller({required this.name, required this.rating, required this.swaps});
}

class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String category;
  final String condition;
  final String location;
  final String postedAgo;
  final String wantsInReturn;
  final Seller seller;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.condition,
    required this.location,
    required this.postedAgo,
    required this.wantsInReturn,
    required this.seller,
  });
}
