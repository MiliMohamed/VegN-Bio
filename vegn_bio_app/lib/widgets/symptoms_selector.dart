import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinary_provider.dart';

class SymptomsSelector extends StatefulWidget {
  const SymptomsSelector({super.key});

  @override
  State<SymptomsSelector> createState() => _SymptomsSelectorState();
}

class _SymptomsSelectorState extends State<SymptomsSelector> {
  final TextEditingController _customSymptomController = TextEditingController();

  @override
  void dispose() {
    _customSymptomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VeterinaryProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            if (provider.selectedSymptoms.isNotEmpty) ...[
              _buildSelectedSymptoms(provider),
              const SizedBox(height: 16),
            ],
            if (provider.commonSymptoms.isNotEmpty) ...[
              _buildCommonSymptoms(provider),
              const SizedBox(height: 16),
            ],
            _buildCustomSymptomInput(provider),
            const SizedBox(height: 16),
            _buildActionButtons(provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.medical_services,
          color: Colors.orange[700],
        ),
        const SizedBox(width: 8),
        const Text(
          'Sélection des symptômes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSymptoms(VeterinaryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Symptômes sélectionnés (${provider.selectedSymptoms.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (provider.selectedSymptoms.isNotEmpty)
              TextButton(
                onPressed: () => _clearAllSymptoms(provider),
                child: const Text(
                  'Effacer tout',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.selectedSymptoms.map((symptom) {
            return Chip(
              label: Text(symptom),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => provider.removeSymptom(symptom),
              backgroundColor: Colors.orange[100],
              deleteIconColor: Colors.orange[700],
              labelStyle: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCommonSymptoms(VeterinaryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptômes courants pour ${provider.selectedBreed.isNotEmpty ? provider.selectedBreed : provider.selectedSpecies}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.commonSymptoms.map((symptom) {
            final isSelected = provider.selectedSymptoms.contains(symptom);
            return FilterChip(
              label: Text(symptom),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  provider.toggleSymptom(symptom);
                } else {
                  provider.removeSymptom(symptom);
                }
              },
              selectedColor: Colors.orange[100],
              checkmarkColor: Colors.orange[700],
              backgroundColor: Colors.grey[100],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomSymptomInput(VeterinaryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajouter un symptôme personnalisé',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customSymptomController,
                decoration: InputDecoration(
                  hintText: 'Ex: Perte d\'appétit, Boiterie...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _addCustomSymptom(provider),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addCustomSymptom(provider),
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.orange[100],
                foregroundColor: Colors.orange[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(VeterinaryProvider provider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _clearAllSymptoms(provider),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Effacer tout'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: provider.canRequestDiagnosis ? () => _requestDiagnosis(provider) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: provider.isDiagnosing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Analyser'),
          ),
        ),
      ],
    );
  }

  void _addCustomSymptom(VeterinaryProvider provider) {
    final symptom = _customSymptomController.text.trim();
    if (symptom.isNotEmpty) {
      provider.addCustomSymptom(symptom);
      _customSymptomController.clear();
    }
  }

  void _clearAllSymptoms(VeterinaryProvider provider) {
    for (final symptom in provider.selectedSymptoms) {
      provider.removeSymptom(symptom);
    }
  }

  void _requestDiagnosis(VeterinaryProvider provider) {
    if (provider.canRequestDiagnosis) {
      provider.requestDiagnosis();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyse en cours...'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
