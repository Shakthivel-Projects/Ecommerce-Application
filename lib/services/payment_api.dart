import 'api_client.dart';

class PaymentApi {
  Future<String> createPaymentIntent({
    required int amountInPaise,
    required List<Map<String, dynamic>> items,
  }) async {
    final data = await apiClient.post('/payments/create-payment-intent', {
      'amountClient': amountInPaise,
      'items': items,
      'currency': 'inr',
    });

    return data['clientSecret'];
  }
}
