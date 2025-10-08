import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/chatbot_provider.dart';
import '../models/chat.dart';
import '../services/conversation_storage_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final Uuid _uuid = const Uuid();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Vétérinaire'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          Consumer<ChatbotProvider>(
            builder: (context, chatbotProvider, child) {
              return IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  _showConversationHistory(chatbotProvider);
                },
                tooltip: 'Historique des conversations',
              );
            },
          ),
          Consumer<ChatbotProvider>(
            builder: (context, chatbotProvider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  chatbotProvider.clearChat();
                },
                tooltip: 'Nouvelle conversation',
              );
            },
          ),
        ],
      ),
      body: Consumer<ChatbotProvider>(
        builder: (context, chatbotProvider, child) {
          if (chatbotProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (chatbotProvider.error != null) {
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
                    'Erreur',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chatbotProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      chatbotProvider.clearError();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }

          // Convertir les messages pour flutter_chat_ui
          final messages = chatbotProvider.messages
              .map((msg) => msg.toFlutterChatMessage())
              .toList();

          return Column(
            children: [
              // Section de sélection de race et symptômes
              if (chatbotProvider.selectedBreed == null)
                _buildBreedSelection(chatbotProvider)
              else if (chatbotProvider.selectedSymptoms.isEmpty)
                _buildSymptomSelection(chatbotProvider)
              else
                _buildDiagnosisButton(chatbotProvider),
              
              // Chat
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatbotProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatbotProvider.messages[index];
                    final isUser = message.userId == 'user';
                    final isBot = message.userId == null || message.userId == 'bot';
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: isUser 
                            ? MainAxisAlignment.end 
                            : MainAxisAlignment.start,
                        children: [
                          if (isBot) ...[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue[700],
                              child: const Icon(
                                Icons.pets,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser 
                                  ? Colors.blue[600] 
                                  : message.type == MessageType.diagnosis
                                      ? Colors.green[100]
                                      : message.type == MessageType.recommendation
                                          ? Colors.orange[100]
                                          : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: message.type == MessageType.diagnosis
                                  ? Border.all(color: Colors.green[300]!)
                                  : message.type == MessageType.recommendation
                                      ? Border.all(color: Colors.orange[300]!)
                                      : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.type == MessageType.diagnosis) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.green[700],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Diagnostic',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                if (message.type == MessageType.recommendation) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        color: Colors.orange[700],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Recommandations',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(message.createdAt),
                                  style: TextStyle(
                                    color: isUser 
                                        ? Colors.white70 
                                        : Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isUser) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue[600],
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Champ de saisie
              _buildMessageInput(chatbotProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBreedSelection(ChatbotProvider chatbotProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sélectionnez la race de votre animal:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (chatbotProvider.supportedBreeds.isEmpty)
            const Text('Chargement des races...')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chatbotProvider.supportedBreeds.map((breed) {
                return ActionChip(
                  label: Text(breed),
                  onPressed: () {
                    chatbotProvider.selectBreed(breed);
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSymptomSelection(ChatbotProvider chatbotProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sélectionnez les symptômes pour ${chatbotProvider.selectedBreed}:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (chatbotProvider.commonSymptoms.isEmpty)
            const Text('Chargement des symptômes...')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chatbotProvider.commonSymptoms.map((symptom) {
                final isSelected = chatbotProvider.selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    chatbotProvider.toggleSymptom(symptom);
                  },
                  selectedColor: Colors.orange[200],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisButton(ChatbotProvider chatbotProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pets, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                'Race: ${chatbotProvider.selectedBreed}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Symptômes: ${chatbotProvider.selectedSymptoms.join(', ')}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    chatbotProvider.getDiagnosis();
                  },
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Diagnostic'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    chatbotProvider.getDetailedRecommendations();
                  },
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('Recommandations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              ElevatedButton.icon(
                onPressed: () {
                  _showSymptomDetails(chatbotProvider.selectedSymptoms);
                },
                icon: const Icon(Icons.info),
                label: const Text('Détails'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                chatbotProvider.getPreventiveRecommendations();
              },
              icon: const Icon(Icons.shield),
              label: const Text('Conseils de prévention'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSymptomDetails(List<String> symptoms) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails des Symptômes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: symptoms.map((symptom) => 
            ListTile(
              leading: const Icon(Icons.medical_information),
              title: Text(symptom),
            ),
          ).toList(),
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

  Widget _buildMessageInput(ChatbotProvider chatbotProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Tapez votre question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              onSubmitted: (text) => _sendMessage(chatbotProvider),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: chatbotProvider.isLoading 
                  ? null 
                  : () => _sendMessage(chatbotProvider),
              icon: chatbotProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatbotProvider chatbotProvider) {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      chatbotProvider.sendMessage(text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Maintenant';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  void _showConversationHistory(ChatbotProvider chatbotProvider) async {
    try {
      final conversations = await ConversationStorageService.getRecentConversations(
        limit: 20,
        userId: 'mobile_user',
      );
      
      if (conversations.isEmpty) {
        _showNoHistoryDialog();
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.history, color: Colors.blue),
              SizedBox(width: 8),
              Text('Historique des conversations'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                final timestamp = DateTime.parse(conv['timestamp']);
                
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.pets,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      conv['userMessage'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conv['botResponse'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.pets, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              conv['animalBreed'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTime(timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _loadConversation(conv);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () async {
                await ConversationStorageService.clearUserConversations('mobile_user');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historique supprimé'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text(
                'Effacer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement de l\'historique: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNoHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.history, color: Colors.grey),
            SizedBox(width: 8),
            Text('Aucun historique'),
          ],
        ),
        content: const Text(
          'Vous n\'avez pas encore de conversations sauvegardées. Commencez à discuter avec l\'assistant vétérinaire pour voir votre historique ici.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _loadConversation(Map<String, dynamic> conversation) {
    // Charger la conversation sélectionnée dans le chat
    final userMessage = conversation['userMessage'];
    final botResponse = conversation['botResponse'];
    
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation chargée: ${userMessage.substring(0, userMessage.length > 30 ? 30 : userMessage.length)}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
