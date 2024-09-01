import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/shoe.dart';
import 'package:shop_app/components/shoe_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'favorites_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String searchQuery = '';
  String selectedSize = 'M';
  String selectedColor = 'Red';
  int selectedQuantity = 1;
  List<Shoe> shoes = [];
  Set<String> favoriteIds = Set<String>(); // Set to hold favorite shoe IDs

  @override
  void initState() {
    super.initState();
    _loadShoes();
    _loadFavorites(); // Load the favorites from Firestore
  }

  Future<void> _loadShoes() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final List<Shoe> loadedShoes = querySnapshot.docs.map((doc) {
        return Shoe(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          desc: doc['desc'],
          price: (doc['price'] as num).toDouble(),
          selectedSize: doc['selectedSize'] ?? 'M',
          selectedColor: doc['selectedColor'] ?? 'Red',
          isFavorite:
              favoriteIds.contains(doc.id), // Check if it's in favorites
          quantity: doc['quantity'] ?? 1,
        );
      }).toList();
      setState(() {
        shoes = loadedShoes;
      });
    } catch (e) {
      print("Error loading shoes: $e");
    }
  }

  Future<void> _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      setState(() {
        favoriteIds = querySnapshot.docs.map((doc) => doc.id).toSet();
      });

      // Re-load the shoes to apply the favorite status
      _loadShoes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        List<Shoe> filteredShoes = shoes.where((shoe) {
          return shoe.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Shop"),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context, delegate: ShoeSearchDelegate(shoes));
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: filteredShoes.isEmpty
              ? Center(child: Text('No products available'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Hot Picks',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: ShoeSearchDelegate(shoes),
                                );
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: filteredShoes.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Shoe shoe = filteredShoes[index];
                            return ShoeTile(
                              shoe: shoe,
                              onTap: () {
                                Provider.of<Cart>(context, listen: false)
                                    .addItemToCart(
                                  shoe.copyWith(
                                      selectedSize: selectedSize,
                                      selectedColor: selectedColor,
                                      quantity: selectedQuantity),
                                );
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('cart')
                                    .add({
                                  'name': shoe.name,
                                  'image': shoe.image,
                                  'desc': shoe.desc,
                                  'price': shoe.price,
                                  'size': selectedSize,
                                  'color': selectedColor,
                                  'quantity': selectedQuantity,
                                });
                              },
                              selectedQuantity: selectedQuantity,
                              onQuantityChanged: (quantity) {
                                setState(() {
                                  selectedQuantity = quantity ?? 1;
                                });
                              },
                              onFavoriteTap: () async {
                                setState(() {
                                  shoe.isFavorite = !shoe.isFavorite;
                                });

                                try {
                                  final docRef = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('favorites')
                                      .doc(shoe.id);

                                  if (shoe.isFavorite) {
                                    // Add to favorites
                                    await docRef.set({
                                      'name': shoe.name,
                                      'image': shoe.image,
                                      'desc': shoe.desc,
                                      'price': shoe.price,
                                      'size': shoe.selectedSize,
                                      'color': shoe.selectedColor,
                                    });
                                  } else {
                                    // Remove from favorites
                                    await docRef.delete();
                                  }
                                } catch (e) {
                                  print('Failed to update favorites: $e');
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class ShoeSearchDelegate extends SearchDelegate<Shoe?> {
  final List<Shoe> shoeList;

  ShoeSearchDelegate(this.shoeList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Shoe> results = shoeList
        .where((shoe) => shoe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Shoe shoe = results[index];
        return InkWell(
          onTap: () {
            close(context, shoe);
            query = ''; // Сбрасываем запрос после выбора
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 50, // Задайте ширину контейнера
                  height: 50, // Задайте высоту контейнера
                  child: Image.network(
                    shoe.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Замените ошибку загрузки изображением-заглушкой или иконкой
                      return Icon(Icons.error);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("\$${shoe.price}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Shoe> suggestions = shoeList
        .where((shoe) => shoe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Shoe shoe = suggestions[index];
        return ListTile(
          title: Text(shoe.name),
          leading: Image.network(shoe.image),
          onTap: () {
            query = shoe.name;
            showResults(context);
          },
        );
      },
    );
  }
}
