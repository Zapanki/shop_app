import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/cart.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'xxxx xxxx xxxx xxxx',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'xxx',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processPayment(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[800], // Основной серый цвет кнопки
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) async {
  final cart = Provider.of<Cart>(context, listen: false);
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Перемещаем товары из корзины в покупки
    for (var shoe in cart.items) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('purchased')
            .add({
          'name': shoe.name,
          'image': shoe.image,
          'desc': shoe.desc,
          'price': shoe.price,
          'size': shoe.selectedSize,
          'color': shoe.selectedColor,
          'quantity': shoe.quantity,
          'purchaseTime': Timestamp.now(),
        });
        await Future.delayed(Duration(milliseconds: 500));

        // Удаляем товар из корзины после добавления в покупки
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(shoe.id)
            .delete();
      } catch (e) {
        print('Failed to process payment for ${shoe.name}: $e');
      }
    }

    // Очищаем локальную корзину
    cart.clearCart();

    // Показываем сообщение об успешной оплате
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful!'),
      ),
    );

    // Возвращаемся на главную страницу или на экран покупок
    Navigator.of(context).popUntil((route) => route.isFirst);
  } else {
    // Показываем сообщение об ошибке, если пользователь не авторизован
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not logged in!'),
      ),
    );
  }
}
}