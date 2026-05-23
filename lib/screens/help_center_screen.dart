// lib/screens/help_center_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF2D6A6A);

  final _searchCtrl = TextEditingController();
  late TabController _tabCtrl;
  String _searchQuery = '';

  final List<String> _tabs = ['Semua', 'Layanan', 'Umum', 'Akun'];

  final List<_FaqItem> _faqs = [
    _FaqItem(
      pertanyaan: 'Dapatkah saya melacak status pengiriman pesanan?',
      jawaban:
          'Ya, Anda dapat melacak status pengiriman pesanan melalui halaman "Pesanan Saya". Pilih pesanan yang ingin dilacak, lalu tekan tombol "Lihat Detail". Di halaman detail, Anda akan menemukan informasi lengkap mengenai status pengiriman beserta nomor resi yang dapat digunakan untuk melacak paket melalui situs resmi kurir.',
      kategori: 'Layanan',
    ),
    _FaqItem(
      pertanyaan: 'Apakah ada kebijakan pengembalian barang?',
      jawaban:
          'Ya, kami menyediakan kebijakan pengembalian barang dalam waktu 7 hari setelah barang diterima. Barang harus dalam kondisi asli, belum digunakan, dan dengan kemasan lengkap. Untuk mengajukan pengembalian, buka halaman "Pesanan Saya", pilih pesanan yang ingin dikembalikan, lalu tekan "Ajukan Pengembalian".',
      kategori: 'Layanan',
    ),
    _FaqItem(
      pertanyaan: 'Dapatkah saya menyimpan item favorit?',
      jawaban:
          'Tentu! Anda dapat menyimpan produk favorit dengan menekan ikon hati (♥) pada halaman produk atau di daftar produk. Semua produk favorit akan tersimpan di halaman "Wishlist" yang dapat diakses melalui menu navigasi bawah.',
      kategori: 'Umum',
    ),
    _FaqItem(
      pertanyaan: 'Dapatkah saya membagikan produk kepada teman?',
      jawaban:
          'Ya! Pada halaman detail produk, Anda dapat menemukan tombol berbagi (share). Tekan tombol tersebut untuk membagikan tautan produk melalui berbagai platform seperti WhatsApp, Instagram, atau media sosial lainnya.',
      kategori: 'Umum',
    ),
    _FaqItem(
      pertanyaan: 'Bagaimana cara menghubungi layanan pelanggan?',
      jawaban:
          'Anda dapat menghubungi layanan pelanggan kami melalui beberapa cara:\n• WhatsApp: (480) 555-0103\n• Email: support@aplikasi.com\n• Live Chat di aplikasi (jam operasional 08.00–21.00 WIB)\n• Media sosial resmi kami di Instagram, Facebook, atau Twitter.',
      kategori: 'Layanan',
    ),
    _FaqItem(
      pertanyaan: 'Metode pembayaran apa saja yang diterima?',
      jawaban:
          'Kami menerima berbagai metode pembayaran, antara lain:\n• Kartu kredit/debit (Visa, Mastercard)\n• Transfer bank\n• E-wallet (GoPay, OVO, DANA, ShopeePay)\n• PayPal\n• Google Pay & Apple Pay\n• Bayar di tempat (COD) untuk wilayah tertentu.',
      kategori: 'Layanan',
    ),
    _FaqItem(
      pertanyaan: 'Bagaimana cara menambahkan ulasan produk?',
      jawaban:
          'Setelah pesanan selesai, Anda dapat memberikan ulasan pada produk yang dibeli melalui halaman "Pesanan Saya". Pilih pesanan yang sudah selesai, lalu tekan tombol "Beri Ulasan". Anda dapat memberikan rating bintang dan menulis komentar mengenai produk tersebut.',
      kategori: 'Akun',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_FaqItem> _filteredFaqs(String tab) {
    return _faqs.where((f) {
      final matchTab =
          tab == 'Semua' || f.kategori == tab;
      final matchSearch = _searchQuery.isEmpty ||
          f.pertanyaan.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  void _showKontakKami() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text('Hubungi Kami',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            _kontakItem(Icons.chat, 'WhatsApp', '(480) 555-0103',
                color: const Color(0xFF25D366)),
            _kontakItem(Icons.language, 'Website', 'www.aplikasi.com',
                color: _primary),
            _kontakItem(Icons.facebook, 'Facebook', '@aplikasiresmi',
                color: const Color(0xFF1877F2)),
            _kontakItem(Icons.alternate_email, 'Twitter / X', '@aplikasiresmi',
                color: Colors.black),
            _kontakItem(Icons.camera_alt_outlined, 'Instagram', '@aplikasiresmi',
                color: const Color(0xFFE1306C)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _kontakItem(IconData icon, String platform, String value,
      {required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(platform,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[500])),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  Expanded(
                    child: Text('Pusat Bantuan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Search
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari pertanyaan...',
                  hintStyle:
                      GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.grey, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabCtrl,
                indicatorColor: _primary,
                labelColor: _primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),

            // FAQ List
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: _tabs.map((tab) {
                  final faqs = _filteredFaqs(tab);
                  if (faqs.isEmpty) {
                    return Center(
                      child: Text('Tidak ada pertanyaan ditemukan',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 14)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: faqs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _FaqCard(faq: faqs[i]),
                  );
                }).toList(),
              ),
            ),

            // Tombol Kontak Kami
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showKontakKami,
                  icon: const Icon(Icons.headset_mic_outlined,
                      color: Colors.white, size: 20),
                  label: Text('Hubungi Kami',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  final _FaqItem faq;
  const _FaqCard({required this.faq});

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 14),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          trailing: Icon(
            _expanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: const Color(0xFF2D6A6A),
            size: 20,
          ),
          title: Text(
            widget.faq.pertanyaan,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          children: [
            Text(
              widget.faq.jawaban,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String pertanyaan;
  final String jawaban;
  final String kategori;
  const _FaqItem(
      {required this.pertanyaan,
      required this.jawaban,
      required this.kategori});
}