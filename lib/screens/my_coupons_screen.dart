// lib/screens/my_coupons_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCouponsScreen extends StatefulWidget {
  const MyCouponsScreen({super.key});

  @override
  State<MyCouponsScreen> createState() => _MyCouponsScreenState();
}

class _MyCouponsScreenState extends State<MyCouponsScreen> {
  static const Color _primary = Color(0xFF2D6A6A);

  // UPDATE AREA: Ganti dengan data dari API/backend
  final List<_CouponItem> _coupons = [
    _CouponItem(
      kode: 'HEMAT20',
      nama: 'Diskon Spesial 20%',
      diskon: 'Diskon 20%',
      minBelanja: 'Min. belanja Rp 200.000',
      berlakuHingga: '31 Desember 2025',
      isAktif: false,
    ),
    _CouponItem(
      kode: 'ONGKIR50',
      nama: 'Gratis Ongkir 50%',
      diskon: 'Diskon Ongkir 50%',
      minBelanja: 'Min. belanja Rp 100.000',
      berlakuHingga: '30 Juni 2026',
      isAktif: true,
    ),
    _CouponItem(
      kode: 'NEWUSER15',
      nama: 'Pengguna Baru 15%',
      diskon: 'Diskon 15%',
      minBelanja: 'Min. belanja Rp 150.000',
      berlakuHingga: '31 Agustus 2026',
      isAktif: true,
    ),
    _CouponItem(
      kode: 'FLASH30',
      nama: 'Flash Sale 30%',
      diskon: 'Diskon 30%',
      minBelanja: 'Min. belanja Rp 300.000',
      berlakuHingga: '1 Januari 2025',
      isAktif: false,
    ),
  ];

  int get _totalAktif => _coupons.where((c) => c.isAktif).length;

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
                    child: Text('Kupon Saya',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Total kupon banner
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D6A6A), Color(0xFF1A4040)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.discount_outlined,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Kupon Saya',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$_totalAktif Kupon Aktif',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _coupons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _CouponCard(
                  coupon: _coupons[i],
                  onGunakanSekarang: _coupons[i].isAktif
                      ? () {
                          // UPDATE AREA: Navigasi ke halaman belanja dengan kupon diterapkan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Kupon "${_coupons[i].kode}" berhasil disalin',
                                  style: GoogleFonts.poppins()),
                              backgroundColor: _primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final _CouponItem coupon;
  final VoidCallback? onGunakanSekarang;

  static const Color _primary = Color(0xFF2D6A6A);

  const _CouponCard({required this.coupon, this.onGunakanSekarang});

  @override
  Widget build(BuildContext context) {
    final expired = !coupon.isAktif;

    return Opacity(
      opacity: expired ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: expired
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Sisi kiri (diskon)
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: expired ? Colors.grey[200] : _primary.withOpacity(0.1),
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  coupon.diskon,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: expired ? Colors.grey : _primary,
                  ),
                ),
              ),
            ),

            // Garis putus-putus
            Column(
              children: List.generate(
                8,
                (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    width: 1,
                    height: 6,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),

            // Sisi kanan (detail)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.nama,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: expired
                                ? Colors.grey.withOpacity(0.15)
                                : Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            expired ? 'Kedaluwarsa' : 'Aktif',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: expired ? Colors.grey : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon.minBelanja,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Berlaku hingga ${coupon.berlakuHingga}',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.grey[400]),
                    ),
                    if (!expired) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onGunakanSekarang,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text('Gunakan Sekarang',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponItem {
  final String kode;
  final String nama;
  final String diskon;
  final String minBelanja;
  final String berlakuHingga;
  final bool isAktif;

  const _CouponItem({
    required this.kode,
    required this.nama,
    required this.diskon,
    required this.minBelanja,
    required this.berlakuHingga,
    required this.isAktif,
  });
}