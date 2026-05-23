// lib/screens/add_card_screen.dart
//
// Halaman tambah kartu kredit/debit
// Desain 1:1 sesuai gambar:
//  - Preview kartu animasi flip saat focus CVV
//  - Form: Card Holder Name, Card Number, Expiry Date, CVV
//  - Checkbox "Save Card"
//  - Tombol "Add Card" dengan scale animation

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// THEME LOKAL
// ─────────────────────────────────────────────
class _C {
  static const bg      = Color(0xFFF7F6F3);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1A1A1A);
  static const accent  = Color(0xFF2C5F52);
  static const inputBg = Color(0xFFF5F4F2);
  static const textSec = Color(0xFF8A8A8A);
  static const divider = Color(0xFFEEECE8);
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen>
    with SingleTickerProviderStateMixin {
  // ── Form controllers ──────────────────────────
  final _nameCtrl   = TextEditingController(text: 'Esther Howard');
  final _numberCtrl = TextEditingController(text: '4716 9627 1635 8047');
  final _expiryCtrl = TextEditingController(text: '02/30');
  final _cvvCtrl    = TextEditingController();

  bool _saveCard   = true;
  bool _showBack   = false;
  bool _obscureCvv = true;

  // ── Flip animation ────────────────────────────
  late final AnimationController _flipCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _flipAnim =
      Tween(begin: 0.0, end: math.pi).animate(
          CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));

  final FocusNode _cvvFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _cvvFocus.addListener(() {
      if (_cvvFocus.hasFocus && !_showBack) {
        setState(() => _showBack = true);
        _flipCtrl.forward();
      } else if (!_cvvFocus.hasFocus && _showBack) {
        setState(() => _showBack = false);
        _flipCtrl.reverse();
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _cvvFocus.dispose();
    _flipCtrl.dispose();
    super.dispose();
  }

  // Format nomor kartu preview (19 char: "4716 9627 1635 8047")
  String get _formattedNumber {
    final raw = _numberCtrl.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(raw[i]);
    }
    return buf.toString().padRight(19, '·').substring(0, 19);
  }

  void _onAddCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text('Kartu berhasil ditambahkan!',
              style: GoogleFonts.poppins(fontSize: 13)),
        ]),
        backgroundColor: _C.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600),
        () { if (mounted) Navigator.of(context).pop(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    _buildCardPreview(),
                    const SizedBox(height: 28),
                    _buildForm(),
                    const SizedBox(height: 16),
                    _buildSaveCard(),
                    const SizedBox(height: 100),
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

  // ── Header ────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
            child: Text('Add Card',
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

  // ── Card Preview (flip animation) ─────────────
  Widget _buildCardPreview() {
    return AnimatedBuilder(
      animation: _flipAnim,
      builder: (_, __) {
        final angle  = _flipAnim.value;
        final isFront = angle < math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isFront
              ? _CardFront(
                  name: _nameCtrl.text.isEmpty
                      ? 'Card Holder Name'
                      : _nameCtrl.text,
                  number: _formattedNumber,
                  expiry: _expiryCtrl.text.isEmpty
                      ? 'MM/YY'
                      : _expiryCtrl.text,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _CardBack(
                    cvv: _cvvCtrl.text.isEmpty
                        ? '•••'
                        : _cvvCtrl.text,
                  ),
                ),
        );
      },
    );
  }

  // ── Form ──────────────────────────────────────
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Card Holder Name'),
        _InputField(
          controller: _nameCtrl,
          hint: 'Nama lengkap',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        _FieldLabel('Card Number'),
        _InputField(
          controller: _numberCtrl,
          hint: '0000 0000 0000 0000',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Expiry Date'),
                  _InputField(
                    controller: _expiryCtrl,
                    hint: 'MM/YY',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryFormatter(),
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('CVV'),
                  _InputField(
                    controller: _cvvCtrl,
                    hint: '000',
                    focusNode: _cvvFocus,
                    keyboardType: TextInputType.number,
                    obscureText: _obscureCvv,
                    maxLength: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (_) => setState(() {}),
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureCvv = !_obscureCvv),
                      child: Icon(
                        _obscureCvv
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 16,
                        color: _C.textSec,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Save card toggle ──────────────────────────
  Widget _buildSaveCard() {
    return GestureDetector(
      onTap: () => setState(() => _saveCard = !_saveCard),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _saveCard ? _C.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _saveCard ? _C.accent : _C.divider,
                width: 2,
              ),
            ),
            child: _saveCard
                ? const Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text('Save Card',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _C.primary)),
        ],
      ),
    );
  }

  // ── Bottom bar ────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: _C.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: _ScaleButton(
        onTap: _onAddCard,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _C.accent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text('Add Card',
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
// CARD FRONT
// ─────────────────────────────────────────────
class _CardFront extends StatelessWidget {
  final String name;
  final String number;
  final String expiry;

  const _CardFront({
    required this.name,
    required this.number,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C5F52), Color(0xFF1A3D33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C5F52).withOpacity(0.40),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Konten
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('VISA',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2)),
                  ],
                ),
                const Spacer(),
                Text(
                  number,
                  style: GoogleFonts.robotoMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card holder name',
                            style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.white.withOpacity(0.6))),
                        Text(name,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiry date',
                            style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.white.withOpacity(0.6))),
                        Text(expiry,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.credit_card_rounded,
                        color: Colors.white.withOpacity(0.7), size: 32),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARD BACK
// ─────────────────────────────────────────────
class _CardBack extends StatelessWidget {
  final String cvv;

  const _CardBack({required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3D33), Color(0xFF0F2820)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C5F52).withOpacity(0.40),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Strip magnetic
          Container(
            height: 44,
            color: Colors.black.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          // CVV strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(cvv,
                      style: GoogleFonts.robotoMono(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('CVV',
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.5))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INPUT FORMATTERS
// ─────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue nv) {
    final digits = nv.text.replaceAll(' ', '');
    if (digits.length > 16) return old;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final str = buf.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue nv) {
    final digits = nv.text.replaceAll('/', '');
    if (digits.length > 4) return old;
    String str = digits;
    if (digits.length >= 3) {
      str = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _C.primary)),
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool obscureText;
  final int? maxLength;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.obscureText = false,
    this.maxLength,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLength: maxLength,
        style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _C.primary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: _C.textSec),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          counterText: '',
          suffixIcon: suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffix)
              : null,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}

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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 16, color: _C.primary),
      ),
    );
  }
}