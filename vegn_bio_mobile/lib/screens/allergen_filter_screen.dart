import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/allergen_provider.dart';
import '../models/allergen.dart';

class AllergenFilterScreen extends StatelessWidget {
  const AllergenFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtre Allergènes'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          Consumer<AllergenProvider>(
            builder: (context, allergenProvider, child) {
              if (allergenProvider.selectedAllergens.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    allergenProvider.clearSelectedAllergens();
                  },
                  child: const Text(
                    'Effacer',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<AllergenProvider>(
        builder: (context, allergenProvider, child) {
          if (allergenProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (allergenProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    allergenProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      allergenProvider.clearError();
                      allergenProvider.loadAllergens();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (allergenProvider.allergens.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun allergène disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Section des allergènes sélectionnés
              if (allergenProvider.selectedAllergens.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Allergènes sélectionnés:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: allergenProvider.selectedAllergens.map((code) {
                          final allergen = allergenProvider.allergens
                              .firstWhere((a) => a.code == code);
                          return Chip(
                            label: Text(allergen.name),
                            backgroundColor: Colors.red[200],
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              allergenProvider.toggleAllergen(code);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              
              // Liste des allergènes
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allergenProvider.allergens.length,
                  itemBuilder: (context, index) {
                    final allergen = allergenProvider.allergens[index];
                    final isSelected = allergenProvider.isAllergenSelected(allergen.code);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: isSelected ? 4 : 1,
                      color: isSelected ? Colors.red[50] : null,
                      child: CheckboxListTile(
                        title: Text(
                          allergen.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.red[700] : null,
                          ),
                        ),
                        subtitle: Text(allergen.description),
                        value: isSelected,
                        onChanged: (value) {
                          allergenProvider.toggleAllergen(allergen.code);
                        },
                        secondary: Icon(
                          Icons.warning,
                          color: isSelected ? Colors.red[700] : Colors.grey[600],
                        ),
                        activeColor: Colors.red[700],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
