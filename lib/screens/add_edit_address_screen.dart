// lib/screens/add_edit_address_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manage_address_screen.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? existing;
  const AddEditAddressScreen({super.key, this.existing});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  static const Color _primary = Color(0xFF2D6A6A);

  final _addressCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  String _selectedLabel = 'Rumah';

  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Rumah', 'icon': Icons.home_outlined},
    {'label': 'Kantor', 'icon': Icons.business_outlined},
    {'label': 'Teman', 'icon': Icons.group_outlined},
    {'label': 'Lainnya', 'icon': Icons.location_on_outlined},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _addressCtrl.text = widget.existing!.address;
      _selectedLabel = widget.existing!.label.contains('Kantor')
          ? 'Kantor'
          : widget.existing!.label.contains('Teman')
              ? 'Teman'
              : widget.existing!.label.contains('Rumah')
                  ? 'Rumah'
                  : 'Lainnya';
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _floorCtrl.dispose();
    _landmarkCtrl.dispose();
    super.dispose();
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case 'Kantor':
        return Icons.business_outlined;
      case 'Teman':
        return Icons.group_outlined;
      case 'Lainnya':
        return Icons.location_on_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  void _simpan() {
    if (_addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Alamat tidak boleh kosong', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (widget.existing != null) {
      // Edit mode
      widget.existing!.label = _selectedLabel;
      widget.existing!.icon = _iconForLabel(_selectedLabel);
      widget.existing!.address = _addressCtrl.text.trim();
      Navigator.pop(context, true);
    } else {
      // Add mode
      final newAddr = AddressModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: _selectedLabel,
        icon: _iconForLabel(_selectedLabel),
        address: _addressCtrl.text.trim(),
      );
      Navigator.pop(context, newAddr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

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
                    child: Text(
                      isEdit ? 'Edit Alamat' : 'Tambah Alamat',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Peta placeholder
            Container(
              height: 160,
              color: const Color(0xFFE8EDF0),
              child: Stack(
                children: [
                  // Map grid lines (simulasi peta)
                  CustomPaint(
                    size: const Size(double.infinity, 160),
                    painter: _MapPainter(),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.location_on,
                              color: Colors.white, size: 22),
                        ),
                        Container(
                          width: 10,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label pilihan
                      RichText(
                        text: TextSpan(
                          text: 'Simpan alamat sebagai ',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF444444),
                            fontWeight: FontWeight.w600,
                          ),
                          children: const [
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        children: _labelOptions.map((opt) {
                          final selected = _selectedLabel == opt['label'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedLabel = opt['label']),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? _primary : Colors.transparent,
                                border: Border.all(
                                  color:
                                      selected ? _primary : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                opt['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: selected ? Colors.white : Colors.grey[700],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Alamat Lengkap
                      Text(
                        'Alamat Lengkap',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressCtrl,
                        maxLines: 3,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Masukkan alamat *',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400], fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _primary, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Lantai
                      Text(
                        'Lantai',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _floorCtrl,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Masukkan lantai (opsional)',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400], fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _primary, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Landmark
                      Text(
                        'Patokan',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _landmarkCtrl,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Masukkan patokan (opsional)',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400], fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _primary, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tombol Simpan
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Simpan Alamat',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
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

// Painter untuk simulasi tampilan peta
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0D8DF)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Diagonal roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;
    canvas.drawLine(
        const Offset(0, 100), Offset(size.width, 60), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.3, 0), Offset(size.width * 0.5, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}