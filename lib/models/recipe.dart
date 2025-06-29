class Recipe {
  String name;
  String ingredients;
  String steps;
  String imagePath;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      imagePath: json['imagePath'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'ingredients': ingredients,
    'steps': steps,
    'imagePath': imagePath,
    'isFavorite': isFavorite,
  };
}
