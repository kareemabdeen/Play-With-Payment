import 'package:play_with_payment/payment/emun/payment_type_enum.dart';
import 'package:play_with_payment/payment/methods/credit_card_payment.dart';
import 'package:play_with_payment/payment/methods/payment_method.dart';
import 'package:play_with_payment/payment/methods/stripe_payment.dart';
import 'package:play_with_payment/payment/methods/wallet_payment.dart';

//* factory class named by this way => Parent class (IPaymentMethod) + Factory => (PaymentMethodFactory)
class PaymentMethodFactory {
  IPaymentMethod createPaymentMethod(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return CreditCardPayment();
      case PaymentType.vodafoneWallet:
        return VodafoneWalletPayment();
      case PaymentType.stripe:
        return StripePayment();
    }
  }
}
