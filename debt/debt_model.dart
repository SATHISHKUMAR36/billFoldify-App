class Debt {
   String? Debtor_nmae;
   String? note;
   num? amount_of_debt;
   String? debt_repaid_date;
   String? debt_date;


  Debt(
      { this.Debtor_nmae,
       this.note,
       this.amount_of_debt,
      this.debt_date,
       this.debt_repaid_date});

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
        Debtor_nmae: json['Debtor_nmae'],
        note: json['note'],
        amount_of_debt: json['amount_of_debt'],
        debt_date:json['debt_date'],
        debt_repaid_date:json['debt_repaid_date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Debtor_nmae': Debtor_nmae,
      'note': note,
      'amount_of_debt': amount_of_debt,
      'debt_date':debt_date,
      'debt_repaid_date':debt_repaid_date
    };
  }
}
