import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        elevation: 1,
        title: Text(
          recipe.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: recipe.imagePath,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 28),

            // Bahan-bahan Section
            Row(
              children: [
                const Icon(Icons.shopping_basket, color: Colors.pink),
                const SizedBox(width: 8),
                Text(
                  "Bahan-Bahan",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _contentCard(recipe.ingredients),

            const SizedBox(height: 24),

            // Langkah-langkah Section
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "Langkah Memasak",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _contentCard(recipe.steps),
          ],
        ),
      ),
    );
  }

  Widget _contentCard(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 15, height: 1.6)),
    );
  }
}
