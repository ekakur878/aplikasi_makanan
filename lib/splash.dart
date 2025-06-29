import 'package:flutter/material.dart';
import 'dart:async';
import 'home_recipe.dart';
import '../models/recipe.dart'; // pastikan impor ini ada

class SplashScreen extends StatefulWidget {
  final List<Recipe> initialRecipes;

  const SplashScreen({super.key, required this.initialRecipes});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeRecipePage(recipes: widget.initialRecipes),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF6),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/food_bg.jpg',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '🍴 Chef',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 76, 69, 255),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 76, 69, 255),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
