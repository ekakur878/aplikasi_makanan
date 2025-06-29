import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';

class FileHelper {
  static const _fileName = 'recipes.json';

  // Mendapatkan direktori file
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Load semua resep dari file JSON
  static Future<List<Recipe>> loadRecipes() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return jsonData.map((item) => Recipe.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Gagal memuat resep: $e');
      return [];
    }
  }

  // Simpan daftar resep ke file JSON
  static Future<void> saveRecipes(List<Recipe> recipes) async {
    try {
      final file = await _getFile();
      final List<Map<String, dynamic>> jsonData =
          recipes.map((recipe) => recipe.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Gagal menyimpan resep: $e');
    }
  }

  static Future<void> clearRecipes() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        await file.writeAsString('[]'); // Kosongkan dengan array kosong
      }
    } catch (e) {
      print('Gagal menghapus resep: $e');
    }
  }
}
