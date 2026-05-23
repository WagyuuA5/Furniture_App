// screens/product_list_screen.dart
// Halaman utama – daftar produk dengan filter aktif

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/filter_model.dart';
import '../utils/app_theme.dart';
import '../widgets/product_card.dart';
import 'filter_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  FilterModel _activeFilter = FilterModel();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> get _filteredProducts {
    List<ProductModel> list = List.from(dummyProducts);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by category
    if (_activeFilter.category != 'All') {
      list = list.where((p) => p.category == _activeFilter.category).toList();
    }

    // Filter by review range
    if (_activeFilter.reviewRange.isNotEmpty) {
      list = list
          .where((p) =>
              p.rating >= _activeFilter.minRating &&
              p.rating <= _activeFilter.maxRating)
          .toList();
    }

    // Filter by price range (only applies if using $ pricing; skip IDR)
    list = list.where((p) {
      if (p.price >= 10000) return true; // IDR – skip price filter
      return p.price >= _activeFilter.minPrice &&
          p.price <= _activeFilter.maxPrice;
    }).toList();

    // Sort
    if (_activeFilter.sortBy == 'Popular') {
      list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    } else if (_activeFilter.sortBy == 'Price') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeFilter.sortBy == 'Most Recent') {
      list = list.reversed.toList();
    }

    return list;
  }

  bool get _isFilterActive =>
      _activeFilter.category != 'All' ||
      _activeFilter.room != 'All' ||
      _activeFilter.reviewRange.isNotEmpty ||
      _activeFilter.sortBy != 'All';

  void _openFilter() async {
    final result = await Navigator.push<FilterModel>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialFilter: _activeFilter),
      ),
    );
    if (result != null) {
      setState(() => _activeFilter = result);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          '🛋  FurniShop',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textDark),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                // Search bar
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.chipUnselected,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Cari produk...',
                        hintStyle:
                            TextStyle(fontSize: 13, color: AppColors.textGrey),
                        prefixIcon: Icon(Icons.search,
                            size: 18, color: AppColors.textGrey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter button
                GestureDetector(
                  onTap: _openFilter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isFilterActive ? AppColors.primary : AppColors.chipUnselected,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20,
                      color: _isFilterActive ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ─── Active Filter Chips ───────────────────────────────────────
          if (_isFilterActive)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_activeFilter.category != 'All')
                      _activeChip(_activeFilter.category, () {
                        setState(() => _activeFilter =
                            _activeFilter.copyWith(category: 'All'));
                      }),
                    if (_activeFilter.room != 'All')
                      _activeChip(_activeFilter.room, () {
                        setState(() =>
                            _activeFilter = _activeFilter.copyWith(room: 'All'));
                      }),
                    if (_activeFilter.reviewRange.isNotEmpty)
                      _activeChip(_activeFilter.reviewRange, () {
                        setState(() => _activeFilter =
                            _activeFilter.copyWith(reviewRange: ''));
                      }),
                    if (_activeFilter.sortBy != 'All')
                      _activeChip('Sort: ${_activeFilter.sortBy}', () {
                        setState(() =>
                            _activeFilter = _activeFilter.copyWith(sortBy: 'All'));
                      }),
                  ],
                ),
              ),
            ),

          // ─── Product Count ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${products.length} Produk',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey),
                ),
              ],
            ),
          ),

          // ─── Product List ──────────────────────────────────────────────
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 60, color: AppColors.textGrey),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada produk yang cocok\ndengan filter ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => setState(() {}),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 20),
                      itemCount: products.length,
                      itemBuilder: (_, i) => ProductCard(
                        product: products[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: products[i]),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _activeChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}