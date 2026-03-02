import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/stripe/core/service/stripe_service.dart';

class StripePaymentScreen extends ConsumerStatefulWidget {
  const StripePaymentScreen({super.key});

  @override
  ConsumerState<StripePaymentScreen> createState() =>
      _StripePaymentScreenState();
}

class _StripePaymentScreenState extends ConsumerState<StripePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final stripeService = ref.read(stripePaymentProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Stripe Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await stripeService.initPaymentSheet(
                amount: '10',
                currency: 'usd',
                merchantName: 'Majid',
              );
              await stripeService.presentPaymentSheet();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Payment Successful")));
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Payment Failed")));
            }
          },
          child: Text("Pay \$10"),
        ),
      ),
    );
  }
}//
////