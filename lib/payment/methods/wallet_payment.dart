import 'dart:developer';

import 'package:play_with_payment/payment/methods/payment_method.dart';

class VodafoneWalletPayment implements IPaymentMethod {
  @override
  Future<void> pay({required int amount, required String currency}) async {
    log(
      "Iam going to pay with vodafone wallet with $amount and currency $currency",
    );
  }
}
