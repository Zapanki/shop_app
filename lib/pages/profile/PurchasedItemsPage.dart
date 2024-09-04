import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/models/shoe.dart';
import 'package:shop_app/pages/home_page/shop_page.dart'; // Ensure this import is correct

class PurchasedItemsPage extends StatelessWidget {
  const PurchasedItemsPage({super.key});

  Future<List<Shoe>> _loadPurchasedItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('purchased')
            .orderBy('purchaseTime', descending: true)
            .get();

        Map<String, Shoe> combinedShoes = {};

        for (var doc in querySnapshot.docs) {
          final shoeId = doc.id;
          final quantity = (doc['quantity'] as num?)?.toInt() ?? 1;
          final purchaseTime = (doc['purchaseTime'] as Timestamp?)?.toDate();

          if (combinedShoes.containsKey(shoeId)) {
            combinedShoes[shoeId]!.quantity += quantity;
          } else {
            combinedShoes[shoeId] = Shoe(
              id: shoeId,
              name: doc['name'] ?? 'Unknown Name',
              image: doc['image'] ?? '',
              desc: doc['desc'] ?? '',
              price: (doc['price'] as num?)?.toDouble() ?? 0.0,
              selectedSize: doc['size'] ?? '',
              selectedColor: doc['color'] ?? '',
              quantity: quantity,
              purchaseTime: purchaseTime,
            );
          }
        }

        return combinedShoes.values.toList();
      } catch (e) {
        print('Error loading purchased items: $e');
        return [];
      }
    }
    return [];
  }

  double _calculateTotalPrice(List<Shoe> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchased Items"),
      ),
      body: FutureBuilder<List<Shoe>>(
        future: _loadPurchasedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load purchased items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Purchased Items',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  Container(
                    height: 150,
                    child:
                        Lottie.asset('assets/Animation - 1725208078442.json'),
                  ),
                ],
              ),
            );
          } else {
            List<Shoe> purchasedItems = snapshot.data!;
            double totalPrice = _calculateTotalPrice(purchasedItems);

            return Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Shoe>>(
                    future: _loadPurchasedItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to load purchased items'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Purchased Items'));
                      } else {
                        List<Shoe> purchasedItems = snapshot.data!;
                        Map<String, Shoe> combinedShoes = {};

                        for (var shoe in purchasedItems) {
                          if (combinedShoes.containsKey(shoe.name)) {
                            combinedShoes[shoe.name]!.quantity += shoe.quantity;
                          } else {
                            combinedShoes[shoe.name] = shoe;
                          }
                        }

                        return ListView.builder(
                          itemCount: combinedShoes.length,
                          itemBuilder: (context, index) {
                            String key = combinedShoes.keys.elementAt(index);
                            Shoe shoe = combinedShoes[key]!;

                            return ListTile(
                              leading: shoe.image.isNotEmpty
                                  ? Image.network(
                                      shoe.image,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons
                                            .error); // Placeholder for error
                                      },
                                    )
                                  : Icon(Icons
                                      .shopping_bag), // Placeholder for no image
                              title: Text(shoe.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$${shoe.price}'),
                                  Text('Size: ${shoe.selectedSize}'),
                                  Text('Color: ${shoe.selectedColor}'),
                                  Text('Quantity: ${shoe.quantity}'),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (shoe.purchaseTime != null)
                                    Text(
                                      '${shoe.purchaseTime!.month}/${shoe.purchaseTime!.day} ${shoe.purchaseTime!.hour}:${shoe.purchaseTime!.minute}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShopPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
                        ),
                        child: const Text('Continue Shopping'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
