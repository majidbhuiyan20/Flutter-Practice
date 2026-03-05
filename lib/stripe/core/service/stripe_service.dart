import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../secret/ow.dart';

final stripePaymentProvider = Provider((ref) => StripePaymentService());

class StripePaymentService {

  final Dio _dio = Dio();

  Future<void> initPaymentSheet({
    required int amount,
    required String currency,
    required String merchantName,
  }) async {

    try {

      final paymentIntent = await _createPaymentIntent(amount, currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: merchantName,
          style: ThemeMode.light,
        ),
      );

    } catch (e) {
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      int amount,
      String currency,
      ) async {

    final body = {
      'amount': (amount * 100).toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    final response = await _dio.post(
      'https://api.stripe.com/v1/payment_intents',
      data: body,
      options: Options(
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
    );

    return response.data;
  }
}