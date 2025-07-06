import 'package:flutter/material.dart';
import '../database/recipe_database.dart';
import '../models/recipe.dart';

class AddManualRecipeScreen extends StatefulWidget {
  const AddManualRecipeScreen({super.key});

  @override
  State<AddManualRecipeScreen> createState() => _AddManualRecipeScreenState();
}

class _AddManualRecipeScreenState extends State<AddManualRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _sourceController = TextEditingController();
  final _imageController = TextEditingController();
  final _servingsController = TextEditingController();

  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _sodiumController = TextEditingController();

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
        label: _labelController.text,
        image: _imageController.text,
        url: '', // Kosong karena manual
        calories: int.tryParse(_caloriesController.text) ?? 0,
        ingredientLines: _ingredientsController.text.split(','),
        nutrients: Nutrients(
          protein: double.tryParse(_proteinController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
          carbs: double.tryParse(_carbsController.text) ?? 0,
          fiber: double.tryParse(_fiberController.text) ?? 0,
          sugar: double.tryParse(_sugarController.text) ?? 0,
          sodium: double.tryParse(_sodiumController.text) ?? 0,
        ),
        dietLabels: [],
        healthLabels: [],
        source: _sourceController.text,
        servings: int.tryParse(_servingsController.text) ?? 1,
      );

      await RecipeDatabase.insertRecipe(newRecipe);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil disimpan!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    _sourceController.dispose();
    _imageController.dispose();
    _servingsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Resep Manual')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Nama Resep'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Kalori'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Bahan (pisahkan dengan koma)',
                ),
              ),
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Sumber'),
              ),
              TextFormField(
                controller: _servingsController,
                decoration: const InputDecoration(labelText: 'Porsi'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Informasi Nutrisi (per porsi)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Lemak (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: 'Karbohidrat (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fiberController,
                decoration: const InputDecoration(labelText: 'Serat (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _sugarController,
                decoration: const InputDecoration(labelText: 'Gula (g)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _sodiumController,
                decoration: const InputDecoration(labelText: 'Sodium (mg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
