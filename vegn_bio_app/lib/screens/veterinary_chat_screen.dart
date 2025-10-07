import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinary_provider.dart';
import '../widgets/chat_bubble.dart';
import '../models/veterinary_consultation.dart';

class VeterinaryChatScreen extends StatefulWidget {
  const VeterinaryChatScreen({super.key});

  @override
  State<VeterinaryChatScreen> createState() => _VeterinaryChatScreenState();
}

class _VeterinaryChatScreenState extends State<VeterinaryChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAnimalForm = false;
  bool _showSymptomsSelector = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    
    // Initialiser le service vétérinaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VeterinaryProvider>().initializeService();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Scroll vers le bas automatique
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Vétérinaire'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<VeterinaryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _buildChatList(provider.chatHistory);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildChatList(List<dynamic> chatHistory) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: chatHistory.length,
      itemBuilder: (context, index) {
        final message = chatHistory[index];
        return ChatBubble(
          message: message,
          onTap: () => _handleMessageTap(message),
        );
      },
    );
  }

  Widget _buildInputArea() {
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
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Tapez votre message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.blue[700]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Consumer<VeterinaryProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton.small(
                  onPressed: provider.isDiagnosing ? null : _sendMessage,
                  backgroundColor: Colors.blue[700],
                  child: provider.isDiagnosing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showAnimalForm || _showSymptomsSelector) ...[
          FloatingActionButton.small(
            onPressed: () => setState(() {
              _showAnimalForm = !_showAnimalForm;
              _showSymptomsSelector = false;
            }),
            backgroundColor: Colors.green[600],
            heroTag: "animal_form",
            child: Icon(
              _showAnimalForm ? Icons.close : Icons.pets,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: () => setState(() {
              _showSymptomsSelector = !_showSymptomsSelector;
              _showAnimalForm = false;
            }),
            backgroundColor: Colors.orange[600],
            heroTag: "symptoms_selector",
            child: Icon(
              _showSymptomsSelector ? Icons.close : Icons.medical_services,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
        FloatingActionButton(
          onPressed: _toggleQuickActions,
          backgroundColor: Colors.blue[700],
          child: Icon(
            _showAnimalForm || _showSymptomsSelector ? Icons.close : Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _toggleQuickActions() {
    setState(() {
      if (_showAnimalForm || _showSymptomsSelector) {
        _showAnimalForm = false;
        _showSymptomsSelector = false;
      } else {
        _showAnimalForm = true;
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _scrollToBottom();

    // Ajouter le message utilisateur et traiter avec le provider
    final userMessage = ChatMessage(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    context.read<VeterinaryProvider>().addChatMessage(userMessage);
    
    // Traiter le message et obtenir une réponse
    _processUserMessage(message);
  }

  void _processUserMessage(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Logique simple de traitement des messages
    String response = '';
    
    if (lowerMessage.contains('salut') || lowerMessage.contains('bonjour') || lowerMessage.contains('hello')) {
      response = 'Bonjour ! Je suis votre assistant vétérinaire. Comment puis-je vous aider avec votre animal aujourd\'hui ?';
    } else if (lowerMessage.contains('espèce') || lowerMessage.contains('race')) {
      response = 'Parfait ! Pour commencer, pouvez-vous me dire quelle est l\'espèce de votre animal ? (Chien, Chat, etc.)';
    } else if (lowerMessage.contains('symptôme') || lowerMessage.contains('malade')) {
      response = 'Je comprends que votre animal présente des symptômes. Pouvez-vous me décrire ce que vous observez ?';
    } else if (lowerMessage.contains('urgence') || lowerMessage.contains('urgent')) {
      response = '⚠️ En cas d\'urgence vétérinaire, contactez immédiatement votre vétérinaire ou le service d\'urgence vétérinaire le plus proche.';
    } else {
      response = 'Je comprends votre préoccupation. Pour vous aider au mieux, pouvez-vous me donner plus de détails sur votre animal et ses symptômes ?';
    }
    
    // Ajouter la réponse du bot
    final botMessage = ChatMessage(
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    // Délai pour simuler une réponse en temps réel
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.read<VeterinaryProvider>().addChatMessage(botMessage);
        _scrollToBottom();
      }
    });
  }

  void addChatMessage(ChatMessage message) {
    context.read<VeterinaryProvider>().addChatMessage(message);
  }

  void _handleMessageTap(dynamic message) {
    // Gérer les interactions avec les messages
    if (message.content.contains('espèce')) {
      setState(() {
        _showAnimalForm = true;
        _showSymptomsSelector = false;
      });
    } else if (message.content.contains('symptômes')) {
      setState(() {
        _showSymptomsSelector = true;
        _showAnimalForm = false;
      });
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer la conversation'),
        content: const Text('Êtes-vous sûr de vouloir effacer toute la conversation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<VeterinaryProvider>().clearChat();
            },
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

}
