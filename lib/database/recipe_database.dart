import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class RecipeDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT,
        image TEXT,
        url TEXT,
        calories INTEGER,
        ingredients TEXT,
        source TEXT,
        servings INTEGER,
        protein REAL,
        fat REAL,
        carbs REAL,
        fiber REAL,
        sugar REAL,
        sodium REAL
      )
    ''');
  }

  static Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert('recipes', {
      'label': recipe.label,
      'image': recipe.image,
      'url': recipe.url,
      'calories': recipe.calories,
      'ingredients': recipe.ingredientLines.join(', '),
      'source': recipe.source,
      'servings': recipe.servings,
      'protein': recipe.nutrients.protein,
      'fat': recipe.nutrients.fat,
      'carbs': recipe.nutrients.carbs,
      'fiber': recipe.nutrients.fiber,
      'sugar': recipe.nutrients.sugar,
      'sodium': recipe.nutrients.sodium,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final maps = await db.query('recipes');
    return maps.map((map) {
      return Recipe(
        label: map['label'] as String,
        image: map['image'] as String,
        url: map['url'] as String,
        calories: map['calories'] as int,
        ingredientLines: (map['ingredients'] as String).split(', '),
        nutrients: Nutrients(
          protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
          fat: (map['fat'] as num?)?.toDouble() ?? 0.0,
          carbs: (map['carbs'] as num?)?.toDouble() ?? 0.0,
          fiber: (map['fiber'] as num?)?.toDouble() ?? 0.0,
          sugar: (map['sugar'] as num?)?.toDouble() ?? 0.0,
          sodium: (map['sodium'] as num?)?.toDouble() ?? 0.0,
        ),
        dietLabels: [],
        healthLabels: [],
        source: map['source'] as String,
        servings: map['servings'] as int,
      );
    }).toList();
  }

  static Future<void> deleteRecipe(String label) async {
    final db = await database;
    await db.delete('recipes', where: 'label = ?', whereArgs: [label]);
  }
}
