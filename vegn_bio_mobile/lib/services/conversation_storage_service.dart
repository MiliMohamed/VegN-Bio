import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat.dart';

class ConversationStorageService {
  static const String _conversationsKey = 'chatbot_conversations';
  static const int _maxConversations = 100; // Limite de conversations stockées

  // Sauvegarder une conversation
  static Future<void> saveConversation({
    required String userId,
    required String userMessage,
    required String botResponse,
    String? animalBreed,
    List<String>? symptoms,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversations = await getConversations(userId);
      
      final conversation = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': userId,
        'userMessage': userMessage,
        'botResponse': botResponse,
        'animalBreed': animalBreed ?? 'Non spécifié',
        'symptoms': symptoms ?? [],
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      conversations.add(conversation);
      
      // Garder seulement les X dernières conversations
      if (conversations.length > _maxConversations) {
        conversations.removeRange(0, conversations.length - _maxConversations);
      }
      
      await prefs.setString(_conversationsKey, jsonEncode(conversations));
    } catch (e) {
      print('Erreur lors de la sauvegarde de la conversation: $e');
    }
  }

  // Récupérer les conversations d'un utilisateur
  static Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = prefs.getString(_conversationsKey);
      
      if (conversationsJson == null) {
        return [];
      }
      
      final List<dynamic> conversationsList = jsonDecode(conversationsJson);
      final conversations = conversationsList.cast<Map<String, dynamic>>();
      
      // Filtrer par utilisateur si nécessaire
      if (userId.isNotEmpty) {
        return conversations.where((conv) => conv['userId'] == userId).toList();
      }
      
      return conversations;
    } catch (e) {
      print('Erreur lors du chargement des conversations: $e');
      return [];
    }
  }

  // Récupérer les conversations récentes
  static Future<List<Map<String, dynamic>>> getRecentConversations({
    int limit = 10,
    String? userId,
  }) async {
    try {
      final conversations = await getConversations(userId ?? '');
      
      // Trier par timestamp décroissant et limiter
      conversations.sort((a, b) => 
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp']))
      );
      
      return conversations.take(limit).toList();
    } catch (e) {
      print('Erreur lors du chargement des conversations récentes: $e');
      return [];
    }
  }

  // Supprimer toutes les conversations
  static Future<void> clearAllConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_conversationsKey);
    } catch (e) {
      print('Erreur lors de la suppression des conversations: $e');
    }
  }

  // Supprimer les conversations d'un utilisateur spécifique
  static Future<void> clearUserConversations(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = prefs.getString(_conversationsKey);
      
      if (conversationsJson != null) {
        final List<dynamic> conversationsList = jsonDecode(conversationsJson);
        final conversations = conversationsList.cast<Map<String, dynamic>>();
        
        // Filtrer pour garder seulement les conversations d'autres utilisateurs
        final filteredConversations = conversations
            .where((conv) => conv['userId'] != userId)
            .toList();
        
        await prefs.setString(_conversationsKey, jsonEncode(filteredConversations));
      }
    } catch (e) {
      print('Erreur lors de la suppression des conversations utilisateur: $e');
    }
  }

  // Obtenir les statistiques des conversations
  static Future<Map<String, dynamic>> getConversationStats() async {
    try {
      final conversations = await getConversations('');
      
      final stats = {
        'totalConversations': conversations.length,
        'uniqueUsers': conversations.map((c) => c['userId']).toSet().length,
        'mostCommonBreed': _getMostCommonBreed(conversations),
        'recentActivity': _getRecentActivity(conversations),
      };
      
      return stats;
    } catch (e) {
      print('Erreur lors du calcul des statistiques: $e');
      return {};
    }
  }

  static String _getMostCommonBreed(List<Map<String, dynamic>> conversations) {
    if (conversations.isEmpty) return 'Aucune';
    
    final breedCounts = <String, int>{};
    for (final conv in conversations) {
      final breed = conv['animalBreed'] ?? 'Non spécifié';
      breedCounts[breed] = (breedCounts[breed] ?? 0) + 1;
    }
    
    return breedCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  static int _getRecentActivity(List<Map<String, dynamic>> conversations) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return conversations.where((conv) {
      final timestamp = DateTime.parse(conv['timestamp']);
      return timestamp.isAfter(yesterday);
    }).length;
  }
}
