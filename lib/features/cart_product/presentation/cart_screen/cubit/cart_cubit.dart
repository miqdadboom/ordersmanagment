import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<double> {
  CartCubit() : super(0);

  double totalPrice = 0;
  List<Map<String, dynamic>> products = [];

  void initializeProducts() {
    products = List.generate(13, (index) => {
      "imageUrl": "https://images.unsplash.com/photo-1541643600914-78b084683601?fm=jpg&q=60&w=3000",
      "title": "Product ${index + 1}",
      "subtitle": "Brand A",
      "price": 100.0,
      "quantity": 1,
    });
    calculateTotal();
  }

  void calculateTotal() {
    totalPrice = products.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
    emit(totalPrice);
  }

  void updateTotal(double change) {
    totalPrice += change;
    emit(totalPrice);
  }

  void removeProduct(int index) {
    totalPrice -= products[index]['price'] * products[index]['quantity'];
    products.removeAt(index);
    emit(totalPrice);
  }

  void updateQuantity(int index, int oldQty, int newQty) {
    totalPrice += (newQty - oldQty) * products[index]['price'];
    products[index]['quantity'] = newQty;
    emit(totalPrice);
  }
}
