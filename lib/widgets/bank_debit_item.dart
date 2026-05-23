import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DebitMethod {
  final String name;
  final String logoPath;
  final Color logoColor;
  final String? badgeCount;
  final bool isAvailable;

  const DebitMethod({
    required this.name,
    required this.logoPath,
    required this.logoColor,
    this.badgeCount,
    this.isAvailable = true,
  });
}

final List<DebitMethod> debitMethods = [
  DebitMethod(
    name: 'CIMB Direct Debit',
    logoPath: 'CIMB',
    logoColor: const Color(0xFFFF0000),
  ),
  DebitMethod(
    name: 'BCA OneKlik',
    logoPath: 'BCA',
    logoColor: const Color(0xFF005BAA),
  ),
  DebitMethod(
    name: 'BRI Direct Debit',
    logoPath: 'BRI',
    logoColor: const Color(0xFF003580),
  ),
  DebitMethod(
    name: 'Tambah Debit Instan',
    logoPath: '+',
    logoColor: AppColors.primary,
    badgeCount: '+1',
  ),
];

class BankDebitItem extends StatelessWidget {
  final DebitMethod method;
  final VoidCallback onTap;

  const BankDebitItem({
    super.key,
    required this.method,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
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
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: method.logoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: method.logoColor.withOpacity(0.3), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              method.logoPath,
              style: TextStyle(
                color: method.logoColor,
                fontSize: method.logoPath == '+' ? 20 : 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Text(
                  method.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (method.badgeCount != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      method.badgeCount!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.4)),
              ),
              child: const Text(
                'Tambah',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}