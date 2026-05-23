import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SavedCard {
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String type; // 'visa', 'mastercard', 'mandiri', 'bca'

  const SavedCard({
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.type,
  });

  String get maskedNumber =>
      '**** **** **** ${cardNumber.replaceAll(' ', '').substring(cardNumber.replaceAll(' ', '').length - 4)}';
}

class PaymentMethodCard extends StatelessWidget {
  final SavedCard card;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  Color get _cardColor {
    switch (card.type) {
      case 'mandiri':
        return const Color(0xFF003D82);
      case 'bca':
        return const Color(0xFF005BAA);
      default:
        return const Color(0xFF1A237E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_cardColor, _cardColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _cardColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Card logo area
            Container(
              width: 50,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: _buildLogo(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.maskedNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.holderName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  card.expiryDate,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.7), width: 2),
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check,
                          size: 12, color: Color(0xFF1A237E))
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    switch (card.type) {
      case 'visa':
        return const Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
        );
      case 'mandiri':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'mandiri',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w700),
            ),
          ],
        );
      case 'bca':
        return const Text(
          'BCA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        );
      default:
        return const Icon(Icons.credit_card, color: Colors.white, size: 20);
    }
  }
}