import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'add_manual_recipe_screen.dart';
import '../database/recipe_database.dart'; // ✅ Tambahkan ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _selectedMealType = '';
  String _selectedHealth = '';

  final List<String> _healthOptions = [
    '',
    'vegan',
    'gluten-free',
    'dairy-free',
    'egg-free',
    'soy-free',
    'wheat-free',
    'sugar-conscious',
  ];

  final Map<String, String> _healthLabels = {
    '': 'Semua',
    'vegan': 'Vegan',
    'gluten-free': 'Bebas Gluten',
    'dairy-free': 'Bebas Susu',
    'egg-free': 'Bebas Telur',
    'soy-free': 'Bebas Kedelai',
    'wheat-free': 'Bebas Gandum',
    'sugar-conscious': 'Rendah Gula',
  };

  final List<String> _mealTypes = ['', 'breakfast', 'lunch', 'dinner', 'snack'];

  final Map<String, String> _mealTypeLabels = {
    '': 'Semua Jenis',
    'breakfast': 'Sarapan',
    'lunch': 'Makan Siang',
    'dinner': 'Makan Malam',
    'snack': 'Camilan',
  };

  @override
  void initState() {
    super.initState();
    _loadPopularRecipes();
  }

  // ✅ Diubah: gabungkan hasil dari SQLite dan API
  Future<void> _loadPopularRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final localRecipes = await RecipeDatabase.getRecipes(); // dari SQLite
      final apiRecipes =
          await RecipeService.getPopularAsianRecipes(); // dari API
      setState(() {
        _recipes = [...localRecipes, ...apiRecipes]; // digabung
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading recipes: $e')));
      }
    }
  }

  Future<void> _searchRecipes() async {
    final query = _searchController.text.trim();
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await RecipeService.searchRecipes(
        query: query,
        mealType: _selectedMealType,
        health: _selectedHealth,
      );
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error searching recipes: $e')));
      }
    }
  }

  void _onRecipeTap(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asian Recipes By Kelompok 4',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search dan filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari resep yang anda inginkan...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF00695C),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _searchRecipes,
                      icon: const Icon(Icons.send, color: Color(0xFF00695C)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Color(0xFF00695C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Color(0xFF00695C),
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _searchRecipes(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMealType,
                        decoration: InputDecoration(
                          labelText: 'Jenis Hidangan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items:
                            _mealTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(_mealTypeLabels[type] ?? type),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMealType = value ?? '';
                          });
                          _searchRecipes();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedHealth,
                        decoration: InputDecoration(
                          labelText: 'Kesehatan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items:
                            _healthOptions.map((health) {
                              return DropdownMenuItem(
                                value: health,
                                child: Text(_healthLabels[health] ?? health),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHealth = value ?? '';
                          });
                          _searchRecipes();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF00695C)),
                          SizedBox(height: 16),
                          Text('Memuat resep...'),
                        ],
                      ),
                    )
                    : _recipes.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada resep ditemukan',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Coba kata kunci lain',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(
                            recipe: _recipes[index],
                            onTap: () => _onRecipeTap(_recipes[index]),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00695C),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddManualRecipeScreen()),
          ).then((_) => _loadPopularRecipes()); // agar refresh setelah kembali
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
