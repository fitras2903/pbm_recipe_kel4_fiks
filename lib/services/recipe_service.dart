import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

// Dokumentsi API https://developer.edamam.com/edamam-docs-recipe-api

class RecipeService {
  static const String _baseUrl =
      'https://api.edamam.com/api/recipes/v2'; // API yg dipakai
  static const String _appId = '28e18674';
  static const String _appKey = '6d7de5a4a4e71617d6295da662a5e5b3';
  static const String _userId = '28e18674';

  static Future<List<Recipe>> searchRecipes({
    String query = 'asian',
    String mealType = '',
    String health = '',
  }) async {
    String url =
        '$_baseUrl?type=public&app_id=$_appId&app_key=$_appKey&q=$query&cuisineType=asian';

    if (mealType.isNotEmpty) {
      url += '&mealType=$mealType';
    }

    if (health.isNotEmpty) {
      url += '&health=$health';
    }
    print('API HIT: $url');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Edamam-Account-User': _userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hits = data['hits'] as List;
        return hits.map((hit) => Recipe.fromJson(hit)).toList();
      } else {
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        } catch (_) {}
        throw Exception('Gagal memuat resep: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil resep: $e');
    }
  }

  static Future<List<Recipe>> getPopularAsianRecipes() async {
    return await searchRecipes(query: '');
  }
}
