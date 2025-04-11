import 'package:intl/intl.dart';

extension StringCurrency on double {
  String toCurrencyWithSymbol(String symbol) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: symbol,
      decimalDigits: 1,
      customPattern: '#,##0.0 ¤',
    );

    return formatCurrency.format(this);
  }

  String toAbbreviatedCurrency() {
    if (this < 1000) {
      return toStringAsFixed(0); // Sin abreviación
    } else if (this < 1000000) {
      return "${(this / 1000).toStringAsFixed(1)}K"; // Miles
    } else if (this < 1000000000) {
      return "${(this / 1000000).toStringAsFixed(1)}M"; // Millones
    } else {
      return "${(this / 1000000000).toStringAsFixed(1)}B"; // Miles de millones
    }
  }

  String toPercentage() {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: "%",
      decimalDigits: 1,
      customPattern: '#,# ¤',
    );

    return formatCurrency.format(this);
  }
}
