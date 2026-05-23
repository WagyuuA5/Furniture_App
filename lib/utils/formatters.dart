import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static String currency(double amount) {
    return _currencyFormatter.format(amount);
  }

  static String cardNumber(String raw) {
    final digits = raw.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String maskedCard(String number) {
    final digits = number.replaceAll(' ', '');
    if (digits.length < 4) return number;
    return '**** **** **** ${digits.substring(digits.length - 4)}';
  }
}