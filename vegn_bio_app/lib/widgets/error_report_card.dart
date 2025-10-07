import 'package:flutter/material.dart';
import '../models/error_report.dart';

class ErrorReportCard extends StatelessWidget {
  final ErrorReport report;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ErrorReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildErrorMessage(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildSeverityIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getErrorTypeDisplayName(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                report.formattedTimestamp,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        _buildSeverityBadge(),
        if (onDelete != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red[600],
          ),
        ],
      ],
    );
  }

  Widget _buildSeverityIcon() {
    IconData icon;
    Color color;

    switch (report.severity) {
      case 'critical':
        icon = Icons.error;
        color = Colors.red;
        break;
      case 'high':
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case 'medium':
        icon = Icons.info;
        color = Colors.blue;
        break;
      case 'low':
        icon = Icons.info_outline;
        color = Colors.green;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildSeverityBadge() {
    Color color;
    String text;

    switch (report.severity) {
      case 'critical':
        color = Colors.red;
        text = 'CRITIQUE';
        break;
      case 'high':
        color = Colors.orange;
        text = 'ÉLEVÉ';
        break;
      case 'medium':
        color = Colors.blue;
        text = 'MOYEN';
        break;
      case 'low':
        color = Colors.green;
        text = 'FAIBLE';
        break;
      default:
        color = Colors.grey;
        text = 'INCONNU';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.errorMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (report.userDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              'Description: ${report.userDescription}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          'v${report.appVersion}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.phone_android,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _truncateDeviceInfo(report.deviceInfo),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.chevron_right,
            size: 16,
            color: Colors.grey[400],
          ),
      ],
    );
  }

  String _getErrorTypeDisplayName() {
    switch (report.errorType) {
      case 'network':
        return 'Erreur réseau';
      case 'database':
        return 'Erreur base de données';
      case 'ui':
        return 'Erreur interface';
      case 'api':
        return 'Erreur API';
      case 'crash':
        return 'Plantage';
      case 'validation':
        return 'Erreur validation';
      case 'authentication':
        return 'Erreur authentification';
      case 'user_action':
        return 'Action utilisateur';
      case 'performance':
        return 'Problème performance';
      default:
        return 'Autre erreur';
    }
  }

  String _truncateDeviceInfo(String deviceInfo) {
    if (deviceInfo.length <= 20) return deviceInfo;
    return '${deviceInfo.substring(0, 17)}...';
  }
}
