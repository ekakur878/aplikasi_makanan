import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/recipe.dart';

class DetailRecipePage extends StatelessWidget {
  final Recipe recipe;

  const DetailRecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;

    Image imageWidget;
    if (recipe.imagePath.startsWith('assets/')) {
      imageWidget = Image.asset(recipe.imagePath, fit: BoxFit.cover);
    } else if (isWeb) {
      imageWidget = Image.network(recipe.imagePath, fit: BoxFit.cover);
    } else {
      imageWidget = Image.file(File(recipe.imagePath), fit: BoxFit.cover);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          recipe.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: imageWidget,
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Icon(Icons.shopping_basket, color: Colors.pink),
                SizedBox(width: 8),
                Text(
                  "Bahan-Bahan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.ingredients,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Icon(Icons.restaurant_menu, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Langkah Memasak",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.steps,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
