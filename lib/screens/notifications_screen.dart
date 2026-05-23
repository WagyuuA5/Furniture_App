// lib/screens/notifications_screen.dart
// UPDATE: tampilkan ikon berbeda per tipe notif (promo, diskon, stok, chat, order)
// Tap notif chat → ChatDetailScreen
// Tap notif lainnya → detail promo (SnackBar info untuk sekarang)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import '../services/chat_service.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';
import 'chat_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notifSvc = NotificationService();
  final ChatService         _chatSvc  = ChatService();

  // Filter tab: semua / promo / chat / order
  String _activeTab = 'Semua';
  static const _tabs = ['Semua', 'Promo', 'Stok', 'Chat', 'Pesanan'];

  List<AppNotification> _filterByTab(List<AppNotification> list) {
    switch (_activeTab) {
      case 'Promo':
        return list.where((n) =>
            n.type == NotifType.promo || n.type == NotifType.diskon).toList();
      case 'Stok':
        return list.where((n) => n.type == NotifType.stok).toList();
      case 'Chat':
        return list.where((n) => n.type == NotifType.chat).toList();
      case 'Pesanan':
        return list.where((n) => n.type == NotifType.order).toList();
      default:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Tab filter ──────────────────────────────────────────────────
          _buildTabs(),
          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<AppNotification>>(
              stream: _notifSvc.stream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = _filterByTab(snap.data!);
                if (list.isEmpty) return _buildEmpty();
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (_, i) => _NotifTile(
                    notif: list[i],
                    onTap: () => _onTap(list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: Color(0xFF1A1A1A)),
        ),
      ),
      title: Text('Notifikasi',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A))),
      actions: [
        TextButton(
          onPressed: () {
            _notifSvc.markAllRead();
            setState(() {});
          },
          child: Text('Tandai semua',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: ChatColors.primary,
                  fontWeight: FontWeight.w600)),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEECE8)),
      ),
    );
  }

  // ── Filter Tabs ────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.map((tab) {
            final active = _activeTab == tab;
            return GestureDetector(
              onTap: () => setState(() => _activeTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: active
                      ? ChatColors.primary
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tab,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? Colors.white
                          : const Color(0xFF8A8A8A),
                    )),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 56,
              color: const Color(0xFF8A8A8A).withOpacity(0.3)),
          const SizedBox(height: 12),
          Text('Tidak ada notifikasi',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF8A8A8A))),
        ],
      ),
    );
  }

  void _onTap(AppNotification notif) {
    _notifSvc.markAsRead(notif.id);

    if (notif.type == NotifType.chat && notif.chatId != null) {
      // Buka chat
      _chatSvc.chatListStream.first.then((list) {
        final chat = list.firstWhere(
          (c) => c.id == notif.chatId,
          orElse: () => ChatModel(
            id: notif.chatId!,
            userId: 'unknown',
            userName: notif.title,
            userAvatar: '',
            lastMessage: '',
            lastTime: DateTime.now(),
          ),
        );
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(chat: chat)));
        }
      });
    } else {
      // Promo/diskon/stok — tampilkan detail singkat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notif.body,
              style: GoogleFonts.poppins(fontSize: 12)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ChatColors.primary,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

// ── Notification Tile ──────────────────────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  // Warna & ikon per tipe
  Color get _bgColor {
    switch (notif.type) {
      case NotifType.diskon:  return const Color(0xFFFFE0B2);
      case NotifType.promo:   return const Color(0xFFE8F5E9);
      case NotifType.stok:    return const Color(0xFFE3F2FD);
      case NotifType.chat:    return avatarColorFor(notif.title);
      case NotifType.order:   return const Color(0xFFF3E5F5);
      case NotifType.info:    return const Color(0xFFF5F5F5);
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.diskon:  return Icons.local_offer_rounded;
      case NotifType.promo:   return Icons.celebration_rounded;
      case NotifType.stok:    return Icons.inventory_2_rounded;
      case NotifType.chat:    return Icons.chat_bubble_rounded;
      case NotifType.order:   return Icons.shopping_bag_rounded;
      case NotifType.info:    return Icons.info_rounded;
    }
  }

  Color get _iconColor {
    switch (notif.type) {
      case NotifType.diskon:  return const Color(0xFFE65100);
      case NotifType.promo:   return const Color(0xFF2C6E49);
      case NotifType.stok:    return const Color(0xFF1565C0);
      case NotifType.chat:    return Colors.white;
      case NotifType.order:   return const Color(0xFF6A1B9A);
      case NotifType.info:    return const Color(0xFF8A8A8A);
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return DateFormat('dd MMM, HH:mm', 'id').format(dt);
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: notif.isRead
            ? Colors.transparent
            : ChatColors.primary.withOpacity(0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ikon / Avatar ──────────────────────────────────────────────
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: notif.type == NotifType.chat
                    ? avatarColorFor(notif.title)
                    : _bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: notif.type == NotifType.chat
                    ? Text(_initials(notif.title),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15))
                    : Icon(_icon, color: _iconColor, size: 22),
              ),
            ),
            const SizedBox(width: 12),

            // ── Konten ────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(notif.title,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: notif.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            )),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8, height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: ChatColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(notif.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF8A8A8A),
                          height: 1.4)),
                  const SizedBox(height: 5),
                  Text(_formatTime(notif.createdAt),
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFFAAAAAA))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}