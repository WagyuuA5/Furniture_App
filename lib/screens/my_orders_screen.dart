// lib/screens/my_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF2D6A6A);

  late TabController _tabCtrl;

  final List<String> _tabs = [
    'Semua',
    'Dalam Proses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  // UPDATE AREA: Ganti dengan data dari API/backend
  final List<_OrderItem> _orders = [
    _OrderItem(
      id: '#ORD-001',
      productName: 'Sofa Minimalis Modern 3 Seater',
      qty: 1,
      price: 'Rp 4.250.000',
      status: 'Dalam Proses',
      statusColor: Color(0xFFF59E0B),
      imagePlaceholder: Icons.chair_outlined,
    ),
    _OrderItem(
      id: '#ORD-002',
      productName: 'Meja Makan Kayu Jati Set',
      qty: 1,
      price: 'Rp 3.180.000',
      status: 'Dikirim',
      statusColor: Color(0xFF3B82F6),
      imagePlaceholder: Icons.table_bar_outlined,
    ),
    _OrderItem(
      id: '#ORD-003',
      productName: 'Lampu Gantung Estetik',
      qty: 2,
      price: 'Rp 450.000',
      status: 'Selesai',
      statusColor: Color(0xFF10B981),
      imagePlaceholder: Icons.light_outlined,
    ),
    _OrderItem(
      id: '#ORD-004',
      productName: 'Rak Buku Dinding Minimalis',
      qty: 1,
      price: 'Rp 320.000',
      status: 'Dibatalkan',
      statusColor: Color(0xFFEF4444),
      imagePlaceholder: Icons.shelves,
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
    super.dispose();
  }

  List<_OrderItem> _filteredOrders(String tab) {
    if (tab == 'Semua') return _orders;
    return _orders.where((o) => o.status == tab).toList();
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
                    child: Text('Pesanan Saya',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabCtrl,
                isScrollable: true,
                indicatorColor: _primary,
                labelColor: _primary,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: _tabs.map((tab) {
                  final orders = _filteredOrders(tab);
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text('Tidak ada pesanan',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _OrderCard(order: orders[i]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _OrderItem order;
  static const Color _primary = Color(0xFF2D6A6A);

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(order.imagePlaceholder,
                    color: Colors.grey[400], size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.productName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.qty}x  •  ${order.price}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  order.status,
                  style: GoogleFonts.poppins(
                    color: order.statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  // UPDATE AREA: Navigasi ke halaman detail pesanan
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                ),
                child: Text('Lihat Detail',
                    style: GoogleFonts.poppins(
                        color: _primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItem {
  final String id;
  final String productName;
  final int qty;
  final String price;
  final String status;
  final Color statusColor;
  final IconData imagePlaceholder;

  const _OrderItem({
    required this.id,
    required this.productName,
    required this.qty,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.imagePlaceholder,
  });
}