import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';
import '../widgets/bottom_nav.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final List<String> _images = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _wantsController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  bool _isSubmitting = false;
  String? _errorMessage;

  static const categories = [
    'Electronics',
    'Fashion',
    'Books',
    'Sports',
    'Home & Garden',
    'Toys & Games',
    'Music',
    'Art & Collectibles',
  ];

  static const conditions = ['New', 'Like New', 'Good', 'Fair', 'For Parts'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _wantsController.dispose();
    super.dispose();
  }

  void _addImage() {
    if (_images.length >= 5) return;
    setState(() {
      _images.add(
        'https://picsum.photos/300?random=${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final items = context.read<ItemsProvider>();
    final profile = auth.profile;

    if (profile == null) {
      setState(() => _errorMessage = 'Please sign in to list an item.');
      return;
    }
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      setState(
        () => _errorMessage = 'Please fill in the title and description.',
      );
      return;
    }
    if (_selectedCategory == null || _selectedCondition == null) {
      setState(() => _errorMessage = 'Select a category and condition.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await items.addItem(
        input: AddItemInput(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory!,
          condition: _selectedCondition!,
          location: _locationController.text.trim().isEmpty
              ? 'Nearby'
              : _locationController.text.trim(),
          wantsInReturn: _wantsController.text.trim().isEmpty
              ? 'Open to offers'
              : _wantsController.text.trim(),
          images: _images,
        ),
        owner: profile,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Unable to list item. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                AppPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeading(
                        eyebrow: 'Create listing',
                        title: 'A cleaner way to post what you want to trade.',
                        subtitle:
                            'Keep the listing concise, visual, and easy for others to understand.',
                      ),
                      const SizedBox(height: 18),
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.destructive.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.destructive.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: AppColors.destructive,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const _FieldLabel('Photos'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 104,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              _images.length + (_images.length < 5 ? 1 : 0),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            if (index == _images.length) {
                              return InkWell(
                                onTap: _addImage,
                                borderRadius: BorderRadius.circular(22),
                                child: Container(
                                  width: 104,
                                  decoration: BoxDecoration(
                                    color: AppColors.highlight,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        color: AppColors.plumDark,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Add photo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.network(
                                    _images[index],
                                    width: 104,
                                    height: 104,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () =>
                                        setState(() => _images.removeAt(index)),
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.card.withValues(
                                          alpha: 0.92,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _FieldLabel('Title'),
                      const SizedBox(height: 8),
                      AppInput(
                        controller: _titleController,
                        hintText: 'What are you swapping?',
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Description'),
                      const SizedBox(height: 8),
                      AppInput(
                        controller: _descriptionController,
                        hintText:
                            'Describe the item and what makes it worth trading.',
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Location'),
                      const SizedBox(height: 8),
                      AppInput(
                        controller: _locationController,
                        hintText: 'Neighborhood or city',
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _DropdownField(
                              label: 'Category',
                              value: _selectedCategory,
                              hint: 'Choose',
                              items: categories,
                              onChanged: (value) =>
                                  setState(() => _selectedCategory = value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DropdownField(
                              label: 'Condition',
                              value: _selectedCondition,
                              hint: 'Choose',
                              items: conditions,
                              onChanged: (value) =>
                                  setState(() => _selectedCondition = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _FieldLabel('Preferred exchange'),
                      const SizedBox(height: 8),
                      AppInput(
                        controller: _wantsController,
                        hintText:
                            'Books, electronics, decor, or open to offers',
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: _isSubmitting
                            ? 'Publishing...'
                            : 'Publish listing',
                        icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                        onPressed: _isSubmitting ? null : _submit,
                        size: AppButtonSize.xl,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNav(currentRoute: RouteNames.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: const InputDecoration(),
          hint: Text(hint),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(18),
        ),
      ],
    );
  }
}
