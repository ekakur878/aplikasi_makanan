import 'package:flutter/material.dart';
import 'helpers/file_helper.dart';
import 'models/recipe.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load data dari penyimpanan lokal
  final recipes = await FileHelper.loadRecipes();

  runApp(YummieApp(initialRecipes: recipes));
}

class YummieApp extends StatelessWidget {
  final List<Recipe> initialRecipes;

  const YummieApp({super.key, required this.initialRecipes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 64, 70, 255),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFAF0),
        fontFamily: 'Sansita',
      ),
      // Kirim data ke splash screen
      home: SplashScreen(initialRecipes: initialRecipes),
    );
  }
}
