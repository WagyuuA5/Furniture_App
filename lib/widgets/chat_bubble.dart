// lib/widgets/chat_bubble.dart
// Bubble pesan — teks & gambar, kanan (saya) & kiri (lawan)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../utils/constants.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showTime;   // tampilkan timestamp di bawah bubble

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left:  isMe ? 60 : 12,
        right: isMe ? 12 : 60,
        top: 2, bottom: showTime ? 4 : 2,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // ── Bubble ────────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: isMe ? ChatColors.bubbleMe : ChatColors.bubbleOther,
              borderRadius:
                  isMe ? ChatRadius.bubbleMe : ChatRadius.bubbleOther,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: message.type == MessageType.image
                ? _buildImageBubble(context)
                : _buildTextBubble(),
          ),

          // ── Timestamp ─────────────────────────────────────────────────────
          if (showTime) ...[
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: ChatColors.textSec,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    message.isRead
                        ? Icons.done_all_rounded
                        : Icons.done_rounded,
                    size: 12,
                    color: message.isRead
                        ? ChatColors.primary
                        : ChatColors.textSec,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Teks ──────────────────────────────────────────────────────────────────
  Widget _buildTextBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        message.content,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: isMe ? ChatColors.textMe : ChatColors.textOther,
          height: 1.4,
        ),
      ),
    );
  }

  // ── Gambar ────────────────────────────────────────────────────────────────
  Widget _buildImageBubble(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullscreen(context),
      child: ClipRRect(
        borderRadius:
            isMe ? ChatRadius.bubbleMe : ChatRadius.bubbleOther,
        child: Image.network(
          message.content,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 200, height: 200,
            color: ChatColors.inputBg,
            child: const Icon(Icons.broken_image_rounded,
                size: 48, color: ChatColors.textSec),
          ),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              width: 200, height: 200,
              color: ChatColors.inputBg,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ChatColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Fullscreen image viewer ────────────────────────────────────────────────
  void _openFullscreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenImage(url: message.content),
      ),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────────────────────────────
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ChatColors.bubbleOther,
              borderRadius: ChatRadius.bubbleOther,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _ctrl,
                      curve: Interval(i * 0.2, 0.6 + i * 0.2,
                          curve: Curves.easeInOut),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                      color: ChatColors.textSec,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fullscreen Image ──────────────────────────────────────────────────────────
class _FullscreenImage extends StatelessWidget {
  final String url;
  const _FullscreenImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image_rounded,
                      color: Colors.white, size: 60)),
        ),
      ),
    );
  }
}