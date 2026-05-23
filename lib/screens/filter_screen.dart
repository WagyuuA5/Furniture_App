// screens/filter_screen.dart
// Halaman filter produk – sesuai desain Gambar 1

import 'package:flutter/material.dart';
import '../models/filter_model.dart';
import '../utils/app_theme.dart';
import '../widgets/rating_widget.dart';

class FilterScreen extends StatefulWidget {
  final FilterModel initialFilter;

  const FilterScreen({Key? key, required this.initialFilter}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterModel _filter;

  final List<String> _categories = ['All', 'Sofa', 'Chair', 'Cupboard'];
  final List<String> _reviewRanges = [
    '4.5 and above',
    '4.0 - 4.5',
    '3.5 - 4.0',
    '3.0 - 3.5',
    '2.5 - 3.0',
  ];
  final List<String> _sortOptions = ['All', 'Popular', 'Most Recent', 'Price'];
  final List<String> _rooms = ['All', 'Living Room', 'Bedroom', 'Kitchen'];

  // Stars for each review range
  final List<int> _reviewStars = [5, 4, 3, 2, 2];
  final List<double> _reviewHalf = [5.0, 4.5, 4.0, 3.5, 3.0];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.chipUnselected,
            ),
            child: const Icon(Icons.arrow_back, size: 18),
          ),
        ),
        title: const Text('Filter'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Category', _buildCategoryChips()),
                  const SizedBox(height: 24),
                  _buildSection('Price Range', _buildPriceRange()),
                  const SizedBox(height: 24),
                  _buildSection('Reviews', _buildReviewOptions()),
                  const SizedBox(height: 24),
                  _buildSection('Sort by', _buildSortChips()),
                  const SizedBox(height: 24),
                  _buildSection('For', _buildRoomChips()),
                ],
              ),
            ),
          ),
          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _filter.reset());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Reset Filter',
                      style: TextStyle(
                          color: AppColors.textDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _filter),
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  // ─── Category Chips ──────────────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      children: _categories.map((cat) {
        final selected = _filter.category == cat;
        return GestureDetector(
          onTap: () => setState(() => _filter = _filter.copyWith(category: cat)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.chipSelected : AppColors.chipUnselected,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Price Range Slider ──────────────────────────────────────────────────────
  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: RangeValues(_filter.minPrice, _filter.maxPrice),
          min: 50,
          max: 400,
          divisions: 7,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.chipUnselected,
          onChanged: (v) => setState(() {
            _filter = _filter.copyWith(minPrice: v.start, maxPrice: v.end);
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['\$50', '\$100', '\$150', '\$200', '\$300', '\$350', '\$400']
                .map((e) => Text(e,
                    style: const TextStyle(fontSize: 10, color: AppColors.textGrey)))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ─── Review Radio Options ────────────────────────────────────────────────────
  Widget _buildReviewOptions() {
    return Column(
      children: List.generate(_reviewRanges.length, (i) {
        final label = _reviewRanges[i];
        final selected = _filter.reviewRange == label;
        return GestureDetector(
          onTap: () => setState(() {
            _filter = _filter.copyWith(reviewRange: selected ? '' : label);
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                StarDisplayWidget(
                  rating: _reviewHalf[i],
                  size: 20,
                  showNumber: false,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Radio<String>(
                  value: label,
                  groupValue: _filter.reviewRange,
                  activeColor: AppColors.primary,
                  onChanged: (v) =>
                      setState(() => _filter = _filter.copyWith(reviewRange: v)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── Sort By Chips ───────────────────────────────────────────────────────────
  Widget _buildSortChips() {
    return Wrap(
      spacing: 8,
      children: _sortOptions.map((opt) {
        final selected = _filter.sortBy == opt;
        return GestureDetector(
          onTap: () => setState(() => _filter = _filter.copyWith(sortBy: opt)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.chipSelected : AppColors.chipUnselected,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Room/For Chips ──────────────────────────────────────────────────────────
  Widget _buildRoomChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _rooms.map((room) {
        final selected = _filter.room == room;
        return GestureDetector(
          onTap: () => setState(() => _filter = _filter.copyWith(room: room)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.chipSelected : AppColors.chipUnselected,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              room,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}