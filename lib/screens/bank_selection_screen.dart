// lib/screens/bank_selection_screen.dart
//
// Halaman pilihan metode transfer bank / debit instan
// Desain sesuai gambar 2 (CIMB, BCA OneKlik, BRI + Tambah Debit Instan)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_card_screen.dart';

class _C {
  static const bg      = Color(0xFFF5F3EF);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1A1A1A);
  static const accent  = Color(0xFF2C5F52);
  static const orange  = Color(0xFFE8572A);
  static const textSec = Color(0xFF8A8A8A);
  static const divider = Color(0xFFEEECE8);
}

// ── Model bank ────────────────────────────────
class _BankOption {
  final String name;
  final Widget logo;
  bool isAdded;
  _BankOption(
      {required this.name, required this.logo, this.isAdded = false});
}

class BankSelectionScreen extends StatefulWidget {
  const BankSelectionScreen({super.key});

  @override
  State<BankSelectionScreen> createState() =>
      _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  late final List<_BankOption> _banks = [
    _BankOption(
        name: 'CIMB Direct Debit',
        logo: _OctoLogo()),
    _BankOption(
        name: 'BCA OneKlik',
        logo: _BcaLogo()),
    _BankOption(
        name: 'BRI Direct Debit',
        logo: _BriLogo()),
  ];

  void _onTambah(int index) {
    setState(() => _banks[index].isAdded = !_banks[index].isAdded);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        _banks[index].isAdded
            ? '${_banks[index].name} berhasil ditambahkan'
            : '${_banks[index].name} dihapus',
        style: GoogleFonts.poppins(fontSize: 13),
      ),
      backgroundColor: _C.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  void _onKonfirmasi() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final added = _banks.where((b) => b.isAdded).length;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Kartu bank list ──
                    Container(
                      decoration: BoxDecoration(
                        color: _C.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ..._banks.asMap().entries.map((e) {
                            final i = e.key;
                            final b = e.value;
                            return Column(
                              children: [
                                _BankTile(
                                  bank: b,
                                  onTambah: () => _onTambah(i),
                                ),
                                if (i < _banks.length - 1)
                                  const Divider(
                                      color: _C.divider,
                                      height: 1,
                                      indent: 20,
                                      endIndent: 20),
                              ],
                            );
                          }),
                          const Divider(
                              color: _C.divider, height: 1),
                          // ── Tambah Debit Instan ──
                          _AddDebitTile(
                            addedBanks: _banks
                                .where((b) => b.isAdded)
                                .toList(),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const AddCardScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Info berapa bank ditambah
                    if (added > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _C.accent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.check_circle_outline_rounded,
                                color: _C.accent,
                                size: 18),
                            const SizedBox(width: 10),
                            Text(
                              '$added bank siap digunakan',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _C.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(bottom: BorderSide(color: _C.divider)),
      ),
      child: Row(
        children: [
          _CircleBtn(
              onTap: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back_ios_new_rounded),
          Expanded(
            child: Text('Metode Pembayaran',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _C.primary)),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: _ScaleButton(
        onTap: _onKonfirmasi,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _C.orange,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text('Konfirmasi',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANK TILE
// ─────────────────────────────────────────────
class _BankTile extends StatelessWidget {
  final _BankOption bank;
  final VoidCallback onTambah;
  const _BankTile({required this.bank, required this.onTambah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 16),
      child: Row(
        children: [
          bank.logo,
          const SizedBox(width: 14),
          Expanded(
            child: Text(bank.name,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A))),
          ),
          _TambahButton(
            isAdded: bank.isAdded,
            onTap: onTambah,
          ),
        ],
      ),
    );
  }
}

class _TambahButton extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onTap;
  const _TambahButton({required this.isAdded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isAdded
              ? const Color(0xFFE8F4ED)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAdded
                ? _C.accent
                : const Color(0xFFE8572A),
            width: 1.5,
          ),
        ),
        child: Text(
          isAdded ? 'Hapus' : 'Tambah',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAdded ? _C.accent : const Color(0xFFE8572A),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TAMBAH DEBIT INSTAN TILE
// ─────────────────────────────────────────────
class _AddDebitTile extends StatelessWidget {
  final List<_BankOption> addedBanks;
  final VoidCallback onTap;
  const _AddDebitTile(
      {required this.addedBanks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Plus icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFCCCCCC),
                    width: 1.5,
                    style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add_rounded,
                  size: 20, color: Color(0xFFAAAAAA)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text('Tambah Debit Instan',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A))),
            ),
            // Mini bank logos + "+1" badge
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MiniBankLogo(child: _BriLogo(small: true)),
                const SizedBox(width: 4),
                _MiniBankLogo(child: _OctoLogo(small: true)),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: const Color(0xFFDDDDDD)),
                  ),
                  child: Text('+1',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF555555))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBankLogo extends StatelessWidget {
  final Widget child;
  const _MiniBankLogo({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFEEECE8)),
        ),
        child: child,
      );
}

// ─────────────────────────────────────────────
// LOGO WIDGETS
// ─────────────────────────────────────────────
class _OctoLogo extends StatelessWidget {
  final bool small;
  const _OctoLogo({this.small = false});
  @override
  Widget build(BuildContext context) {
    final size = small ? 10.0 : 12.0;
    final pad = small
        ? const EdgeInsets.symmetric(horizontal: 3, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
    return Container(
      padding: pad,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'OCTO',
                style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFE8572A))),
            TextSpan(
                text: 'Cash',
                style: TextStyle(
                    fontSize: size - 1,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFAAAAAA))),
          ],
        ),
      ),
    );
  }
}

class _BcaLogo extends StatelessWidget {
  const _BcaLogo();
  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: const Color(0xFF003087), width: 2.5),
        ),
        child: Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF003087),
            ),
          ),
        ),
      );
}

class _BriLogo extends StatelessWidget {
  final bool small;
  const _BriLogo({this.small = false});
  @override
  Widget build(BuildContext context) {
    final s = small ? 28.0 : 40.0;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: const Color(0xFF003087),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('BRI',
            style: TextStyle(
                fontSize: small ? 7 : 10,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _ScaleButton({required this.child, required this.onTap});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.95).animate(_ctrl);

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDE8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 16, color: _C.primary),
        ),
      );
}