import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:play_with_payment/payment/methods/payment_method.dart';

class StripePayment implements IPaymentMethod {
  @override
  Future<void> pay({required int amount, required String currency}) async {
    try {
      // 1. create payment intent (backend)
      String clientSecret = await _getClientSecret(
        (amount * 100).toString(),
        currency,
      );
      // 2. init payment sheet
      await _initializePaymentSheet(clientSecret);

      // 3. present payment sheet
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      log('error with stripe ${e.toString()}');
    }
  }

  Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "kareem abdeen",
      ),
    );
  }

  Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {'amount': amount, 'currency': currency},
    );
    return response.data["client_secret"];
  }
}
