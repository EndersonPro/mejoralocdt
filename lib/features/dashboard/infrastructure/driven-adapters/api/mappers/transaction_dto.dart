class TransactionDTO {
  int userId;
  String bankName;
  double amount;
  double rate;
  String startDate;
  String endDate;
  double roi;

  TransactionDTO({
    required this.userId,
    required this.bankName,
    required this.amount,
    required this.rate,
    required this.startDate,
    required this.endDate,
    required this.roi,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) {
    return TransactionDTO(
      userId: json['user_id'],
      bankName: json['bank_name'],
      amount: json['amount'].toDouble(),
      rate: json['rate'].toDouble(),
      startDate: json['start_date'],
      endDate: json['end_date'],
      roi: json['roi'].toDouble(),
    );
  }
}
