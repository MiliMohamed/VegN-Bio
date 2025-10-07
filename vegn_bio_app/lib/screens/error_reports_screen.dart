import 'package:flutter/material.dart';
import '../models/error_report.dart';
import '../services/error_reporting_service.dart';
import '../widgets/error_report_card.dart';
import '../widgets/error_report_form.dart';

class ErrorReportsScreen extends StatefulWidget {
  const ErrorReportsScreen({super.key});

  @override
  State<ErrorReportsScreen> createState() => _ErrorReportsScreenState();
}

class _ErrorReportsScreenState extends State<ErrorReportsScreen> {
  final ErrorReportingService _errorService = ErrorReportingService();
  List<ErrorReport> _reports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    
    try {
      _reports = _errorService.getLocalReports();
    } catch (e) {
      _showErrorSnackBar('Erreur lors du chargement des rapports: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reports.isEmpty
                    ? _buildEmptyState()
                    : _buildReportsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReportForm,
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.bug_report, color: Colors.white),
        tooltip: 'Signaler une erreur',
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[700],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bug_report,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rapports d\'erreurs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Signaler et suivre les problèmes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loadReports,
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Actualiser',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final criticalCount = _reports.where((r) => r.severity == 'critical').length;
    final highCount = _reports.where((r) => r.severity == 'high').length;
    final totalCount = _reports.length;

    return Row(
      children: [
        _buildStatCard('Total', totalCount.toString(), Colors.white),
        const SizedBox(width: 8),
        _buildStatCard('Critique', criticalCount.toString(), Colors.red[300]!),
        const SizedBox(width: 8),
        _buildStatCard('Élevé', highCount.toString(), Colors.orange[300]!),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _retryFailedReports,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun rapport d\'erreur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'L\'application fonctionne correctement',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _sendTestReport,
            icon: const Icon(Icons.bug_report),
            label: const Text('Envoyer un rapport de test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return ErrorReportCard(
          report: report,
          onTap: () => _showReportDetails(report),
          onDelete: () => _deleteReport(report),
        );
      },
    );
  }

  void _showReportForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ErrorReportForm(
        onSubmit: (report) async {
          try {
            await _errorService.reportError(
              errorType: report.errorType,
              errorMessage: report.errorMessage,
              stackTrace: report.stackTrace,
              userDescription: report.userDescription,
              additionalData: report.additionalData,
              severity: ErrorSeverity.values.firstWhere(
                (e) => e.value == report.severity,
                orElse: () => ErrorSeverity.medium,
              ),
            );
            
            Navigator.of(context).pop();
            _loadReports();
            _showSuccessSnackBar('Rapport envoyé avec succès');
          } catch (e) {
            _showErrorSnackBar('Erreur lors de l\'envoi: $e');
          }
        },
      ),
    );
  }

  void _showReportDetails(ErrorReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails du rapport'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', report.errorType),
              _buildDetailRow('Message', report.errorMessage),
              _buildDetailRow('Sévérité', report.severity),
              _buildDetailRow('Date', report.formattedTimestamp),
              _buildDetailRow('Version', report.appVersion),
              if (report.userDescription != null)
                _buildDetailRow('Description', report.userDescription!),
              const SizedBox(height: 16),
              const Text(
                'Stack Trace:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.stackTrace,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _deleteReport(ErrorReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rapport'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce rapport ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Note: Dans une vraie app, on supprimerait le rapport
              _showSuccessSnackBar('Rapport supprimé');
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _retryFailedReports() async {
    try {
      await _errorService.retryFailedReports();
      _loadReports();
      _showSuccessSnackBar('Tentative de renvoi effectuée');
    } catch (e) {
      _showErrorSnackBar('Erreur lors du retry: $e');
    }
  }

  Future<void> _sendTestReport() async {
    try {
      await _errorService.sendTestReport();
      _loadReports();
      _showSuccessSnackBar('Rapport de test envoyé');
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'envoi du test: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
