import 'package:flutter/material.dart';
import '../models/error_report.dart';

class ErrorReportForm extends StatefulWidget {
  final Function(ErrorReport) onSubmit;

  const ErrorReportForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ErrorReportForm> createState() => _ErrorReportFormState();
}

class _ErrorReportFormState extends State<ErrorReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _errorMessageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedErrorType = 'other';
  String _selectedSeverity = 'medium';

  @override
  void dispose() {
    _errorMessageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildErrorTypeSelector(),
                    const SizedBox(height: 16),
                    _buildSeveritySelector(),
                    const SizedBox(height: 16),
                    _buildErrorMessageField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 16),
                    _buildPreviewSection(),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bug_report,
            color: Colors.red[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signaler une erreur',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Aidez-nous à améliorer l\'application',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type d\'erreur *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedErrorType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'ui', child: Text('Erreur interface')),
            DropdownMenuItem(value: 'network', child: Text('Erreur réseau')),
            DropdownMenuItem(value: 'crash', child: Text('Plantage')),
            DropdownMenuItem(value: 'validation', child: Text('Erreur validation')),
            DropdownMenuItem(value: 'performance', child: Text('Problème performance')),
            DropdownMenuItem(value: 'other', child: Text('Autre')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedErrorType = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner un type d\'erreur';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSeveritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sévérité',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSeverity,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'low',
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text('Faible'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'medium',
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 16),
                  SizedBox(width: 8),
                  Text('Moyen'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'high',
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text('Élevé'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'critical',
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Critique'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSeverity = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildErrorMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description de l\'erreur *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _errorMessageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Décrivez ce qui s\'est passé...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Veuillez décrire l\'erreur';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations supplémentaires',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Étapes pour reproduire, contexte...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu du rapport',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPreviewItem('Type', _getErrorTypeDisplayName(_selectedErrorType)),
          _buildPreviewItem('Sévérité', _getSeverityDisplayName(_selectedSeverity)),
          _buildPreviewItem('Message', _errorMessageController.text.isEmpty 
              ? 'Non renseigné' 
              : _errorMessageController.text),
          if (_descriptionController.text.isNotEmpty)
            _buildPreviewItem('Description', _descriptionController.text),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Envoyer'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final report = ErrorReport(
        errorType: _selectedErrorType,
        errorMessage: _errorMessageController.text.trim(),
        stackTrace: 'Stack trace simulé pour la démonstration',
        userId: 'user_demo',
        deviceInfo: 'Device simulé',
        appVersion: '1.0.0',
        timestamp: DateTime.now(),
        severity: _selectedSeverity,
        userDescription: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      widget.onSubmit(report);
    }
  }

  String _getErrorTypeDisplayName(String type) {
    switch (type) {
      case 'ui':
        return 'Erreur interface';
      case 'network':
        return 'Erreur réseau';
      case 'crash':
        return 'Plantage';
      case 'validation':
        return 'Erreur validation';
      case 'performance':
        return 'Problème performance';
      default:
        return 'Autre';
    }
  }

  String _getSeverityDisplayName(String severity) {
    switch (severity) {
      case 'low':
        return 'Faible';
      case 'medium':
        return 'Moyen';
      case 'high':
        return 'Élevé';
      case 'critical':
        return 'Critique';
      default:
        return 'Inconnu';
    }
  }
}
