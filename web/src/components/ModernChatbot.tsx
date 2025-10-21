import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  MessageCircle, 
  Send, 
  Bot, 
  User,
  Trash2,
  RotateCcw
} from 'lucide-react';
import { chatbotService } from '../services/api';

interface Message {
  id: string;
  text: string;
  isUser: boolean;
  timestamp: Date;
}

const ModernChatbot: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '1',
      text: 'Bonjour ! Je suis l\'assistant VegN Bio. Comment puis-je vous aider aujourd\'hui ?',
      isUser: false,
      timestamp: new Date()
    }
  ]);
  const [inputMessage, setInputMessage] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSendMessage = async () => {
    if (!inputMessage.trim()) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      text: inputMessage,
      isUser: true,
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setLoading(true);

    try {
      const response = await chatbotService.sendMessage(inputMessage);
      const botMessage: Message = {
        id: (Date.now() + 1).toString(),
        text: response.data.message || 'Je n\'ai pas pu traiter votre demande.',
        isUser: false,
        timestamp: new Date()
      };
      
      setTimeout(() => {
        setMessages(prev => [...prev, botMessage]);
        setLoading(false);
      }, 1000);
    } catch (error) {
      const errorMessage: Message = {
        id: (Date.now() + 1).toString(),
        text: 'Désolé, je rencontre un problème technique. Veuillez réessayer plus tard.',
        isUser: false,
        timestamp: new Date()
      };
      
      setTimeout(() => {
        setMessages(prev => [...prev, errorMessage]);
        setLoading(false);
      }, 1000);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const clearHistory = async () => {
    try {
      await chatbotService.clearHistory();
      setMessages([
        {
          id: '1',
          text: 'Bonjour ! Je suis l\'assistant VegN Bio. Comment puis-je vous aider aujourd\'hui ?',
          isUser: false,
          timestamp: new Date()
        }
      ]);
    } catch (error) {
      console.error('Erreur lors de la suppression de l\'historique:', error);
    }
  };

  const quickQuestions = [
    'Quels sont vos horaires ?',
    'Comment réserver une salle ?',
    'Quels sont vos plats végétariens ?',
    'Où sont situés vos restaurants ?'
  ];

  const handleQuickQuestion = (question: string) => {
    setInputMessage(question);
  };

  return (
    <div className="modern-chatbot">
      <div className="chatbot-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Assistant IA VegN Bio</h1>
          <p className="page-subtitle">
            Posez vos questions sur nos restaurants, services et produits
          </p>
        </motion.div>
      </div>

      <div className="chatbot-container">
        <motion.div
          className="chatbot-card"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="chat-header">
            <div className="chat-title">
              <Bot className="w-6 h-6" />
              <span>Assistant VegN Bio</span>
            </div>
            <div className="chat-actions">
              <button 
                className="action-btn"
                onClick={clearHistory}
                title="Effacer l'historique"
              >
                <Trash2 className="w-4 h-4" />
              </button>
              <button 
                className="action-btn"
                onClick={() => window.location.reload()}
                title="Recharger"
              >
                <RotateCcw className="w-4 h-4" />
              </button>
            </div>
          </div>

          <div className="chat-messages">
            {messages.map((message, index) => (
              <motion.div
                key={message.id}
                className={`message ${message.isUser ? 'user-message' : 'bot-message'}`}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4, delay: index * 0.1 }}
              >
                <div className="message-avatar">
                  {message.isUser ? (
                    <User className="w-5 h-5" />
                  ) : (
                    <Bot className="w-5 h-5" />
                  )}
                </div>
                <div className="message-content">
                  <div className="message-text">{message.text}</div>
                  <div className="message-time">
                    {message.timestamp.toLocaleTimeString('fr-FR', {
                      hour: '2-digit',
                      minute: '2-digit'
                    })}
                  </div>
                </div>
              </motion.div>
            ))}
            
            {loading && (
              <motion.div
                className="message bot-message"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4 }}
              >
                <div className="message-avatar">
                  <Bot className="w-5 h-5" />
                </div>
                <div className="message-content">
                  <div className="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                </div>
              </motion.div>
            )}
          </div>

          <div className="quick-questions">
            <h4 className="quick-title">Questions fréquentes :</h4>
            <div className="quick-buttons">
              {quickQuestions.map((question, index) => (
                <motion.button
                  key={index}
                  className="quick-btn"
                  onClick={() => handleQuickQuestion(question)}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ duration: 0.4, delay: 0.3 + index * 0.1 }}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  {question}
                </motion.button>
              ))}
            </div>
          </div>

          <div className="chat-input">
            <div className="input-container">
              <textarea
                value={inputMessage}
                onChange={(e) => setInputMessage(e.target.value)}
                onKeyPress={handleKeyPress}
                placeholder="Tapez votre message..."
                className="message-input"
                rows={1}
                disabled={loading}
              />
              <button
                onClick={handleSendMessage}
                disabled={!inputMessage.trim() || loading}
                className="send-btn"
              >
                <Send className="w-5 h-5" />
              </button>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernChatbot;
