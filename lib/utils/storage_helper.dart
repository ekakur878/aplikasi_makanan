import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';

class StorageHelper {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/recipes.json');
  }

  static Future<List<Recipe>> readRecipes() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> data = jsonDecode(contents);
      return data.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> writeRecipes(List<Recipe> recipes) async {
    final file = await _getFile();
    final json = recipes.map((r) => r.toJson()).toList();
    await file.writeAsString(jsonEncode(json));
  }
}
