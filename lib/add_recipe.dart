import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/recipe.dart';

class AddRecipePage extends StatefulWidget {
  final Function(Recipe) onRecipeAdded;

  const AddRecipePage({super.key, required this.onRecipeAdded});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  void _submitRecipe() {
    if (_nameController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _stepsController.text.isEmpty ||
        _pickedImage == null) {
      return;
    }

    final recipe = Recipe(
      name: _nameController.text,
      ingredients: _ingredientsController.text,
      steps: _stepsController.text,
      imagePath: _pickedImage!.path,
      isFavorite: false,
    );
    widget.onRecipeAdded(recipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text('Nama Resep', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                _buildTextField(_nameController),

                const SizedBox(height: 16),
                const Text('Bahan-Bahan', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                _buildTextField(_ingredientsController, maxLines: 3),

                const SizedBox(height: 16),
                const Text(
                  'Langkah-Langkah Memasak',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                _buildTextField(_stepsController, maxLines: 4),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pilih Gambar Resep'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6DFB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),

                const SizedBox(height: 16),
                if (_pickedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        isWeb
                            ? Image.network(
                              _pickedImage!.path,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                            : Image.file(
                              File(_pickedImage!.path),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                  ),

                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _submitRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6DFB),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
