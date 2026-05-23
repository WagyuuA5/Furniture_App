// lib/services/chat_service.dart
//
// Abstraksi service chat dengan dua mode:
//  - DUMMY mode  : pakai in-memory StreamController (default, tanpa Firebase)
//  - FIREBASE mode: uncomment bagian Firestore dan ganti _useDummy = false
//
// Cara pakai:
//   final svc = ChatService();
//   svc.messagesStream('chat_1').listen((msgs) { ... });
//   svc.sendMessage('chat_1', content, type);

import 'dart:async';
import '../models/message_model.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';

class ChatService {
  // ── Singleton ───────────────────────────────────────────────────────────────
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  static const bool _useDummy = true; // set false untuk Firebase

  // ── In-memory state (dummy mode) ────────────────────────────────────────────
  final Map<String, List<MessageModel>> _messages = {};
  final Map<String, StreamController<List<MessageModel>>> _controllers = {};
  final Map<String, bool> _typingStatus = {};

  // Chat list stream controller
  final StreamController<List<ChatModel>> _chatListCtrl =
      StreamController<List<ChatModel>>.broadcast();
  List<ChatModel> _chatList = ChatModel.dummyList();

  // ── Chat List Stream ─────────────────────────────────────────────────────────
  Stream<List<ChatModel>> get chatListStream {
    // Emit data awal
    Future.microtask(() => _chatListCtrl.add(_chatList));
    return _chatListCtrl.stream;
  }

  // ── Messages Stream per chatId ───────────────────────────────────────────────
  Stream<List<MessageModel>> messagesStream(String chatId) {
    if (!_messages.containsKey(chatId)) {
      _messages[chatId] = MessageModel.dummyFor(chatId);
    }
    if (!_controllers.containsKey(chatId)) {
      _controllers[chatId] =
          StreamController<List<MessageModel>>.broadcast();
    }
    // Emit data awal
    Future.microtask(() =>
        _controllers[chatId]!.add(List.from(_messages[chatId]!)));
    return _controllers[chatId]!.stream;
  }

  // ── Kirim Pesan ──────────────────────────────────────────────────────────────
  Future<void> sendMessage(
    String chatId,
    String content,
    MessageType type,
  ) async {
    if (_useDummy) {
      final msg = MessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: kCurrentUserId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
      );

      _messages.putIfAbsent(chatId, () => []);
      _messages[chatId]!.add(msg);
      _controllers[chatId]?.add(List.from(_messages[chatId]!));

      // Update chat list (last message)
      _updateChatListLastMsg(chatId, content);

      // Simulasi balasan otomatis setelah 1.5 detik
      Future.delayed(const Duration(milliseconds: 1500), () {
        _simulateReply(chatId);
      });
    }
    // TODO Firebase:
    // await FirebaseFirestore.instance
    //   .collection('chats/$chatId/messages')
    //   .add({ 'senderId': kCurrentUserId, 'content': content, ... });
  }

  // ── Simulasi balasan (dummy mode) ────────────────────────────────────────────
  void _simulateReply(String chatId) {
    final replies = [
      'Baik, terima kasih informasinya 😊',
      'Oke kak, saya pertimbangkan dulu ya',
      'Boleh minta foto produknya?',
      'Apakah bisa dikirim ke Malang?',
      'Harga sudah termasuk ongkir?',
    ];
    replies.shuffle();
    final chat = _chatList.firstWhere((c) => c.id == chatId,
        orElse: () => _chatList.first);
    final reply = MessageModel(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      senderId: chat.userId,
      content: replies.first,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
    _messages[chatId]?.add(reply);
    _controllers[chatId]?.add(List.from(_messages[chatId]!));
    _updateChatListLastMsg(chatId, replies.first);
  }

  // ── Typing Indicator ─────────────────────────────────────────────────────────
  final StreamController<Map<String, bool>> _typingCtrl =
      StreamController<Map<String, bool>>.broadcast();

  Stream<Map<String, bool>> get typingStream => _typingCtrl.stream;

  void setTyping(String chatId, bool isTyping) {
    _typingStatus[chatId] = isTyping;
    _typingCtrl.add(Map.from(_typingStatus));

    // Update chat list
    _chatList = _chatList.map((c) {
      if (c.id == chatId) return c.copyWith(isTyping: isTyping);
      return c;
    }).toList();
    _chatListCtrl.add(_chatList);
  }

  // ── Tandai pesan sudah dibaca ─────────────────────────────────────────────────
  void markAsRead(String chatId) {
    _chatList = _chatList.map((c) {
      if (c.id == chatId) return c.copyWith(unreadCount: 0);
      return c;
    }).toList();
    _chatListCtrl.add(_chatList);
  }

  // ── Helper update chat list ───────────────────────────────────────────────────
  void _updateChatListLastMsg(String chatId, String message) {
    _chatList = _chatList.map((c) {
      if (c.id == chatId) {
        return c.copyWith(lastMessage: message, lastTime: DateTime.now());
      }
      return c;
    }).toList();
    _chatListCtrl.add(_chatList);
  }

  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.close();
    }
    _chatListCtrl.close();
    _typingCtrl.close();
  }
}