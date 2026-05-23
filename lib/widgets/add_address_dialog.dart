// checkout/add_address_dialog.dart
// Dialog untuk menambah alamat baru dengan validasi form

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/checkout_models.dart';
import '../providers/checkout_provider.dart';
import '../utils/checkout_theme.dart';

class AddAddressDialog extends StatefulWidget {
  const AddAddressDialog({super.key});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl    = TextEditingController();
  final _streetCtrl   = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _stateCtrl    = TextEditingController();
  final _zipCtrl      = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = ShippingAddress(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: _labelCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      zipCode: _zipCtrl.text.trim(),
    );

    context.read<CheckoutProvider>().addAddress(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CC.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Add New Address',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: CC.textPri,
                  ),
                ),
                const SizedBox(height: 20),

                _Field(
                  controller: _labelCtrl,
                  label: 'Label (e.g. Home, Gym)',
                  hint: 'Home',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Label wajib diisi' : null,
                ),
                _Field(
                  controller: _streetCtrl,
                  label: 'Street Address',
                  hint: '1901 Thornridge Cir.',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Alamat wajib diisi' : null,
                ),
                _Field(
                  controller: _cityCtrl,
                  label: 'City',
                  hint: 'Hawaii',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Kota wajib diisi' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        controller: _stateCtrl,
                        label: 'State',
                        hint: 'HI',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Wajib diisi'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Field(
                        controller: _zipCtrl,
                        label: 'Zip Code',
                        hint: '81063',
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Wajib diisi'
                            : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: CC.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Batal',
                            style: TextStyle(
                                color: CC.textSec, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CC.teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Simpan',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable form field ───────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CC.textSec)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontSize: 14, color: CC.textPri),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: CC.radioOff, fontSize: 13),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: CC.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CC.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CC.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CC.teal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              
              ),
            ),
          ),
        ],
      ),
    );
  }
}