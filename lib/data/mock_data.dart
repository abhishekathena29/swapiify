// Static UI content for the home screen (category shortcuts and the
// "how it works" steps). All product/listing data is loaded live from
// Firestore — there is no mock product data in the app.

class CategoryItem {
  final String name;
  final String icon;

  const CategoryItem({required this.name, required this.icon});
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

const categories = <CategoryItem>[
  CategoryItem(name: 'Sports', icon: 'dumbbell'),
  CategoryItem(name: 'Toys', icon: 'gamepad'),
  CategoryItem(name: 'Books', icon: 'book'),
  CategoryItem(name: 'Clothes', icon: 'shirt'),
  CategoryItem(name: 'Accessories', icon: 'watch'),
  CategoryItem(name: 'Bags', icon: 'bag'),
];

const howItWorks = <HowItWorksStep>[
  HowItWorksStep(step: 1, title: 'Create Profile', icon: 'person_add'),
  HowItWorksStep(step: 2, title: 'List Items', icon: 'upload'),
  HowItWorksStep(step: 3, title: 'Find Matches', icon: 'search'),
  HowItWorksStep(step: 4, title: 'Make Offers', icon: 'chat'),
  HowItWorksStep(step: 5, title: 'Swap & Enjoy!', icon: 'party'),
];
