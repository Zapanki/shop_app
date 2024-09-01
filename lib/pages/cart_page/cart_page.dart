import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
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
                          cart.removeItemFromCart(shoe);
                        },
                      ),
                    );
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
        },
      ),
    );
  }
}
