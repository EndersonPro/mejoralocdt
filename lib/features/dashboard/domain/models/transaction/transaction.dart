class Transaction {
  final String userId;
  final String bankName;
  final double amount;
  final double rate;
  final String startDate;
  final String endDate;
  final double roi;

  Transaction({
    required this.userId,
    required this.bankName,
    required this.amount,
    required this.rate,
    required this.startDate,
    required this.endDate,
    required this.roi,
  });
}
