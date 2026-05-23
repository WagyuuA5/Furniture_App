// lib/screens/search_screen.dart
// UPDATE: tambah tab "Distributor/Chat" — hasil pencarian bisa langsung chat

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart' hide AppColors;
import '../models/product.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../screens/product_detail_screen.dart';
import '../screens/chat_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ctrl  = TextEditingController();
  final FocusNode             _focus = FocusNode();

  List<String> _history = ['Meja', 'Meja', 'Meja', 'Meja'];
  String _query = '';

  // Filter produk
  List<ProductModel> get _productResults {
    if (_query.isEmpty) return [];
    return AppData.flashSaleProducts
        .where((p) =>
            p.name.toLowerCase().contains(_query.toLowerCase()) ||
            p.categoryId.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  // Filter chat/distributor
  List<ChatModel> _chatResults = [];

  void _searchChats(String q) {
    ChatService().chatListStream.first.then((list) {
      if (!mounted) return;
      setState(() {
        _chatResults = q.isEmpty
            ? []
            : list
                .where((c) =>
                    c.userName.toLowerCase().contains(q.toLowerCase()) ||
                    c.lastMessage.toLowerCase().contains(q.toLowerCase()))
                .toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    setState(() => _query = v);
    _searchChats(v);
  }

  void _submit(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    setState(() {
      _history.remove(q);
      _history.insert(0, q);
      if (_history.length > 8) _history.removeLast();
    });
  }

  void _removeHistory(String item) =>
      setState(() => _history.remove(item));

  void _clearAll() => setState(() => _history.clear());

  void _selectHistory(String item) {
    _ctrl.text = item;
    _ctrl.selection =
        TextSelection.fromPosition(TextPosition(offset: item.length));
    setState(() => _query = item);
    _searchChats(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            Expanded(
              child: _query.isEmpty
                  ? _buildIdleState()
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(AppRadius.searchBar),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search_rounded,
                      size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari produk atau distributor...',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: _onChanged,
                      onSubmitted: _submit,
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _ctrl.clear();
                        setState(() {
                          _query = '';
                          _chatResults = [];
                        });
                        _focus.requestFocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.close_rounded,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    )
                  else
                    const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Idle State ─────────────────────────────────────────────────────────────
  Widget _buildIdleState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        if (_history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pencarian Terbaru',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              GestureDetector(
                onTap: _clearAll,
                child: Text('Hapus Semua',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._history.map((h) => _HistoryTile(
                text: h,
                onTap: () => _selectHistory(h),
                onRemove: () => _removeHistory(h),
              )),
          const SizedBox(height: 20),
        ],
        Text('Ulasan Terbaru',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        ...AppData.flashSaleProducts.map((p) => _ProductRow(
              product: p,
              onTap: () => _goDetail(p),
            )),
      ],
    );
  }

  // ── Hasil Pencarian ────────────────────────────────────────────────────────
  Widget _buildResults() {
    final hasProducts = _productResults.isNotEmpty;
    final hasChats    = _chatResults.isNotEmpty;

    if (!hasProducts && !hasChats) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56,
                color: AppColors.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text('Tidak ditemukan',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text('"$_query"',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // ── Produk ────────────────────────────────────────────────────────
        if (hasProducts) ...[
          _SectionHeader(
              label: 'Produk',
              count: _productResults.length),
          const SizedBox(height: 10),
          ..._productResults.map((p) => _ProductRow(
                product: p,
                onTap: () => _goDetail(p),
              )),
          const SizedBox(height: 16),
        ],

        // ── Distributor / Chat ─────────────────────────────────────────────
        if (hasChats) ...[
          _SectionHeader(
              label: 'Distributor / Chat',
              count: _chatResults.length),
          const SizedBox(height: 10),
          ..._chatResults.map((c) => _DistributorRow(
                chat: c,
                onChat: () => _openChat(c),
              )),
        ],
      ],
    );
  }

  void _goDetail(ProductModel product) {
    _submit(_query);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product)));
  }

  void _openChat(ChatModel chat) {
    _submit(_query);
    ChatService().markAsRead(chat.id);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (_) => ChatDetailScreen(chat: chat)));
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4ED),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C6E49))),
        ),
      ],
    );
  }
}

// ── History Tile ───────────────────────────────────────────────────────────────
class _HistoryTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  const _HistoryTile(
      {required this.text, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textPrimary)),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Text('X',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product Row ────────────────────────────────────────────────────────────────
class _ProductRow extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ProductRow({required this.product, required this.onTap});

  String _fmt(double v) {
    final p = v.toStringAsFixed(0).split('');
    final b = StringBuffer();
    for (int i = 0; i < p.length; i++) {
      if (i > 0 && (p.length - i) % 3 == 0) b.write('.');
      b.write(p[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90, height: 90,
                color: AppColors.softGray,
                child: product.imageUrl.isNotEmpty
                    ? Image.network(product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.chair_outlined,
                            size: 36,
                            color: AppColors.textSecondary))
                    : const Icon(Icons.chair_outlined,
                        size: 36, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(product.name,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(product.categoryId,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('${_fmt(product.price)} | jumlah: 1',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Distributor Row ────────────────────────────────────────────────────────────
class _DistributorRow extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onChat;
  const _DistributorRow({required this.chat, required this.onChat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEECE8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColorFor(chat.userName),
            child: Text(chat.initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.userName,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A))),
                Text(chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF8A8A8A))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Tombol Chat
          GestureDetector(
            onTap: onChat,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C6E49),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('Chat',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}