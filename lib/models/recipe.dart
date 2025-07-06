class Recipe {
  final String label;
  final String image;
  final String url;
  final int calories;
  final List<String> ingredientLines;
  final Nutrients nutrients;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final String source;
  final int servings;

  Recipe({
    required this.label,
    required this.image,
    required this.url,
    required this.calories,
    required this.ingredientLines,
    required this.nutrients,
    required this.dietLabels,
    required this.healthLabels,
    required this.source,
    required this.servings,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final recipe = json['recipe'];
    return Recipe(
      label: recipe['label'] ?? '',
      image: recipe['image'] ?? '',
      url: recipe['url'] ?? '',
      calories: (recipe['calories'] ?? 0).round(),
      ingredientLines: List<String>.from(recipe['ingredientLines'] ?? []),
      nutrients: Nutrients.fromJson(recipe['totalNutrients'] ?? {}),
      dietLabels: List<String>.from(recipe['dietLabels'] ?? []),
      healthLabels: List<String>.from(recipe['healthLabels'] ?? []),
      source: recipe['source'] ?? '',
      servings: (recipe['yield'] ?? 1).round(),
    );
  }
}

class Nutrients {
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double sugar;
  final double sodium;

  Nutrients({
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      protein: (json['PROCNT']?['quantity'] ?? 0.0).toDouble(),
      fat: (json['FAT']?['quantity'] ?? 0.0).toDouble(),
      carbs: (json['CHOCDF']?['quantity'] ?? 0.0).toDouble(),
      fiber: (json['FIBTG']?['quantity'] ?? 0.0).toDouble(),
      sugar: (json['SUGAR']?['quantity'] ?? 0.0).toDouble(),
      sodium: (json['NA']?['quantity'] ?? 0.0).toDouble(),
    );
  }
}
