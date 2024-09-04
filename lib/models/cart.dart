import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shoe.dart';

class Cart with ChangeNotifier {
  List<Shoe> _items = [];

  List<Shoe> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  int get itemCount {
    return _items.length;
  }

  // Метод для получения списка товаров из корзины пользователя
  Future<void> getUserCart() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      List<Shoe> loadedItems = querySnapshot.docs.map((doc) {
        return Shoe(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          desc: doc['desc'],
          price: (doc['price'] as num).toDouble(),
          selectedSize: doc['size'] ?? 'M',
          selectedColor: doc['color'] ?? 'Red',
          quantity: doc['quantity'] ?? 1,
        );
      }).toList();

      _items = loadedItems;  // Ваша переменная, которая хранит список товаров в корзине
      notifyListeners();  // Обновление UI после загрузки данных
    } catch (e) {
      print('Failed to load cart items: $e');
    }
  }
}


  void addItemToCart(Shoe shoe) {
    _items.add(shoe);
    notifyListeners();
  }

  void removeItemFromCart(Shoe shoe) {
    _items.removeWhere((item) => item.id == shoe.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
