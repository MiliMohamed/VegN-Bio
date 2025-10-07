import 'package:flutter/material.dart';
import '../services/learning_service.dart';
import '../services/error_reporting_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ErrorReportingService _errorService = ErrorReportingService();
  bool _isLoading = false;
  Map<String, dynamic> _errorStats = {};
  List<dynamic> _recentConsultations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les statistiques d'erreurs
      final errorStats = await _errorService.getErrorStatistics();
      
      // Charger les consultations récentes
      final consultations = await LearningService.getConsultationHistory();

      setState(() {
        _errorStats = errorStats;
        _recentConsultations = consultations;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildErrorStatsCard(),
                  const SizedBox(height: 16),
                  _buildConsultationsCard(),
                  const SizedBox(height: 16),
                  _buildLearningInsightsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: Colors.red[700]),
                const SizedBox(width: 8),
                const Text(
                  'Statistiques d\'Erreurs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_errorStats.isNotEmpty) ...[
              _buildStatRow('Erreurs Total', '${_errorStats['totalErrors'] ?? 0}'),
              _buildStatRow('Erreurs API', '${_errorStats['apiErrors'] ?? 0}'),
              _buildStatRow('Erreurs Chatbot', '${_errorStats['chatbotErrors'] ?? 0}'),
              _buildStatRow('Erreurs Navigation', '${_errorStats['navigationErrors'] ?? 0}'),
            ] else
              const Text('Aucune donnée disponible'),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pets, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Consultations Récentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_recentConsultations.isNotEmpty)
              ...(_recentConsultations.take(5).map((consultation) => 
                _buildConsultationTile(consultation)))
            else
              const Text('Aucune consultation récente'),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationTile(dynamic consultation) {
    return ListTile(
      leading: const Icon(Icons.medical_services),
      title: Text(consultation['animalBreed'] ?? 'Race inconnue'),
      subtitle: Text('Symptômes: ${(consultation['symptoms'] as List?)?.join(', ') ?? 'N/A'}'),
      trailing: Text('${(consultation['confidence'] ?? 0) * 100}%'),
      isThreeLine: true,
    );
  }

  Widget _buildLearningInsightsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Insights d\'Apprentissage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Le système d\'apprentissage collecte automatiquement les consultations pour améliorer les diagnostics futurs.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final patterns = await LearningService.analyzePatterns();
                  _showPatternsDialog(patterns);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              },
              icon: const Icon(Icons.analytics),
              label: const Text('Analyser les Patterns'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showPatternsDialog(Map<String, dynamic> patterns) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patterns d\'Apprentissage'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (patterns.isNotEmpty) ...[
                Text('Races les plus consultées: ${patterns['topBreeds'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Symptômes les plus fréquents: ${patterns['topSymptoms'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Confiance moyenne: ${patterns['averageConfidence'] ?? 'N/A'}'),
              ] else
                const Text('Aucun pattern disponible'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
