import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import "package:flutter_stripe/flutter_stripe.dart";
import 'package:play_with_payment/payment/emun/payment_type_enum.dart';
import 'package:play_with_payment/payment/payment_method_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          background: const Color(0xFFF8F9FD),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const PaymentTypesView(),
    );
  }
}

class PaymentTypesView extends StatelessWidget {
  const PaymentTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Text(
              'Select your preferred\npayment method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: PaymentType.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final type = PaymentType.values[index];
                return _PaymentMethodCard(type: type);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentType type;

  const _PaymentMethodCard({required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = _getThemeColors(type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final PaymentMethodFactory paymentFactory = PaymentMethodFactory();
            final paymentMethod = paymentFactory.createPaymentMethod(type);
            // In a real app, you might want to show loading or navigate
            await paymentMethod.pay(amount: 1000, currency: 'EGP');

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Processing ${formattedName(type)}...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconForType(type),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedName(type),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDescriptionForType(type),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formattedName(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.vodafoneWallet:
        return 'Vodafone Cash';
      case PaymentType.stripe:
        return 'Stripe';
    }
  }

  String _getDescriptionForType(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'Pay securely with Visa or Mastercard';
      case PaymentType.vodafoneWallet:
        return 'Fast payment via mobile wallet';
      case PaymentType.stripe:
        return 'International payments supported';
    }
  }

  IconData _getIconForType(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return Icons.credit_card_rounded;
      case PaymentType.vodafoneWallet:
        return Icons.account_balance_wallet_rounded;
      case PaymentType.stripe:
        return Icons.webhook_rounded;
    }
  }

  ({List<Color> gradient, Color shadow}) _getThemeColors(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return (
          gradient: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
          shadow: const Color(0xFF4FACFE),
        );
      case PaymentType.vodafoneWallet:
        return (
          gradient: [const Color(0xFFE94057), const Color(0xFFF27121)],
          shadow: const Color(0xFFE94057),
        );
      case PaymentType.stripe:
        return (
          gradient: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
          shadow: const Color(0xFF43E97B),
        );
    }
  }
}
