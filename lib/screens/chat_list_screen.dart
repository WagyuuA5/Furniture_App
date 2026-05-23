// lib/screens/chat_list_screen.dart
// Halaman daftar chat — dipanggil dari BottomNavBar index 2
// Fitur:
//  - Stream realtime dari ChatService
//  - Search bar filter nama user
//  - Badge unread count
//  - Status online/offline
//  - Tap → ChatDetailScreen

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';
import 'chat_detail_screen.dart';
import 'notifications_screen.dart';

class ChatListScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ChatListScreen({super.key, this.onBack});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService         _chatSvc  = ChatService();
  final NotificationService _notifSvc = NotificationService();
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';

  List<ChatModel> _filter(List<ChatModel> list) {
    if (_query.isEmpty) return list;
    return list
        .where((c) =>
            c.userName.toLowerCase().contains(_query.toLowerCase()) ||
            c.lastMessage.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          _buildSearchBar(),
          // ── Chat list ────────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: _chatSvc.chatListStream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = _filter(snap.data!);
                if (list.isEmpty) {
                  return _buildEmpty();
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 80,
                      color: Color(0xFFF0F0F0)),
                  itemBuilder: (_, i) => _ChatTile(
                    chat: list[i],
                    onTap: () => _openChat(list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          if (widget.onBack != null) widget.onBack!();
          else Navigator.of(context).pop();
        },
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
      title: Text(
        'Pesan',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        // Notifikasi bell dengan badge
        StreamBuilder<List<AppNotification>>(
          stream: _notifSvc.stream,
          builder: (_, snap) {
            final unread = snap.data?.where((n) => !n.isRead).length ?? 0;
            return GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen())),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        size: 20, color: Color(0xFF1A1A1A)),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 4, right: 16,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('$unread',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEECE8)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded,
              size: 20, color: Color(0xFF8A8A8A)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: 'Cari nama atau pesan...',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF8A8A8A)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.close_rounded,
                    size: 18, color: Color(0xFF8A8A8A)),
              ),
            )
          else
            const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 56,
              color: const Color(0xFF8A8A8A).withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            _query.isEmpty ? 'Belum ada percakapan' : 'Tidak ditemukan',
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }

  void _openChat(ChatModel chat) {
    _chatSvc.markAsRead(chat.id);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => ChatDetailScreen(chat: chat),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }
}

// ── Chat Tile ─────────────────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  const _ChatTile({required this.chat, required this.onTap});

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}j';
    return DateFormat('dd/MM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Avatar + online dot ──────────────────────────────────────
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: avatarColorFor(chat.userName),
                  child: Text(
                    chat.initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
                Positioned(
                  right: 1, bottom: 1,
                  child: Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: chat.isOnline
                          ? ChatColors.online
                          : ChatColors.offline,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // ── Nama + preview pesan ─────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: const Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Waktu
                      Text(
                        _formatTime(chat.lastTime),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: hasUnread
                              ? ChatColors.primary
                              : const Color(0xFF8A8A8A),
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.isTyping
                              ? 'sedang mengetik...'
                              : chat.lastMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: chat.isTyping
                                ? ChatColors.primary
                                : const Color(0xFF8A8A8A),
                            fontStyle: chat.isTyping
                                ? FontStyle.italic
                                : FontStyle.normal,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Badge unread
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 20, height: 20,
                          decoration: const BoxDecoration(
                            color: ChatColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${chat.unreadCount}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}