import 'dart:io';
import 'package:aplikasi_makanan/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'detail_recipe.dart';
import '../models/recipe.dart';
import '../helpers/file_helper.dart';

class HomeRecipePage extends StatefulWidget {
  final List<Recipe> recipes;

  const HomeRecipePage({super.key, this.recipes = const []});

  @override
  State<HomeRecipePage> createState() => _HomeRecipePageState();
}

class _HomeRecipePageState extends State<HomeRecipePage> {
  final List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _recipes.addAll(widget.recipes);
    _filteredRecipes = List.from(_recipes);
  }

  void _addNewRecipe(Recipe recipe) {
    setState(() {
      _recipes.add(recipe);
      _applySearch(_searchText);
    });
    FileHelper.saveRecipes(_recipes); // Simpan ke lokal
  }

  void _applySearch(String query) {
    setState(() {
      _searchText = query;
      _filteredRecipes =
          _recipes
              .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
    });
    FileHelper.saveRecipes(_recipes); // Simpan perubahan favorit
  }

  void _editRecipe(Recipe oldRecipe) async {
    final editedRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => AddRecipePage(existingRecipe: oldRecipe),
      ),
    );

    if (editedRecipe != null) {
      setState(() {
        final index = _recipes.indexOf(oldRecipe);
        _recipes[index] = editedRecipe;
        _applySearch(_searchText);
      });
      FileHelper.saveRecipes(_recipes);
    }
  }

  void _deleteRecipe(Recipe recipe) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Resep'),
            content: const Text('Apakah Anda yakin ingin menghapus resep ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recipes.remove(recipe);
                    _applySearch(_searchText);
                  });
                  FileHelper.saveRecipes(_recipes);
                  Navigator.pop(context);
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Future<void> _resetRecipes() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text(
              'Apakah kamu yakin ingin menghapus semua resep?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => SplashScreen(initialRecipes: const []),
                    ),
                    (route) => true,
                  );
                },
                child: const Text('Ya'),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      await FileHelper.clearRecipes();
      setState(() {
        _recipes.clear();
        _filteredRecipes.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Chef',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 240, 241, 255),
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Semua Resep'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredRecipes = _recipes;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorit'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _filteredRecipes =
                      _recipes.where((r) => r.isFavorite).toList();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _resetRecipes,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari resep favoritmu...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _applySearch,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child:
                _filteredRecipes.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada resep yang ditambahkan',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: _filteredRecipes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (_, i) {
                        final recipe = _filteredRecipes[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DetailRecipePage(recipe: recipe),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 300,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                      child:
                                          isWeb
                                              ? Image.network(
                                                recipe.imagePath,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.file(
                                                File(recipe.imagePath),
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () => _editRecipe(recipe),
                                          tooltip: 'Edit',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed:
                                              () => _deleteRecipe(recipe),
                                          tooltip: 'Hapus',
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            recipe.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                recipe.isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => _toggleFavorite(recipe),
                                          tooltip: 'Favorit',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRecipePage(onRecipeAdded: _addNewRecipe),
            ),
          );
        },
        backgroundColor: const Color(0xFF1E6DFB),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
