import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinary_provider.dart';

class AnimalInfoForm extends StatefulWidget {
  const AnimalInfoForm({super.key});

  @override
  State<AnimalInfoForm> createState() => _AnimalInfoFormState();
}

class _AnimalInfoFormState extends State<AnimalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  
  String _selectedSpecies = '';
  String _selectedBreed = '';
  String _selectedGender = 'Mâle';

  @override
  void initState() {
    super.initState();
    _ageController.text = '1';
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VeterinaryProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSpeciesSelector(provider),
              if (_selectedSpecies.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildBreedSelector(provider),
              ],
              const SizedBox(height: 16),
              _buildGenderSelector(),
              const SizedBox(height: 16),
              _buildAgeInput(),
              const SizedBox(height: 16),
              _buildActionButtons(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.pets,
          color: Colors.blue[700],
        ),
        const SizedBox(width: 8),
        const Text(
          'Informations sur l\'animal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesSelector(VeterinaryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Espèce *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSpecies.isEmpty ? null : _selectedSpecies,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          hint: const Text('Sélectionner l\'espèce'),
          items: provider.availableSpecies.map((species) {
            return DropdownMenuItem(
              value: species,
              child: Text(species),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSpecies = value ?? '';
              _selectedBreed = '';
            });
            provider.setSpecies(_selectedSpecies);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner une espèce';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBreedSelector(VeterinaryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Race',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBreed.isEmpty ? null : _selectedBreed,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          hint: const Text('Sélectionner la race'),
          items: provider.availableBreeds.map((breed) {
            return DropdownMenuItem(
              value: breed,
              child: Text(breed),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBreed = value ?? '';
            });
            provider.setBreed(_selectedBreed);
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sexe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Mâle'),
                value: 'Mâle',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Femelle'),
                value: 'Femelle',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Âge (en années)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixText: 'an(s)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer l\'âge';
            }
            final age = int.tryParse(value);
            if (age == null || age < 0 || age > 30) {
              return 'Âge invalide (0-30 ans)';
            }
            return null;
          },
          onChanged: (value) {
            final age = int.tryParse(value);
            if (age != null) {
              context.read<VeterinaryProvider>().setAnimalAge(age);
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(VeterinaryProvider provider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _clearForm,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Effacer'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _validateAndSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sauvegarder'),
          ),
        ),
      ],
    );
  }

  void _clearForm() {
    setState(() {
      _selectedSpecies = '';
      _selectedBreed = '';
      _selectedGender = 'Mâle';
      _ageController.text = '1';
    });
    
    final provider = context.read<VeterinaryProvider>();
    provider.resetAnimalInfo();
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<VeterinaryProvider>();
      provider.setAnimalGender(_selectedGender);
      
      final age = int.tryParse(_ageController.text) ?? 1;
      provider.setAnimalAge(age);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informations sauvegardées'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
