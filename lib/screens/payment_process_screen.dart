// // lib/screens/payment_process_screen.dart
// //
// // Halaman Ringkasan Pesanan / Proses Pembayaran
// // Menggunakan CartProvider dari constants.dart

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import '../utils/constants.dart';
// import 'coupon_screen.dart';
// import 'payment_method_screen.dart';

// class PaymentProcessScreen extends StatefulWidget {
//   const PaymentProcessScreen({super.key});

//   @override
//   State<PaymentProcessScreen> createState() =>
//       _PaymentProcessScreenState();
// }

// class _PaymentProcessScreenState extends State<PaymentProcessScreen> {
//   double  _discountProduct  = 0;
//   double  _discountShipping = 0;
//   String  _appliedCoupon    = '';

//   final double _ongkir       = 15000;
//   final double _biayaLayanan = 2000;

//   // ── Buka CouponScreen sebagai bottom sheet ─────────────────────────────────
//   Future<void> _openCouponSheet(double subTotal) async {
//     final code = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.88,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         expand: false,
//         builder: (_, sc) => ClipRRect(
//           borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(24)),
//           child: CouponScreen(
//             onApply: (c) => Navigator.of(context).pop(c),
//           ),
//         ),
//       ),
//     );

//     if (code != null && mounted) {
//       setState(() {
//         _appliedCoupon = code;
//         switch (code.toUpperCase()) {
//           case 'DISKON10':
//             _discountProduct  = subTotal * 0.10;
//             _discountShipping = 0;
//             break;
//           case 'WELCOME200':
//             _discountProduct  = (subTotal * 0.50).clamp(0, 50000);
//             _discountShipping = 0;
//             break;
//           case 'FREESHIP':
//             _discountProduct  = 0;
//             _discountShipping = _ongkir;
//             break;
//           case 'NEWUSER50':
//             _discountProduct  = (subTotal * 0.50).clamp(0, 50000);
//             _discountShipping = 0;
//             break;
//           case 'LUXURY25':
//             _discountProduct  = subTotal * 0.25;
//             _discountShipping = 0;
//             break;
//           case 'CASHBACK12':
//             _discountProduct  = 12000;
//             _discountShipping = 0;
//             break;
//           default:
//             _discountProduct  = 15000;
//             _discountShipping = 0;
//         }
//       });
//     }
//   }

//   void _removeCoupon() {
//     setState(() {
//       _appliedCoupon    = '';
//       _discountProduct  = 0;
//       _discountShipping = 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cart     = context.watch<CartProvider>();
//     final subTotal = cart.getTotalPrice();
//     final total    = subTotal +
//         _ongkir -
//         _discountShipping +
//         _biayaLayanan -
//         _discountProduct;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: _buildAppBar(context),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         children: [
//           _buildUserInfo(),
//           const SizedBox(height: 12),
//           _buildDivider(),
//           const SizedBox(height: 12),
//           // Produk
//           ...cart.items.map((item) => _buildProductRow(item)),
//           const SizedBox(height: 12),
//           _buildDivider(),
//           const SizedBox(height: 12),
//           // Diskon / kupon
//           _buildCouponField(subTotal),
//           const SizedBox(height: 16),
//           // Ringkasan
//           _buildRingkasan(subTotal, total),
//           const SizedBox(height: 100),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
//           child: SizedBox(
//             height: 54,
//             child: ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => const PaymentMethodScreen()),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2C6E49),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//               ),
//               child: Text(
//                 'Proses Pembayaran · ${formatRupiah(total)}',
//                 style: GoogleFonts.poppins(
//                     fontSize: 15, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── AppBar ──────────────────────────────────────────────────────────────────
//   PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFAFAFA),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFEEECE8)),
//             ),
//             child: const Icon(Icons.arrow_back_ios_new_rounded,
//                 size: 16, color: Color(0xFF1A1A1A)),
//           ),
//         ),
//         title: Text('Proses Pembayaran',
//             style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF1A1A1A))),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(height: 1, color: const Color(0xFFEEECE8)),
//         ),
//       );

//   Widget _buildDivider() =>
//       Container(height: 1, color: const Color(0xFFEEECE8));

