// lib/services/notification_service.dart
// UPDATE: notifikasi diperbanyak — fokus pada PROMO & DISKON
//         chat tetap ada tapi lebih sedikit

import 'dart:async';

// ── Tipe notifikasi ────────────────────────────────────────────────────────────
enum NotifType { promo, diskon, stok, chat, order, info }

// ── Model ─────────────────────────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? chatId;       // null jika bukan notif chat
  final NotifType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.chatId,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  // Icon berdasarkan tipe
  String get iconLabel {
    switch (type) {
      case NotifType.promo:   return '🎉';
      case NotifType.diskon:  return '🏷️';
      case NotifType.stok:    return '📦';
      case NotifType.chat:    return '💬';
      case NotifType.order:   return '🛒';
      case NotifType.info:    return 'ℹ️';
    }
  }

  // ── Data dummy lengkap ───────────────────────────────────────────────────────
  static List<AppNotification> dummyList() {
    final now = DateTime.now();
    return [
      // ── PROMO & DISKON (terbanyak) ─────────────────────────────────────────
      AppNotification(
        id: 'd1',
        title: 'Flash Sale Dimulai! 🔥',
        body: 'Diskon hingga 50% untuk semua sofa premium. Hanya hari ini!',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: 'd2',
        title: 'Promo Harbolnas 12.12',
        body: 'Gratis ongkir + cashback 15% untuk semua pembelian furniture di atas Rp 500.000',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(minutes: 20)),
        isRead: false,
      ),
      AppNotification(
        id: 'd3',
        title: 'Diskon Akhir Tahun 30%',
        body: 'Kursi Nordic & Lemari Minimalis diskon 30% — berlaku sampai 31 Desember 2025',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: 'd4',
        title: 'Voucher Spesial Untukmu 🎁',
        body: 'Gunakan kode HEMAT20 untuk potongan Rp 200.000 pada pembelian pertamamu!',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 'd5',
        title: 'Weekend Sale — Lampu & Dekorasi',
        body: 'Semua produk lampu dan dekorasi ruang tamu diskon 25% setiap Sabtu-Minggu',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      AppNotification(
        id: 'd6',
        title: 'Cashback Rp 100.000',
        body: 'Bayar pakai QRIS & dapatkan cashback Rp 100.000 untuk transaksi di atas Rp 1.000.000',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      AppNotification(
        id: 'd7',
        title: 'Diskon Bundling Sofa + Meja',
        body: 'Beli sofa + meja sekaligus hemat Rp 350.000! Penawaran terbatas hanya 50 set.',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      AppNotification(
        id: 'd8',
        title: 'Member Exclusive Sale 👑',
        body: 'Khusus member terdaftar: diskon tambahan 10% di atas promo yang sedang berjalan',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      AppNotification(
        id: 'd9',
        title: 'Promo Paket Kamar Tidur',
        body: 'Kasur + Lemari + Meja Rias mulai Rp 3.500.000 — hemat hingga Rp 800.000!',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      AppNotification(
        id: 'd10',
        title: 'Segera Hadir: Big Sale Januari 🎊',
        body: 'Tandai kalendermu! Big Sale Januari dimulai 1 Jan — diskon hingga 70% semua kategori',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(hours: 10)),
        isRead: true,
      ),
      AppNotification(
        id: 'd11',
        title: 'Diskon Spesial Pelanggan Setia',
        body: 'Karena kamu sudah berbelanja 3x, nikmati diskon eksklusif 20% untuk order berikutnya',
        type: NotifType.diskon,
        createdAt: now.subtract(const Duration(hours: 12)),
        isRead: true,
      ),
      AppNotification(
        id: 'd12',
        title: 'Promo Gratis Ongkir Se-Jawa',
        body: 'Gratis ongkir ke seluruh Pulau Jawa untuk pembelian minimal Rp 300.000. Berlaku minggu ini!',
        type: NotifType.promo,
        createdAt: now.subtract(const Duration(hours: 14)),
        isRead: true,
      ),

      // ── STOK & PRODUK BARU ─────────────────────────────────────────────────
      AppNotification(
        id: 's1',
        title: 'Produk Baru: Sofa Scandinavian Pro',
        body: 'Sofa Scandinavian edisi terbaru kini tersedia. Stok terbatas — pesan sekarang!',
        type: NotifType.stok,
        createdAt: now.subtract(const Duration(hours: 7)),
        isRead: false,
      ),
      AppNotification(
        id: 's2',
        title: 'Stok Sofa Nordic Abu-abu Kembali',
        body: 'Sofa Nordic warna abu-abu yang kamu wishlist kini tersedia kembali. Jangan sampai kehabisan!',
        type: NotifType.stok,
        createdAt: now.subtract(const Duration(hours: 9)),
        isRead: true,
      ),
      AppNotification(
        id: 's3',
        title: 'Kursi Kantor Ergonomis Tiba!',
        body: 'Koleksi kursi ergonomis premium untuk home office kini hadir. Mulai dari Rp 1.200.000',
        type: NotifType.stok,
        createdAt: now.subtract(const Duration(hours: 16)),
        isRead: true,
      ),
      AppNotification(
        id: 's4',
        title: 'Lampu Minimalis Koleksi 2025',
        body: 'Desain terbaru lampu gantung & standing lamp kini tersedia di toko kami',
        type: NotifType.stok,
        createdAt: now.subtract(const Duration(hours: 20)),
        isRead: true,
      ),

      // ── ORDER ──────────────────────────────────────────────────────────────
      AppNotification(
        id: 'o1',
        title: 'Pesananmu Sedang Dikirim 🚚',
        body: 'Modern Accent Chair x1 sedang dalam perjalanan. Estimasi tiba 2-3 hari kerja.',
        type: NotifType.order,
        createdAt: now.subtract(const Duration(hours: 11)),
        isRead: true,
      ),
      AppNotification(
        id: 'o2',
        title: 'Pesanan Berhasil Dikonfirmasi ✅',
        body: 'Order #LXF-20250108 telah dikonfirmasi oleh seller. Segera diproses!',
        type: NotifType.order,
        createdAt: now.subtract(const Duration(hours: 22)),
        isRead: true,
      ),

      // ── CHAT (lebih sedikit) ────────────────────────────────────────────────
      AppNotification(
        id: 'c1',
        title: 'Carla Schoen',
        body: 'Halo, apakah produk masih tersedia?',
        chatId: 'chat_1',
        type: NotifType.chat,
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      AppNotification(
        id: 'c2',
        title: 'Armando Ferry',
        body: 'Stok sofa putih masih ada?',
        chatId: 'chat_5',
        type: NotifType.chat,
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: false,
      ),
    ];
  }
}

// ── Service ────────────────────────────────────────────────────────────────────
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = AppNotification.dummyList();
  final StreamController<List<AppNotification>> _ctrl =
      StreamController<List<AppNotification>>.broadcast();

  Stream<List<AppNotification>> get stream {
    Future.microtask(() => _ctrl.add(List.from(_notifications)));
    return _ctrl.stream;
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String body,
    String? chatId,
    NotifType type = NotifType.info,
  }) {
    final notif = AppNotification(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      chatId: chatId,
      type: type,
      createdAt: DateTime.now(),
    );
    _notifications.insert(0, notif);
    _ctrl.add(List.from(_notifications));
  }

  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx].isRead = true;
      _ctrl.add(List.from(_notifications));
    }
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    _ctrl.add(List.from(_notifications));
  }

  void dispose() => _ctrl.close();
}