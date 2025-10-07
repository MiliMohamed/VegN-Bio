import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/chatbot_provider.dart';
import '../models/chat.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final Uuid _uuid = const Uuid();

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
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  chatbotProvider.clearChat();
                },
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
                  itemCount: chatbotProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatbotProvider.messages[index];
                    final isUser = message.userId == 'user';
                    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: isUser 
                            ? MainAxisAlignment.end 
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.blue : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
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
          Text(
            'Race: ${chatbotProvider.selectedBreed}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Symptômes: ${chatbotProvider.selectedSymptoms.join(', ')}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              chatbotProvider.getDiagnosis();
            },
            icon: const Icon(Icons.pets),
            label: const Text('Obtenir un diagnostic'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