//   // ── User info & alamat ──────────────────────────────────────────────────────
//   Widget _buildUserInfo() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFEEECE8)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2C6E49).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.location_on_rounded,
//                   color: Color(0xFF2C6E49), size: 16),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('mamad (08******97)',
//                       style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF1A1A1A))),
//                   Text('Ubah',
//                       style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: const Color(0xFF2C6E49),
//                           fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ]),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.only(left: 38),
//             child: Text(
//               'Jalan Danau Tambingan G6D-19, Kelurahan Sawojajar,\n'
//               'kedungkandang, Kota Malang, Jawa Timur',
//               style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   color: const Color(0xFF8A8A8A),
//                   height: 1.6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Produk row ──────────────────────────────────────────────────────────────
//   Widget _buildProductRow(CartItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFEEECE8)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE8F5E9),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.chair_rounded,
//                 color: Color(0xFF2C6E49), size: 30),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item.name,
//                     style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF1A1A1A))),
//                 Text(item.category.isNotEmpty ? item.category : 'Chair',
//                     style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: const Color(0xFF8A8A8A))),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(formatRupiah(item.pricePerUnit),
//                   style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF1A1A1A))),
//               Text('x${item.jumlah}',
//                   style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: const Color(0xFF8A8A8A))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Coupon field ────────────────────────────────────────────────────────────
//   Widget _buildCouponField(double subTotal) {
//     final has = _appliedCoupon.isNotEmpty;
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => _openCouponSheet(subTotal),
//       child: Container(
//         height: 52,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: has
//                 ? const Color(0xFF2C6E49).withOpacity(0.5)
//                 : const Color(0xFFEEECE8),
//           ),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 14),
//             Icon(Icons.local_offer_outlined,
//                 size: 20,
//                 color:
//                     has ? const Color(0xFF2C6E49) : const Color(0xFF8A8A8A)),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 has
//                     ? 'Kupon "$_appliedCoupon" diterapkan ✓'
//                     : 'Pilih Kupon & Diskon',
//                 style: GoogleFonts.poppins(
//                   fontSize: 13,
//                   color: has
//                       ? const Color(0xFF2C6E49)
//                       : const Color(0xFF8A8A8A),
//                   fontWeight:
//                       has ? FontWeight.w600 : FontWeight.w400,
//                 ),
//               ),
//             ),
//             if (has)
//               GestureDetector(
//                 onTap: _removeCoupon,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   child: const Icon(Icons.close_rounded,
//                       size: 18, color: Color(0xFF8A8A8A)),
//                 ),
//               )
//             else
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 14),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                       left: BorderSide(color: Color(0xFFEEECE8))),
//                 ),
//                 child: const Icon(Icons.chevron_right,
//                     size: 20, color: Color(0xFF8A8A8A)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Ringkasan Pesanan ───────────────────────────────────────────────────────
//   Widget _buildRingkasan(double subTotal, double total) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFEEECE8)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Ringkasan Pesanan',
//               style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF1A1A1A))),
//           const SizedBox(height: 12),
//           _sectionHeader('Subtotal Produk'),
//           _summaryRow('Harga Asli', formatRupiah(subTotal)),
//           _summaryRow(
//             'Diskon Produk',
//             _discountProduct > 0
//                 ? '- ${formatRupiah(_discountProduct)}'
//                 : '-',
//             valueColor: _discountProduct > 0
//                 ? const Color(0xFF2C6E49)
//                 : null,
//           ),
//           const SizedBox(height: 10),
//           _sectionHeader('Subtotal Ongkir'),
//           _summaryRow('Ongkir', formatRupiah(_ongkir)),
//           _summaryRow(
//             'Diskon Ongkir',
//             _discountShipping > 0
//                 ? '- ${formatRupiah(_discountShipping)}'
//                 : '-',
//             valueColor: _discountShipping > 0
//                 ? const Color(0xFF2C6E49)
//                 : null,
//           ),
//           _summaryRow(
//               'Biaya Layanan Pelanggan', formatRupiah(_biayaLayanan)),
//           const SizedBox(height: 12),
//           // Garis dashed
//           LayoutBuilder(builder: (_, c) {
//             const w = 6.0, g = 4.0;
//             final n = (c.maxWidth / (w + g)).floor();
//             return Row(
//               children: List.generate(
//                 n,
//                 (_) => Row(children: [
//                   Container(
//                       width: w,
//                       height: 1,
//                       color: const Color(0xFFEEECE8)),
//                   const SizedBox(width: g),
//                 ]),
//               ),
//             );
//           }),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Total',
//                   style: GoogleFonts.poppins(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF1A1A1A))),
//               Text(formatRupiah(total),
//                   style: GoogleFonts.poppins(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w800,
//                       color: const Color(0xFF2C6E49))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sectionHeader(String label) => Padding(
//         padding: const EdgeInsets.only(bottom: 6),
//         child: Text(label,
//             style: GoogleFonts.poppins(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF1A1A1A))),
//       );

//   Widget _summaryRow(String label, String value,
//       {Color? valueColor}) =>
//       Padding(
//         padding: const EdgeInsets.only(bottom: 6),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label,
//                 style: GoogleFonts.poppins(
//                     fontSize: 12, color: const Color(0xFF8A8A8A))),
//             Text(value,
//                 style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: valueColor ?? const Color(0xFF1A1A1A))),
//           ],
//         ),
//       );
// }