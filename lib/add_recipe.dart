import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/recipe.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class AddRecipePage extends StatefulWidget {
  final Function(Recipe)? onRecipeAdded;
  final Recipe? existingRecipe;

  const AddRecipePage({super.key, this.onRecipeAdded, this.existingRecipe});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  XFile? _pickedImage;

  bool get _isEdit => widget.existingRecipe != null;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final r = widget.existingRecipe!;
      _nameController.text = r.name;
      _ingredientsController.text = r.ingredients;
      _stepsController.text = r.steps;
      _pickedImage = XFile(r.imagePath);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
        _imageError = null;
      });
    }
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_pickedImage == null) {
      setState(() => _imageError = 'Gambar harus dipilih.');
    }

    if (!isValid || _pickedImage == null) return;

    final recipe = Recipe(
      name: _nameController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      steps: _stepsController.text.trim(),
      imagePath: _pickedImage!.path,
      isFavorite: _isEdit ? widget.existingRecipe!.isFavorite : false,
    );

    if (_isEdit) {
      Navigator.pop(context, recipe);
    } else {
      widget.onRecipeAdded!(recipe);
      Navigator.pop(context);
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _label('Nama Resep'),
                  _buildTextField(_nameController, 'Nama tidak boleh kosong'),

                  const SizedBox(height: 18),
                  _label('Bahan-Bahan'),
                  _buildTextField(
                    _ingredientsController,
                    'Bahan tidak boleh kosong',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 18),
                  _label('Langkah-Langkah Memasak'),
                  _buildTextField(
                    _stepsController,
                    'Langkah tidak boleh kosong',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: Text(_isEdit ? 'Ganti Gambar' : 'Pilih Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6DFB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),

                  if (_imageError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _imageError!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],

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

                  const SizedBox(height: 30),
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
                      style: GoogleFonts.poppins(
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
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String errorText, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator:
          (value) => value == null || value.trim().isEmpty ? errorText : null,
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
