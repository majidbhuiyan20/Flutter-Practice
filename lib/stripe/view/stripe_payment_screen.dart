import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../core/service/stripe_service.dart';

class StripePaymentScreen extends ConsumerWidget {
  const StripePaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final stripeService = ref.read(stripePaymentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payment")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {

                try {

                  await stripeService.initPaymentSheet(
                    amount: 10,
                    currency: 'usd',
                    merchantName: 'Majid Store',
                  );

                  await stripeService.presentPaymentSheet();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful")),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Payment Failed: $e")),
                  );

                }

              },
              child: const Text("Pay \$10"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {

                try {

                  await stripeService.initPaymentSheet(
                    amount: 99,
                    currency: 'usd',
                    merchantName: 'Majid Store',
                  );

                  await stripeService.presentPaymentSheet();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful")),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Payment Failed: $e")),
                  );

                }

              },
              child: const Text("Pay \$99"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {

                try {

                  await stripeService.initPaymentSheet(
                    amount: 990,
                    currency: 'usd',
                    merchantName: 'Majid Store',
                  );

                  await stripeService.presentPaymentSheet();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful")),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Payment Failed: $e")),
                  );

                }

              },
              child: const Text("Pay \$990"),
            ),
          ],
        ),
      ),
    );
  }
}
