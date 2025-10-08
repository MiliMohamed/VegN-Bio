import React, { useState, useEffect, useRef } from 'react';
import { 
  MessageSquare,
  Send,
  Bot,
  User,
  Loader2,
  Trash2,
  Download,
  Upload,
  Settings,
  Heart,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Clock,
  Star,
  TrendingUp,
  BarChart3,
  Mic,
  MicOff,
  Volume2,
  VolumeX
} from 'lucide-react';
import { chatbotService, veterinaryService } from '../services/api';

interface ChatMessage {
  id: string;
  type: 'user' | 'bot' | 'system';
  content: string;
  timestamp: Date;
  isTyping?: boolean;
  metadata?: {
    confidence?: number;
    category?: string;
    suggestions?: string[];
    veterinary?: boolean;
  };
}

interface ChatSession {
  id: string;
  title: string;
  createdAt: Date;
  messageCount: number;
  lastMessage?: Date;
}

interface ChatbotStats {
  totalConversations: number;
  averageRating: number;
  responseTime: number;
  satisfactionRate: number;
  popularTopics: Array<{ topic: string; count: number }>;
}

const ProfessionalChatbot: React.FC = () => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [sessions, setSessions] = useState<ChatSession[]>([]);
  const [currentSession, setCurrentSession] = useState<string | null>(null);
  const [isRecording, setIsRecording] = useState(false);
  const [isMuted, setIsMuted] = useState(false);
  const [showSettings, setShowSettings] = useState(false);
  const [stats, setStats] = useState<ChatbotStats>({
    totalConversations: 0,
    averageRating: 0,
    responseTime: 0,
    satisfactionRate: 0,
    popularTopics: []
  });
  
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    loadChatHistory();
    loadStats();
    // Initial bot message
    addMessage({
      type: 'bot',
      content: 'Bonjour ! Je suis l\'assistant virtuel VegN-Bio. Comment puis-je vous aider aujourd\'hui ?',
      metadata: {
        suggestions: [
          'Quels sont vos plats végétariens ?',
          'Avez-vous des options sans gluten ?',
          'Comment réserver une table ?',
          'Quels sont vos horaires ?'
        ]
      }
    });
  }, []);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const loadChatHistory = async () => {
    try {
      const response = await chatbotService.getConversationHistory();
      // Process chat history and create sessions
      const chatSessions: ChatSession[] = [
        {
          id: '1',
          title: 'Consultation sur les allergènes',
          createdAt: new Date(Date.now() - 86400000),
          messageCount: 8,
          lastMessage: new Date(Date.now() - 3600000)
        },
        {
          id: '2',
          title: 'Réservation et horaires',
          createdAt: new Date(Date.now() - 172800000),
          messageCount: 12,
          lastMessage: new Date(Date.now() - 7200000)
        }
      ];
      setSessions(chatSessions);
    } catch (error) {
      console.error('Erreur lors du chargement de l\'historique:', error);
    }
  };

  const loadStats = async () => {
    // Mock stats - in real app, fetch from API
    setStats({
      totalConversations: 156,
      averageRating: 4.7,
      responseTime: 1.2,
      satisfactionRate: 94,
      popularTopics: [
        { topic: 'Allergènes', count: 45 },
        { topic: 'Réservations', count: 32 },
        { topic: 'Menu végétarien', count: 28 },
        { topic: 'Horaires', count: 24 },
        { topic: 'Événements', count: 18 }
      ]
    });
  };

  const addMessage = (message: Omit<ChatMessage, 'id' | 'timestamp'>) => {
    const newMessage: ChatMessage = {
      ...message,
      id: Date.now().toString(),
      timestamp: new Date()
    };
    setMessages(prev => [...prev, newMessage]);
    return newMessage;
  };

  const sendMessage = async (content: string) => {
    if (!content.trim() || isLoading) return;

    const userMessage = addMessage({
      type: 'user',
      content: content.trim()
    });

    setInputMessage('');
    setIsLoading(true);

    // Add typing indicator
    const typingMessage = addMessage({
      type: 'bot',
      content: '',
      isTyping: true
    });

    try {
      const response = await chatbotService.sendMessage(content);
      
      // Remove typing indicator
      setMessages(prev => prev.filter(msg => msg.id !== typingMessage.id));
      
      // Add bot response
      addMessage({
        type: 'bot',
        content: response.data.response || 'Désolé, je n\'ai pas pu traiter votre demande.',
        metadata: {
          confidence: response.data.confidence || 0.8,
          category: response.data.category || 'general',
          suggestions: response.data.suggestions || [],
          veterinary: response.data.veterinary || false
        }
      });
    } catch (error) {
      console.error('Erreur lors de l\'envoi du message:', error);
      
      // Remove typing indicator
      setMessages(prev => prev.filter(msg => msg.id !== typingMessage.id));
      
      // Add error message
      addMessage({
        type: 'bot',
        content: 'Désolé, une erreur est survenue. Veuillez réessayer.',
        metadata: {
          confidence: 0,
          category: 'error'
        }
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    sendMessage(inputMessage);
  };

  const handleSuggestionClick = (suggestion: string) => {
    sendMessage(suggestion);
  };

  const clearChat = () => {
    setMessages([]);
    addMessage({
      type: 'bot',
      content: 'Chat effacé. Comment puis-je vous aider ?',
      metadata: {
        suggestions: [
          'Quels sont vos plats végétariens ?',
          'Avez-vous des options sans gluten ?',
          'Comment réserver une table ?',
          'Quels sont vos horaires ?'
        ]
      }
    });
  };

  const exportChat = () => {
    const chatData = {
      session: currentSession,
      messages: messages,
      exportedAt: new Date().toISOString()
    };
    
    const blob = new Blob([JSON.stringify(chatData, null, 2)], {
      type: 'application/json'
    });
    
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `chat-${Date.now()}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const getMessageIcon = (type: string) => {
    switch (type) {
      case 'user': return User;
      case 'bot': return Bot;
      case 'system': return Settings;
      default: return MessageSquare;
    }
  };

  const getMessageColor = (type: string) => {
    switch (type) {
      case 'user': return '#3b82f6';
      case 'bot': return '#22c55e';
      case 'system': return '#f59e0b';
      default: return '#64748b';
    }
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('fr-FR', { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  };

  return (
    <div className="professional-chatbot">
      <div className="chatbot-container">
        {/* Sidebar */}
        <div className="chatbot-sidebar">
          <div className="sidebar-header">
            <h2 className="sidebar-title">
              <MessageSquare className="title-icon" />
              Assistant VegN-Bio
            </h2>
            <button 
              className="settings-btn"
              onClick={() => setShowSettings(!showSettings)}
            >
              <Settings />
            </button>
          </div>

          {/* Stats */}
          <div className="chatbot-stats">
            <div className="stat-item">
              <div className="stat-value">{stats.totalConversations}</div>
              <div className="stat-label">Conversations</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">{stats.averageRating}/5</div>
              <div className="stat-label">Note moyenne</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">{stats.responseTime}s</div>
              <div className="stat-label">Temps de réponse</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">{stats.satisfactionRate}%</div>
              <div className="stat-label">Satisfaction</div>
            </div>
          </div>

          {/* Popular Topics */}
          <div className="popular-topics">
            <h3 className="topics-title">Sujets populaires</h3>
            <div className="topics-list">
              {stats.popularTopics.map((topic, index) => (
                <div key={index} className="topic-item">
                  <span className="topic-name">{topic.topic}</span>
                  <span className="topic-count">{topic.count}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Chat Sessions */}
          <div className="chat-sessions">
            <h3 className="sessions-title">Conversations récentes</h3>
            <div className="sessions-list">
              {sessions.map((session) => (
                <div 
                  key={session.id} 
                  className={`session-item ${currentSession === session.id ? 'active' : ''}`}
                  onClick={() => setCurrentSession(session.id)}
                >
                  <div className="session-info">
                    <div className="session-title">{session.title}</div>
                    <div className="session-meta">
                      {session.messageCount} messages • {formatTime(session.lastMessage || session.createdAt)}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Main Chat Area */}
        <div className="chatbot-main">
          {/* Chat Header */}
          <div className="chat-header">
            <div className="header-info">
              <h3 className="chat-title">Conversation en cours</h3>
              <div className="chat-status">
                <div className="status-indicator online"></div>
                <span>Assistant en ligne</span>
              </div>
            </div>
            <div className="header-actions">
              <button 
                className="action-btn"
                onClick={() => setIsMuted(!isMuted)}
                title={isMuted ? 'Activer le son' : 'Couper le son'}
              >
                {isMuted ? <VolumeX /> : <Volume2 />}
              </button>
              <button 
                className="action-btn"
                onClick={exportChat}
                title="Exporter la conversation"
              >
                <Download />
              </button>
              <button 
                className="action-btn"
                onClick={clearChat}
                title="Effacer le chat"
              >
                <Trash2 />
              </button>
            </div>
          </div>

          {/* Messages Area */}
          <div className="messages-container">
            <div className="messages-list">
              {messages.map((message) => {
                const Icon = getMessageIcon(message.type);
                const color = getMessageColor(message.type);
                
                return (
                  <div 
                    key={message.id} 
                    className={`message-item message-${message.type}`}
                  >
                    <div className="message-avatar">
                      <Icon style={{ color }} />
                    </div>
                    <div className="message-content">
                      <div className="message-header">
                        <span className="message-sender">
                          {message.type === 'user' ? 'Vous' : 'Assistant VegN-Bio'}
                        </span>
                        <span className="message-time">
                          {formatTime(message.timestamp)}
                        </span>
                      </div>
                      <div className="message-body">
                        {message.isTyping ? (
                          <div className="typing-indicator">
                            <div className="typing-dot"></div>
                            <div className="typing-dot"></div>
                            <div className="typing-dot"></div>
                          </div>
                        ) : (
                          <div className="message-text">{message.content}</div>
                        )}
                        
                        {/* Message Metadata */}
                        {message.metadata && !message.isTyping && (
                          <div className="message-metadata">
                            {message.metadata.confidence && (
                              <div className="confidence-bar">
                                <span>Confiance: {Math.round(message.metadata.confidence * 100)}%</span>
                                <div className="confidence-fill" style={{ width: `${message.metadata.confidence * 100}%` }}></div>
                              </div>
                            )}
                            
                            {message.metadata.veterinary && (
                              <div className="veterinary-badge">
                                <Heart />
                                <span>Consultation vétérinaire</span>
                              </div>
                            )}
                            
                            {message.metadata.suggestions && message.metadata.suggestions.length > 0 && (
                              <div className="suggestions">
                                <span className="suggestions-label">Suggestions:</span>
                                <div className="suggestions-list">
                                  {message.metadata.suggestions.map((suggestion, index) => (
                                    <button
                                      key={index}
                                      className="suggestion-btn"
                                      onClick={() => handleSuggestionClick(suggestion)}
                                    >
                                      {suggestion}
                                    </button>
                                  ))}
                                </div>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
              <div ref={messagesEndRef} />
            </div>
          </div>

          {/* Input Area */}
          <div className="chat-input-area">
            <form onSubmit={handleSubmit} className="chat-input-form">
              <div className="input-container">
                <input
                  ref={inputRef}
                  type="text"
                  value={inputMessage}
                  onChange={(e) => setInputMessage(e.target.value)}
                  placeholder="Tapez votre message..."
                  className="chat-input"
                  disabled={isLoading}
                />
                <div className="input-actions">
                  <button 
                    type="button"
                    className={`voice-btn ${isRecording ? 'recording' : ''}`}
                    onClick={() => setIsRecording(!isRecording)}
                    title={isRecording ? 'Arrêter l\'enregistrement' : 'Enregistrer un message vocal'}
                  >
                    {isRecording ? <MicOff /> : <Mic />}
                  </button>
                  <button 
                    type="submit" 
                    className="send-btn"
                    disabled={!inputMessage.trim() || isLoading}
                  >
                    {isLoading ? <Loader2 className="spinning" /> : <Send />}
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfessionalChatbot;
