import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/shoe.dart';
import 'package:shop_app/pages/cart_page/payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            // Если товаров в корзине нет, показываем сообщение и анимацию
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: Lottie.asset('assets/Animation - 1725208078442.json'), // Убедитесь, что путь к анимации правильный
                  ),
                ],
              ),
            );
          }else{
            return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final shoe = cart.items[index];
                    return ListTile(
                      leading: Image.network(shoe.image),
                      title: Text(shoe.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${shoe.selectedSize} - ${shoe.selectedColor}'),
                          Text(
                              'Quantity: ${shoe.quantity}'), // Отображение количества
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeletion(context, shoe, cart);
                        },
                      ),);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (cart.itemCount > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your cart is empty!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Цвет текста
                  backgroundColor: Colors.purple[700], // Основной цвет кнопки
                  padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18), // Увеличенный размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Более округленные углы
                  ),
                  elevation: 5, // Более выраженная тень
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18, // Увеличенный размер текста
                    fontWeight: FontWeight.bold, // Жирный текст
                  ),
                ),
              ),
            ],
          );
          }
          
        },
      ),
    );
  }
  void _confirmDeletion(BuildContext context, Shoe shoe, Cart cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove this item from the cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Удаляем товар из корзины в базе данных Firebase
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('cart')
                    .doc(shoe.id)
                    .delete();

                // Удаляем товар из локальной корзины
                cart.removeItemFromCart(shoe);

                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
