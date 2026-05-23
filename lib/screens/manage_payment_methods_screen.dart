import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_card_screen.dart';

class ManagePaymentMethodsScreen extends StatelessWidget {
  const ManagePaymentMethodsScreen({super.key});

  static const Color _primary = Color(0xFF2D6A6A);
  static const Color _bg = Color(0xFFFAFAF8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Metode Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'E-Wallet',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _PaymentTile(icon: Icons.account_balance_wallet, title: 'GoPay', isConnected: true),
          const SizedBox(height: 10),
          _PaymentTile(icon: Icons.account_balance_wallet, title: 'DANA', isConnected: false),
          const SizedBox(height: 24),
          Text(
            'Transfer Bank',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _PaymentTile(icon: Icons.account_balance, title: 'Bank BCA', isConnected: true),
          const SizedBox(height: 10),
          _PaymentTile(icon: Icons.account_balance, title: 'Bank Mandiri', isConnected: false),
          const SizedBox(height: 24),
          Text(
            'Kartu Kredit / Debit',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCardScreen()),
              );
            },
            icon: const Icon(Icons.add, color: _primary),
            label: Text(
              'Tambah Kartu Baru',
              style: GoogleFonts.poppins(color: _primary, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: _primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isConnected;

  const _PaymentTile({required this.icon, required this.title, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          if (isConnected)
            Text(
              'Terhubung',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D6A6A),
              ),
            )
          else
            TextButton(
              onPressed: () {},
              child: Text(
                'Hubungkan',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
