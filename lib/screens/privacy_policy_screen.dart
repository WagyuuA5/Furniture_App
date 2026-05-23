// lib/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  static const Color _primary = Color(0xFF2D6A6A);
  static const Color _bg = Color(0xFFFAFAF8);

  // UPDATE AREA: Ganti konten kebijakan privasi sesuai kebutuhan bisnis Anda
  static const String _lastUpdated = '1 Juni 2025';
  static const String _appName = 'Aplikasi Kami';
  static const String _companyName = 'PT Nama Perusahaan Anda';
  static const String _contactEmail = 'privacy@perusahaan.com';

  final List<_PolicySection> _sections = const [
    _PolicySection(
      title: '1. Informasi yang Kami Kumpulkan',
      content:
          'Kami mengumpulkan berbagai jenis informasi sehubungan dengan layanan yang kami berikan, termasuk:\n\n'
          '• Informasi Identitas: nama lengkap, foto profil, tanggal lahir, dan jenis kelamin.\n\n'
          '• Informasi Kontak: alamat email, nomor telepon, dan alamat pengiriman.\n\n'
          '• Informasi Transaksi: rincian pembelian, metode pembayaran, dan riwayat pesanan.\n\n'
          '• Informasi Teknis: alamat IP, jenis perangkat, sistem operasi, versi aplikasi, dan log aktivitas.\n\n'
          '• Informasi Lokasi: lokasi Anda saat menggunakan layanan, apabila Anda memberikan izin.',
    ),
    _PolicySection(
      title: '2. Cara Kami Menggunakan Informasi Anda',
      content:
          'Informasi yang kami kumpulkan digunakan untuk tujuan-tujuan berikut:\n\n'
          '• Memproses dan memenuhi pesanan Anda.\n\n'
          '• Mengelola akun dan memberikan layanan pelanggan.\n\n'
          '• Mengirimkan notifikasi terkait pesanan, promosi, atau pembaruan layanan.\n\n'
          '• Meningkatkan kualitas produk, fitur, dan pengalaman pengguna.\n\n'
          '• Memenuhi kewajiban hukum dan peraturan yang berlaku.\n\n'
          '• Mencegah penipuan, penyalahgunaan, dan aktivitas ilegal lainnya.',
    ),
    _PolicySection(
      title: '3. Berbagi Informasi dengan Pihak Ketiga',
      content:
          'Kami tidak menjual, menyewakan, atau memperdagangkan informasi pribadi Anda kepada pihak ketiga. '
          'Namun, kami dapat berbagi informasi Anda dengan:\n\n'
          '• Mitra pengiriman untuk memenuhi pesanan Anda.\n\n'
          '• Penyedia layanan pembayaran yang memproses transaksi.\n\n'
          '• Penyedia layanan teknologi yang membantu operasional platform kami.\n\n'
          '• Otoritas hukum apabila diwajibkan oleh hukum yang berlaku.\n\n'
          'Semua mitra pihak ketiga kami terikat oleh perjanjian kerahasiaan dan wajib melindungi data Anda.',
    ),
    _PolicySection(
      title: '4. Keamanan Data',
      content:
          'Kami menerapkan langkah-langkah keamanan teknis dan organisasi yang ketat untuk melindungi informasi Anda, termasuk:\n\n'
          '• Enkripsi data menggunakan protokol SSL/TLS.\n\n'
          '• Pembatasan akses data hanya kepada karyawan yang memerlukan.\n\n'
          '• Audit keamanan berkala.\n\n'
          '• Sistem pemantauan ancaman secara real-time.\n\n'
          'Meskipun demikian, tidak ada metode transmisi data melalui internet yang 100% aman. '
          'Anda bertanggung jawab menjaga kerahasiaan kredensial akun Anda.',
    ),
    _PolicySection(
      title: '5. Hak-Hak Anda',
      content:
          'Sebagai pengguna, Anda memiliki hak-hak berikut terhadap data pribadi Anda:\n\n'
          '• Hak Akses: meminta salinan data pribadi yang kami simpan.\n\n'
          '• Hak Koreksi: memperbarui atau memperbaiki data yang tidak akurat.\n\n'
          '• Hak Penghapusan: meminta penghapusan data pribadi Anda.\n\n'
          '• Hak Pembatasan: membatasi cara kami memproses data Anda.\n\n'
          '• Hak Portabilitas: menerima data Anda dalam format yang dapat dibaca mesin.\n\n'
          'Untuk menggunakan hak-hak tersebut, silakan hubungi kami melalui email yang tercantum di bawah ini.',
    ),
    _PolicySection(
      title: '6. Retensi Data',
      content:
          'Kami menyimpan data pribadi Anda selama akun Anda aktif atau selama diperlukan untuk menyediakan layanan. '
          'Apabila Anda menutup akun, kami akan menghapus atau menganonimkan data Anda dalam waktu 90 hari, '
          'kecuali ada kewajiban hukum untuk menyimpannya lebih lama.',
    ),
    _PolicySection(
      title: '7. Cookie dan Teknologi Pelacakan',
      content:
          'Aplikasi kami menggunakan cookie dan teknologi serupa untuk:\n\n'
          '• Mengingat preferensi dan pengaturan Anda.\n\n'
          '• Menganalisis penggunaan aplikasi untuk peningkatan layanan.\n\n'
          '• Menyajikan iklan yang relevan (jika berlaku).\n\n'
          'Anda dapat mengatur preferensi cookie melalui pengaturan perangkat Anda.',
    ),
    _PolicySection(
      title: '8. Layanan Pihak Ketiga',
      content:
          'Aplikasi kami dapat berisi tautan ke situs web atau layanan pihak ketiga. '
          'Kebijakan privasi kami tidak berlaku untuk layanan tersebut. '
          'Kami mendorong Anda untuk membaca kebijakan privasi dari setiap layanan pihak ketiga yang Anda gunakan.',
    ),
    _PolicySection(
      title: '9. Privasi Anak-Anak',
      content:
          'Layanan kami tidak ditujukan untuk anak-anak di bawah usia 13 tahun. '
          'Kami tidak secara sengaja mengumpulkan informasi pribadi dari anak-anak. '
          'Jika Anda mengetahui bahwa anak Anda telah memberikan informasi kepada kami, '
          'silakan hubungi kami segera.',
    ),
    _PolicySection(
      title: '10. Perubahan Kebijakan Privasi',
      content:
          'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. '
          'Perubahan signifikan akan kami beritahukan melalui notifikasi dalam aplikasi atau email. '
          'Penggunaan layanan kami setelah perubahan diterbitkan berarti Anda menyetujui kebijakan yang diperbarui.',
    ),
    _PolicySection(
      title: '11. Hubungi Kami',
      content:
          'Jika Anda memiliki pertanyaan, kekhawatiran, atau permintaan terkait kebijakan privasi ini, '
          'silakan hubungi kami:\n\n'
          '📧 Email: privacy@perusahaan.com\n\n'
          '🏢 Alamat: Jl. Contoh No. 123, Jakarta Selatan 12345\n\n'
          '📞 Telepon: +62 21-1234-5678\n\n'
          'Tim kami akan merespons dalam waktu maksimal 5 hari kerja.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
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
                    child: Text(
                      'Kebijakan Privasi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
                children: [
                  // ── Intro Card ──
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _primary.withOpacity(0.15), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shield_outlined,
                                color: _primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Perlindungan Data Anda',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kebijakan Privasi ini menjelaskan bagaimana $_companyName '
                          'mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda '
                          'saat menggunakan $_appName.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF444444),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Terakhir diperbarui: $_lastUpdated',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Policy Sections ──
                  ...List.generate(_sections.length, (i) {
                    final section = _sections[i];
                    return _buildSection(section);
                  }),

                  const SizedBox(height: 16),

                  // ── Footer ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline_rounded,
                            color: Color(0xFF2D6A6A), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ada pertanyaan?',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                _contactEmail,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: _primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(_PolicySection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          iconColor: _primary,
          collapsedIconColor: const Color(0xFF9E9E9E),
          title: Text(
            section.title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          children: [
            Divider(height: 1, color: Colors.grey[100]),
            const SizedBox(height: 12),
            Text(
              section.content,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF555555),
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final String content;
  const _PolicySection({required this.title, required this.content});
}