import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/order_api.dart';

class OrderProvider extends ChangeNotifier {
  final OrderApi _api = OrderApi();

  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _loading;

  Future<void> loadMyOrders() async {
    _loading = true;
    notifyListeners();
    try {
      _orders = await _api.fetchMyOrders();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
