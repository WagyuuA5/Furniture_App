// lib/models/message_model.dart
// Model untuk satu pesan dalam chat detail

enum MessageType { text, image, system }

class MessageModel {
  final String id;
  final String senderId;     // ID pengirim
  final String content;      // teks atau URL gambar
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  // Apakah pesan ini milik saya (current user)
  bool isMine(String currentUserId) => senderId == currentUserId;

  MessageModel copyWith({bool? isRead}) => MessageModel(
        id: id,
        senderId: senderId,
        content: content,
        type: type,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
      );

  // ── Dummy messages per chatId ──────────────────────────────────────────────
  static List<MessageModel> dummyFor(String chatId) {
    final now = DateTime.now();
    // 'me' = ID user saat ini (simulasi)
    const me = 'me';

    final Map<String, List<MessageModel>> data = {
      'chat_1': [
        MessageModel(id: 'm1', senderId: 'u1', content: 'Halo kak!', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 30))),
        MessageModel(id: 'm2', senderId: me,   content: 'Hai, ada yang bisa dibantu?', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 28))),
        MessageModel(id: 'm3', senderId: 'u1', content: 'Apakah sofa model Nordic masih ada?', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 25))),
        MessageModel(id: 'm4', senderId: me,   content: 'Masih ada kak, mau warna apa?', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 20))),
        MessageModel(id: 'm5', senderId: 'u1', content: 'Warna abu-abu ya. Berapa harganya?', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 15))),
        MessageModel(id: 'm6', senderId: me,   content: 'Rp 2.500.000 kak, sudah termasuk ongkos pasang', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 10))),
        MessageModel(id: 'm7', senderId: 'u1', content: 'Oke saya mau pesan 1 ya!', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 5))),
        MessageModel(id: 'm8', senderId: 'u1', content: 'Halo, apakah produk masih tersedia?', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 2))),
      ],
      'chat_2': [
        MessageModel(id: 'm1', senderId: me,   content: 'Selamat pagi kak Sheila!', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 2))),
        MessageModel(id: 'm2', senderId: 'u2', content: 'Pagi! Ada promo hari ini?', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 1, minutes: 55))),
        MessageModel(id: 'm3', senderId: me,   content: 'Ada diskon 20% untuk semua kursi kak', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 1, minutes: 50))),
        MessageModel(id: 'm4', senderId: 'u2', content: 'Oke, saya tunggu konfirmasinya ya', type: MessageType.text, timestamp: now.subtract(const Duration(minutes: 15))),
      ],
      'chat_3': [
        MessageModel(id: 'm1', senderId: 'u3', content: 'Pesanan sudah sampai kak!', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 3))),
        MessageModel(id: 'm2', senderId: me,   content: 'Alhamdulillah, terima kasih sudah berbelanja', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 2))),
        MessageModel(id: 'm3', senderId: 'u3', content: 'Terima kasih sudah memesan!', type: MessageType.text, timestamp: now.subtract(const Duration(hours: 1))),
      ],
    };

    return data[chatId] ??
        [
          MessageModel(
            id: 'm_default',
            senderId: 'other',
            content: 'Halo, ada yang bisa saya bantu?',
            type: MessageType.text,
            timestamp: now.subtract(const Duration(hours: 1)),
          ),
        ];
  }
}