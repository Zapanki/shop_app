import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/shoe.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Shoe>> _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return Shoe(
            id: doc.id,
            name: doc['name'],
            image: doc['image'],
            desc: doc['desc'],
            price: (doc['price'] as num).toDouble(),
            selectedSize: doc['size'],
            selectedColor: doc['color'],
            isFavorite: true,
          );
        }).toList();
      } else {
        print('No favorite products found.');
      }
    }
    return [];
  }

  Future<void> _removeFromFavorites(String shoeId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(shoeId)
            .delete();
        print('Product removed from favorites');
      } catch (e) {
        print('Failed to remove product from favorites: $e');
      }
    }
  }

  Future<void> _confirmDelete(Shoe shoe) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to remove "${shoe.name}" from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _removeFromFavorites(shoe.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: FutureBuilder<List<Shoe>>(
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load favorites'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites yet'));
          } else {
            List<Shoe> favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Shoe shoe = favorites[index];
                return ListTile(
                  leading: Image.network(shoe.image, width: 50, height: 50),
                  title: Text(shoe.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${shoe.price}'),
                      Text('Size: ${shoe.selectedSize}'),
                      Text('Color: ${shoe.selectedColor}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _confirmDelete(shoe);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
