import 'dart:developer';

import 'package:play_with_payment/payment/methods/payment_method.dart';

class CreditCardPayment implements IPaymentMethod {
  @override
  Future<void> pay({required int amount, required String currency}) async {
    log(
      "Iam going to pay with credit card with $amount and currency $currency",
    );
  }
}
