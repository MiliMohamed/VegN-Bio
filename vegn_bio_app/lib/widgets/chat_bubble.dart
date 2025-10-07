import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/veterinary_consultation.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isUser 
                      ? Colors.blue[700] 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 16),
                  ),
                  border: message.isUser 
                      ? null 
                      : Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(),
                    const SizedBox(height: 4),
                    _buildTimestamp(),
                  ],
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.pets,
        size: 18,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.person,
        size: 18,
        color: Colors.green[700],
      ),
    );
  }

  Widget _buildMessageContent() {
    return Text(
      message.content,
      style: TextStyle(
        fontSize: 14,
        color: message.isUser ? Colors.white : Colors.black87,
        height: 1.4,
      ),
    );
  }

  Widget _buildTimestamp() {
    final formatter = DateFormat('HH:mm');
    return Text(
      formatter.format(message.timestamp),
      style: TextStyle(
        fontSize: 11,
        color: message.isUser 
            ? Colors.white.withOpacity(0.7) 
            : Colors.grey[500],
      ),
    );
  }
}

class DiagnosisBubble extends StatelessWidget {
  final String diagnosis;
  final double confidence;
  final DateTime timestamp;

  const DiagnosisBubble({
    super.key,
    required this.diagnosis,
    required this.confidence,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildDiagnosisContent(),
                  const SizedBox(height: 12),
                  _buildConfidenceIndicator(),
                  const SizedBox(height: 8),
                  _buildTimestamp(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.medical_services,
        size: 18,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.psychology,
          size: 20,
          color: Colors.blue[700],
        ),
        const SizedBox(width: 8),
        Text(
          'Diagnostic IA',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosisContent() {
    return Text(
      diagnosis,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    final confidencePercent = (confidence * 100).round();
    final color = confidence > 0.8 
        ? Colors.green 
        : confidence > 0.6 
            ? Colors.orange 
            : Colors.red;

    return Row(
      children: [
        Icon(
          Icons.analytics,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$confidencePercent%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTimestamp() {
    final formatter = DateFormat('HH:mm');
    return Text(
      formatter.format(timestamp),
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey[500],
      ),
    );
  }
}

class SystemMessageBubble extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const SystemMessageBubble({
    super.key,
    required this.message,
    this.icon = Icons.info,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
