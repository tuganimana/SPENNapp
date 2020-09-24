import 'dart:ffi';

class PaymentZose{

 String receiverphone;
 String fullname;
final double amount;
PaymentZose({this.receiverphone,this.fullname,this.amount});
factory PaymentZose.fromJson(Map<String, dynamic>  json){
  return PaymentZose(
    receiverphone: json['receiverphone'].toString(),
    fullname:  json['fullname'].toString(),
    amount: json['amount'],
  );
}
}