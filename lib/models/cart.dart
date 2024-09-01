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
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      _items = cartSnapshot.docs.map((doc) {
        return Shoe(
          name: doc['name'],
          image: doc['image'],
          desc: doc['desc'],
          price: doc['price'],
          id: doc.id,
          selectedSize: doc['size'],
          selectedColor: doc['color'],
          isFavorite: doc['isFavorite'] ?? false,
        );
      }).toList();
      notifyListeners();
    }
  }

  void addItemToCart(Shoe shoe) {
    _items.add(shoe);
    notifyListeners();
  }

  void removeItemFromCart(Shoe shoe) {
    _items.remove(shoe);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
