import '../models/order.dart';
import 'api_client.dart';

class OrderApi {
  Future<Order> createOrder(Map<String, dynamic> body) async {
    final data = await apiClient.post('/orders', body);
    return Order.fromJson(data);
  }

  Future<List<Order>> fetchMyOrders() async {
    final data = await apiClient.get('/orders/my');
    final list = data as List;
    return list.map((e) => Order.fromJson(e)).toList();
  }
}
