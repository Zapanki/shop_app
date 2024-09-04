import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'About Our Company',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to ShopApp, your number one source for all things shoes. We\'re dedicated to providing you the very best of products, with an emphasis on quality, affordability, and customer satisfaction.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Founded in 2023 by the ShopApp Team, our company has come a long way from its beginnings in a small office. When we first started out, our passion for helping people find the perfect shoes drove us to start our own business.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                'We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don\'t hesitate to contact us.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.purple[700]),
                title: Text('+1 234 567 890'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.purple[700]),
                title: Text('support@shopapp.com'),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.purple[700]),
                title: Text('1234 Shoe St, Fashion City, CA 90001'),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Thank you for choosing ShopApp!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
