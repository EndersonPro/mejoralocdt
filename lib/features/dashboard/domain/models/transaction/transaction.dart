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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json['userId'],
      bankName: json['bankName'],
      amount: json['amount'],
      rate: json['rate'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      roi: json['roi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bankName': bankName,
      'amount': amount,
      'rate': rate,
      'startDate': startDate,
      'endDate': endDate,
      'roi': roi,
    };
  }
}
