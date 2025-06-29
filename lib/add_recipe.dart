import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/recipe.dart';

class AddRecipePage extends StatefulWidget {
  /// Callback hanya dipakai saat MODE TAMBAH
  final Function(Recipe)? onRecipeAdded;

  /// Jika diisi berarti MODE EDIT
  final Recipe? existingRecipe;

  const AddRecipePage({super.key, this.onRecipeAdded, this.existingRecipe});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  XFile? _pickedImage; // gambar baru (boleh null kalau tak diganti)

  bool get _isEdit => widget.existingRecipe != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final r = widget.existingRecipe!;
      _nameController.text = r.name;
      _ingredientsController.text = r.ingredients;
      _stepsController.text = r.steps;
      // Tampilkan thumbnail lama; pengguna boleh membiarkannya
      _pickedImage = XFile(r.imagePath);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = picked);
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _ingredientsController.text.trim().isEmpty ||
        _stepsController.text.trim().isEmpty ||
        _pickedImage == null)
      return; // validasi sederhana

    final recipe = Recipe(
      name: _nameController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      steps: _stepsController.text.trim(),
      imagePath: _pickedImage!.path,
      isFavorite: _isEdit ? widget.existingRecipe!.isFavorite : false,
    );

    // ───── Mode EDIT ─────
    if (_isEdit) {
      Navigator.pop(context, recipe); // kirim balik hasil edit
      return;
    }

    // ───── Mode TAMBAH ────
    widget.onRecipeAdded!(recipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final title = _isEdit ? 'Edit Resep' : 'Tambah Resep';
    final btnLabel = _isEdit ? 'Simpan' : 'Tambah';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                _label('Nama Resep'),
                _buildTextField(_nameController),

                const SizedBox(height: 16),
                _label('Bahan-Bahan'),
                _buildTextField(_ingredientsController, maxLines: 3),

                const SizedBox(height: 16),
                _label('Langkah-Langkah Memasak'),
                _buildTextField(_stepsController, maxLines: 4),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(_isEdit ? 'Ganti Gambar' : 'Pilih Gambar Resep'),
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
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6DFB),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    btnLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontSize: 16));

  Widget _buildTextField(TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextField(
        controller: c,
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
      ),
    );
  }
}
