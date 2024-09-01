import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/cart_page/cart_page.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/pages/profile/PurchasedItemsPage.dart';
import 'package:shop_app/reg&login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = '';
  String profileImageUrl =
      'assets/images/userprofile.png'; // Установлено по умолчанию
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Provider.of<Cart>(context, listen: false).getUserCart();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userName = userDoc['name'] ?? 'User';
        profileImageUrl = userDoc['profileImageUrl'] ?? profileImageUrl;
      });

      // Если профильное фото не установлено в базе данных, установить его по умолчанию
      if (profileImageUrl == 'assets/images/userprofile.png') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'profileImageUrl': profileImageUrl,
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(); // Добавлено ожидание загрузки изображения
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || user == null) return;

    try {
      String fileName = '${user!.uid}/profile_image.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'profileImageUrl': downloadUrl,
      });

      setState(() {
        profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile image updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile image: $e")),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Your Profile',
          style: TextStyle(color: Colors.purple),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchasedItemsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    maxRadius: 65,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider
                        : (profileImageUrl.isNotEmpty &&
                                !profileImageUrl.contains('assets/images'))
                            ? NetworkImage(profileImageUrl)
                            : AssetImage("assets/images/userprofile.png"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "@$userName",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<Cart>(
              builder: (context, cart, child) {
                final cartItems = cart.items;
                final itemsToShow = cartItems.length > 2
                    ? cartItems.sublist(cartItems.length - 2)
                    : cartItems;
                if (cartItems.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'Your Cart is Empty',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                      ),
                      Container(
                        height: 150,
                        child: Lottie.asset('assets/Animation - 1725208078442.json'), // Анимация для пустой корзины
                      ),
                    ],
                  ),
                );
              }

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Cart',
                      style: TextStyle(
                        fontSize: 22, // Сделаем шрифт немного больше
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[
                            700], // Используем оттенок фиолетового, как у заголовка
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey.withOpacity(
                                0.5), // Легкая тень для выделения текста
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: itemsToShow.length,
                      itemBuilder: (context, index) {
                        final shoe = itemsToShow[index];
                        return ListTile(
                          leading: Image.network(shoe.image, height: 50),
                          title: Text(shoe.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$${shoe.price}'),
                              Text('Size: ${shoe.selectedSize}'),
                              Text('Color: ${shoe.selectedColor}'),
                            ],
                          ),
                        );
                      },
                    ),
                      if (cartItems.length > 2)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()),
                            );
                          },
                          child: Text('Посмотреть все'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
