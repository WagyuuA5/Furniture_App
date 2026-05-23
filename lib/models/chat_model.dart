// lib/models/chat_model.dart
// Model untuk satu percakapan (chat room) di chat list

class ChatModel {
  final String id;
  final String userId;       // ID lawan bicara
  final String userName;     // Nama lawan bicara
  final String userAvatar;   // URL foto atau kosong → pakai inisial
  final String lastMessage;
  final DateTime lastTime;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;

  const ChatModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isTyping = false,
  });

  // Inisial untuk avatar fallback
  String get initials {
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return userName.isNotEmpty ? userName[0].toUpperCase() : '?';
  }

  ChatModel copyWith({
    String? lastMessage,
    DateTime? lastTime,
    int? unreadCount,
    bool? isOnline,
    bool? isTyping,
  }) {
    return ChatModel(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  // ── Data dummy ─────────────────────────────────────────────────────────────
  static List<ChatModel> dummyList() {
    final now = DateTime.now();
    return [
      ChatModel(
        id: 'chat_1',
        userId: 'u1',
        userName: 'Carla Schoen',
        userAvatar: '',
        lastMessage: 'Halo, apakah produk masih tersedia?',
        lastTime: now.subtract(const Duration(minutes: 2)),
        unreadCount: 3,
        isOnline: true,
      ),
      ChatModel(
        id: 'chat_2',
        userId: 'u2',
        userName: 'Sheila Lemke',
        userAvatar: '',
        lastMessage: 'Oke, saya tunggu konfirmasinya ya',
        lastTime: now.subtract(const Duration(minutes: 15)),
        unreadCount: 1,
        isOnline: true,
      ),
      ChatModel(
        id: 'chat_3',
        userId: 'u3',
        userName: 'Deanna Botsford V',
        userAvatar: '',
        lastMessage: 'Terima kasih sudah memesan!',
        lastTime: now.subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
      ChatModel(
        id: 'chat_4',
        userId: 'u4',
        userName: 'Mr. Katie Bergnaum',
        userAvatar: '',
        lastMessage: 'Bisa kirim ke luar kota?',
        lastTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 2,
        isOnline: false,
      ),
      ChatModel(
        id: 'chat_5',
        userId: 'u5',
        userName: 'Armando Ferry',
        userAvatar: '',
        lastMessage: 'Stok sofa putih masih ada?',
        lastTime: now.subtract(const Duration(hours: 5)),
        unreadCount: 0,
        isOnline: true,
      ),
      ChatModel(
        id: 'chat_6',
        userId: 'u6',
        userName: 'Annette Fritsch',
        userAvatar: '',
        lastMessage: 'Sudah saya transfer ya kak',
        lastTime: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
    ];
  }
}