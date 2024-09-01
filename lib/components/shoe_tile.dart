import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/shoe.dart';

class ShoeTile extends StatefulWidget {
  final Shoe shoe;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final ValueChanged<int?> onQuantityChanged;
  final int selectedQuantity; // Количество товаров

  const ShoeTile({
    Key? key,
    required this.shoe,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onQuantityChanged,
    required this.selectedQuantity, // Привязка количества к товару
  }) : super(key: key);

  @override
  _ShoeTileState createState() => _ShoeTileState();
}

class _ShoeTileState extends State<ShoeTile> {
  String selectedSize = 'M';
  String selectedColor = 'Red';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.all(8),
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  widget.shoe.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(widget.shoe.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Text('\$${widget.shoe.price}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedSize,
                    items: <String>['S', 'M', 'L', 'XL'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedColor,
                    items: [
                      {'Red': Colors.red},
                      {'Blue': Colors.blue},
                      {'Green': Colors.green}
                    ].map((color) {
                      return DropdownMenuItem<String>(
                        value: color.keys.first,
                        child: Row(
                          children: [
                            Text(color.keys.first),
                            SizedBox(width: 10),
                            Container(
                              width: 20,
                              height: 20,
                              color: color.values.first,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedColor = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    value: widget.selectedQuantity,
                    items:
                        List.generate(5, (index) => index + 1).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: widget.onQuantityChanged,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  widget.shoe.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                onPressed: widget.onFavoriteTap,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final updatedShoe = widget.shoe.copyWith(
                      selectedSize: selectedSize,
                      selectedColor: selectedColor,
                      quantity: widget.selectedQuantity,
                    );

                    // Добавить товар в локальную корзину
                    Provider.of<Cart>(context, listen: false)
                        .addItemToCart(updatedShoe);

                    // Сохранить товар в корзине пользователя в Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('cart')
                        .add({
                      'name': updatedShoe.name,
                      'image': updatedShoe.image,
                      'desc': updatedShoe.desc,
                      'price': updatedShoe.price,
                      'size': selectedSize,
                      'color': selectedColor,
                      'quantity': widget.selectedQuantity,
                    });

                    // Показываем сообщение о том, что товар добавлен в корзину
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${updatedShoe.name} added to cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    // Показываем сообщение об ошибке, если что-то пошло не так
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to add ${widget.shoe.name} to cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Цвет текста
                  backgroundColor:
                      Colors.grey[500], // Основной серый цвет кнопки
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Закругленные углы кнопки
                  ),
                  elevation: 3, // Легкая тень кнопки
                ),
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 18, // Размер текста
                    fontWeight: FontWeight.bold, // Жирность текста
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
