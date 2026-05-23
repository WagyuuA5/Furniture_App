

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../utils/constants.dart';
import '../widgets/chat_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;
  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatService           _svc        = ChatService();
  final TextEditingController _inputCtrl  = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();
  final ImagePicker           _picker     = ImagePicker();

  StreamSubscription<List<MessageModel>>? _msgSub;
  List<MessageModel> _messages = [];
  bool _isTyping = false;        // lawan sedang mengetik
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _svc.markAsRead(widget.chat.id);

    // Subscribe ke pesan
    _msgSub = _svc.messagesStream(widget.chat.id).listen((msgs) {
      if (!mounted) return;
      setState(() => _messages = msgs);
      _scrollToBottom();
    });

    // Subscribe ke typing
    _svc.typingStream.listen((map) {
      if (!mounted) return;
      setState(() => _isTyping = map[widget.chat.id] ?? false);
    });
  }

  @override
  void dispose() {
    _msgSub?.cancel();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        if (animated) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent + 100);
        }
      }
    });
  }

  // ── Kirim teks ───────────────────────────────────────────────────────────────
  Future<void> _sendText() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    _inputCtrl.clear();
    await _svc.sendMessage(widget.chat.id, text, MessageType.text);
    setState(() => _isSending = false);
  }

  // ── Pilih & kirim gambar ─────────────────────────────────────────────────────
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ImageSourceSheet(
        onCamera: () async {
          Navigator.pop(context);
          final xf = await _picker.pickImage(source: ImageSource.camera);
          if (xf != null) _sendImageFile(xf.path);
        },
        onGallery: () async {
          Navigator.pop(context);
          final xf = await _picker.pickImage(source: ImageSource.gallery);
          if (xf != null) _sendImageFile(xf.path);
        },
      ),
    );
  }

  void _sendImageFile(String path) {
    // Simulasi: kirim path sebagai URL (produksi: upload ke storage dulu)
    _svc.sendMessage(widget.chat.id, path, MessageType.image);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Pesan ─────────────────────────────────────────────────────────
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (_isTyping && i == _messages.length) {
                        return const TypingIndicator();
                      }
                      final msg = _messages[i];
                      return ChatBubble(
                        message: msg,
                        isMe: msg.isMine(kCurrentUserId),
                      );
                    },
                  ),
          ),

          // ── Input ─────────────────────────────────────────────────────────
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ChatColors.surface,
      elevation: 0,
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ChatColors.bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: ChatColors.textPri),
        ),
      ),
      title: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: avatarColorFor(widget.chat.userName),
                child: Text(
                  widget.chat.initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 11, height: 11,
                  decoration: BoxDecoration(
                    color: widget.chat.isOnline
                        ? ChatColors.online
                        : ChatColors.offline,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Nama & status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chat.userName,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ChatColors.textPri,
                ),
              ),
              Text(
                _isTyping
                    ? 'sedang mengetik...'
                    : widget.chat.isOnline
                        ? 'Online'
                        : 'Offline',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: _isTyping
                      ? ChatColors.primary
                      : widget.chat.isOnline
                          ? ChatColors.online
                          : ChatColors.textSec,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Video call button
        IconButton(
          icon: const Icon(Icons.videocam_rounded,
              color: ChatColors.primary, size: 26),
          onPressed: () => _startVideoCall(),
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: ChatColors.divider),
      ),
    );
  }

  // ── Input Bar ─────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: ChatColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: ChatColors.inputBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.attach_file_rounded,
                    size: 20, color: ChatColors.textSec),
              ),
            ),
            const SizedBox(width: 8),

            // TextField
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: ChatColors.inputBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  maxLines: null,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: ChatColors.textPri),
                  decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: ChatColors.textSec),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  onChanged: (v) {
                    // Kirim sinyal typing ke service
                    if (v.isNotEmpty) {
                      _svc.setTyping(widget.chat.id, true);
                      Future.delayed(const Duration(seconds: 2), () {
                        _svc.setTyping(widget.chat.id, false);
                      });
                    }
                  },
                  onSubmitted: (_) => _sendText(),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Kirim
            GestureDetector(
              onTap: _sendText,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: ChatColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 56,
              color: ChatColors.textSec.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(
            'Mulai percakapan dengan\n${widget.chat.userName}',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 13, color: ChatColors.textSec),
          ),
        ],
      ),
    );
  }

  void _startVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video call ke ${widget.chat.userName}... (coming soon)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ChatColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    // TODO: Navigator.push ke VideoCallScreen
  }
}

// ── Image Source Bottom Sheet ─────────────────────────────────────────────────
class _ImageSourceSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  const _ImageSourceSheet(
      {required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFEEECE8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Pilih Sumber Foto',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SourceBtn(
                icon: Icons.camera_alt_rounded,
                label: 'Kamera',
                onTap: onCamera,
              )),
              const SizedBox(width: 12),
              Expanded(child: _SourceBtn(
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
                onTap: onGallery,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: ChatColors.primary),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}