class BankStatement{
  String? transaction_date; 
  String? description;
  num? debit;
  num? credit;
  num? amount;

  BankStatement({
  
    this.transaction_date,
    this.description,
    this.debit,
    this.credit,
    this.amount
    
});
 factory BankStatement.fromJson(Map<String, dynamic> json){
        return BankStatement(
          transaction_date: json['transaction_date'],
          description: json['description'],
          debit: json['debit'],
          credit: json['credit'],
          amount: json['amount']
                  );
      }
      
}