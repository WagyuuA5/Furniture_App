enum CouponType { product, shipping, cashback }
enum CouponBadge { none, popular, limited, hot }

class CouponModel {
  final String code;
  final String description;
  final String benefitLabel;
  final String emoji;
  final CouponType type;
  final CouponBadge badge;
  final bool isLocked;
  final String? lockMessage;
  final double? minPurchase;
  final double? discountAmount;
  final double? discountPercent;
  final double? maxDiscount;

  const CouponModel({
    required this.code,
    required this.description,
    required this.benefitLabel,
    required this.emoji,
    required this.type,
    this.badge = CouponBadge.none,
    this.isLocked = false,
    this.lockMessage,
    this.minPurchase,
    this.discountAmount,
    this.discountPercent,
    this.maxDiscount,
  });
}

final List<CouponModel> allCoupons = [
  CouponModel(
    code: 'WELCOME200',
    description: 'Add items worth Rp2.000 more to unlock',
    benefitLabel: 'Get 50% OFF',
    emoji: '🔥',
    type: CouponType.product,
    badge: CouponBadge.popular,
    isLocked: true,
    lockMessage: 'Tambah Rp2.000 lagi',
    discountPercent: 50,
    maxDiscount: 50000,
  ),
  CouponModel(
    code: 'CASHBACK12',
    description: 'Add items worth Rp2.000 more to unlock',
    benefitLabel: 'Up to Rp12.000 cashback',
    emoji: '💸',
    type: CouponType.cashback,
    badge: CouponBadge.popular,
    isLocked: true,
    lockMessage: 'Tambah Rp2.000 lagi',
    maxDiscount: 12000,
  ),
  CouponModel(
    code: 'NEWUSER50',
    description: 'Khusus pembelian pertama',
    benefitLabel: '50% OFF maks Rp50.000',
    emoji: '🎁',
    type: CouponType.product,
    badge: CouponBadge.limited,
    discountPercent: 50,
    maxDiscount: 50000,
  ),
  CouponModel(
    code: 'FREESHIP',
    description: 'Min belanja Rp150.000',
    benefitLabel: 'Gratis Ongkir',
    emoji: '🚚',
    type: CouponType.shipping,
    badge: CouponBadge.popular,
    minPurchase: 150000,
  ),
  CouponModel(
    code: 'PAYDAY25',
    description: 'Min belanja Rp200.000',
    benefitLabel: '25% OFF',
    emoji: '🔥',
    type: CouponType.product,
    minPurchase: 200000,
    discountPercent: 25,
    maxDiscount: 75000,
  ),
  CouponModel(
    code: 'RAMADHAN20',
    description: 'Berlaku untuk semua produk',
    benefitLabel: '20% OFF',
    emoji: '🌙',
    type: CouponType.product,
    badge: CouponBadge.limited,
    discountPercent: 20,
    maxDiscount: 40000,
  ),
  CouponModel(
    code: 'VOUCHER10K',
    description: 'Min belanja Rp100.000',
    benefitLabel: 'Diskon Rp10.000',
    emoji: '💰',
    type: CouponType.product,
    minPurchase: 100000,
    discountAmount: 10000,
  ),
  CouponModel(
    code: 'BIGSALE40',
    description: 'Min belanja Rp500.000',
    benefitLabel: '40% OFF',
    emoji: '🔥',
    type: CouponType.product,
    badge: CouponBadge.hot,
    minPurchase: 500000,
    discountPercent: 40,
    maxDiscount: 200000,
  ),
  CouponModel(
    code: 'FLASHSALE',
    description: 'Limited time offer',
    benefitLabel: '60% OFF maks Rp100.000',
    emoji: '⚡',
    type: CouponType.product,
    badge: CouponBadge.limited,
    discountPercent: 60,
    maxDiscount: 100000,
  ),
  CouponModel(
    code: 'REFERAL15',
    description: 'Ajak teman berbelanja',
    benefitLabel: '15% OFF + bonus poin',
    emoji: '👥',
    type: CouponType.product,
    discountPercent: 15,
  ),
  CouponModel(
    code: 'BIRTHDAY30',
    description: 'Hadiah spesial ulang tahun kamu',
    benefitLabel: '30% OFF',
    emoji: '🎂',
    type: CouponType.product,
    badge: CouponBadge.limited,
    discountPercent: 30,
    maxDiscount: 80000,
  ),
  CouponModel(
    code: 'FEST2COST',
    description: 'Min beli 2 produk combo',
    benefitLabel: '50% OFF untuk Combo',
    emoji: '🛍️',
    type: CouponType.product,
    discountPercent: 50,
    maxDiscount: 150000,
  ),
];