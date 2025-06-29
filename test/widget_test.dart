import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_makanan/main.dart';
import 'package:aplikasi_makanan/models/recipe.dart';

void main() {
  testWidgets('Splash screen renders with title and image', (
    WidgetTester tester,
  ) async {
    // Buat dummy resep
    final dummyRecipes = [
      Recipe(
        name: 'Nasi Goreng',
        ingredients: 'Nasi, Bawang, Kecap',
        steps: '1. Tumis bawang\n2. Masukkan nasi\n3. Tambah kecap',
        imagePath:
            'assets/food_bg.jpg', // pastikan asset ini ada di pubspec.yaml
      ),
    ];

    // Tampilkan widget utama
    await tester.pumpWidget(YummieApp(initialRecipes: dummyRecipes));

    // Verifikasi tampilan splash screen
    expect(find.text('🍴 Chef-Aslan'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Tunggu transisi Splash selesai (3 detik)
    await tester.pump(const Duration(seconds: 4));

    // Setelah splash, seharusnya muncul halaman HomeRecipePage
    // Kamu bisa tambahkan pengecekan lagi di sini jika sudah tahu widget HomeRecipePage seperti apa
  });
}
