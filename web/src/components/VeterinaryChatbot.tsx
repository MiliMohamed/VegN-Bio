import React, { useState, useEffect, useRef } from 'react';
import { motion } from 'framer-motion';
import { 
  Heart, 
  Send, 
  Bot, 
  User,
  Trash2,
  RotateCcw,
  Stethoscope,
  AlertTriangle,
  CheckCircle,
  Info,
  Loader2,
  Download,
  Upload,
  Settings,
  Mic,
  MicOff,
  Volume2,
  VolumeX,
  Calendar,
  TrendingUp,
  BarChart3,
  PieChart,
  Award,
  Activity,
  Zap,
  BookOpen,
  Target,
  Users,
  Brain
} from 'lucide-react';
import { veterinaryService, chatbotService } from '../services/api';
import { 
  VeterinaryMessage, 
  AnimalBreed, 
  Symptom, 
  VeterinaryDiagnosis, 
  ChatbotStats,
  DiagnosisRequest,
  DiagnosisResponse
} from '../types/veterinary';
import { mockBreeds, mockSymptoms, mockDiagnosisResponses, mockStats } from '../data/veterinaryMockData';

const VeterinaryChatbot: React.FC = () => {
  const [messages, setMessages] = useState<VeterinaryMessage[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [selectedBreed, setSelectedBreed] = useState<string | null>(null);
  const [selectedSymptoms, setSelectedSymptoms] = useState<string[]>([]);
  const [availableBreeds, setAvailableBreeds] = useState<AnimalBreed[]>([]);
  const [availableSymptoms, setAvailableSymptoms] = useState<Symptom[]>([]);
  const [currentStep, setCurrentStep] = useState<'breed' | 'symptoms' | 'chat'>('breed');
  const [isRecording, setIsRecording] = useState(false);
  const [isMuted, setIsMuted] = useState(false);
  const [showStats, setShowStats] = useState(false);
  const [stats, setStats] = useState<ChatbotStats>({
    totalConsultations: 0,
    averageConfidence: 0,
    responseTime: 0,
    satisfactionRate: 0,
    supportedBreeds: 0,
    knownSymptoms: 0,
    popularBreeds: [],
    commonSymptoms: [],
    emergencyCases: 0,
    successfulDiagnoses: 0,
    learningProgress: 0
  });
  
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    initializeChatbot();
    loadStats();
  }, []);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const initializeChatbot = async () => {
    try {
      // Utiliser les données mock pour le développement
      setAvailableBreeds(mockBreeds);
      setAvailableSymptoms(mockSymptoms);
      setStats(mockStats);

      // Message de bienvenue
      addMessage({
        type: 'bot',
        content: '🐾 Bonjour ! Je suis votre assistant vétérinaire virtuel. Je peux vous aider à identifier les problèmes de santé de votre animal. Commencez par me dire la race de votre animal.',
        metadata: {
          suggestions: [
            'Mon chien a des symptômes',
            'Mon chat semble malade',
            'Mon lapin ne mange plus',
            'Mon hamster est léthargique'
          ]
        }
      });
    } catch (error) {
      console.error('Erreur lors de l\'initialisation:', error);
      addMessage({
        type: 'bot',
        content: 'Désolé, je rencontre un problème technique. Veuillez réessayer plus tard.',
        metadata: { category: 'error' }
      });
    }
  };

  const loadStats = async () => {
    try {
      const response = await chatbotService.getLearningStatistics();
      setStats(response.data || stats);
    } catch (error) {
      console.error('Erreur lors du chargement des statistiques:', error);
    }
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const addMessage = (message: Omit<VeterinaryMessage, 'id' | 'timestamp'>) => {
    const newMessage: VeterinaryMessage = {
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
      let response;
      
      if (selectedBreed && selectedSymptoms.length > 0) {
        // Diagnostic vétérinaire
        response = await veterinaryService.createDiagnosis({
          animalBreed: selectedBreed,
          symptoms: selectedSymptoms,
          userMessage: content,
          timestamp: new Date().toISOString()
        });
        
        // Remove typing indicator
        setMessages(prev => prev.filter(msg => msg.id !== typingMessage.id));
        
        // Add diagnosis response
        addMessage({
          type: 'diagnosis',
          content: response.data.diagnosis || 'Diagnostic en cours...',
          metadata: {
            confidence: response.data.confidence || 0.8,
            category: 'diagnosis',
            animalBreed: selectedBreed,
            symptoms: selectedSymptoms,
            isEmergency: response.data.isEmergency || false,
            diagnosis: response.data.diagnosis,
            recommendation: response.data.recommendation,
            suggestions: [
              'Obtenir plus de détails',
              'Conseils de prévention',
              'Quand consulter un vétérinaire',
              'Nouveau diagnostic'
            ]
          }
        });
      } else {
        // Chat général
        response = await chatbotService.sendMessage(content);
        
        // Remove typing indicator
        setMessages(prev => prev.filter(msg => msg.id !== typingMessage.id));
        
        // Add bot response
        addMessage({
          type: 'bot',
          content: response.data.response || 'Je n\'ai pas pu traiter votre demande.',
          metadata: {
            confidence: response.data.confidence || 0.8,
            category: response.data.category || 'general',
            suggestions: response.data.suggestions || []
          }
        });
      }
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

  const handleBreedSelection = (breed: string) => {
    setSelectedBreed(breed);
    setSelectedSymptoms([]);
    setCurrentStep('symptoms');
    
    addMessage({
      type: 'bot',
      content: `Parfait ! Vous avez sélectionné ${breed}. Maintenant, veuillez sélectionner les symptômes que vous observez chez votre animal.`,
      metadata: {
        category: 'breed_selection',
        animalBreed: breed,
        suggestions: ['Continuer avec les symptômes']
      }
    });
  };

  const handleSymptomToggle = (symptom: string) => {
    if (selectedSymptoms.includes(symptom)) {
      setSelectedSymptoms(prev => prev.filter(s => s !== symptom));
    } else {
      setSelectedSymptoms(prev => [...prev, symptom]);
    }
  };

  const handleDiagnosisRequest = async () => {
    if (!selectedBreed || selectedSymptoms.length === 0) {
      addMessage({
        type: 'bot',
        content: 'Veuillez sélectionner une race et au moins un symptôme avant de demander un diagnostic.',
        metadata: { category: 'error' }
      });
      return;
    }

    setIsLoading(true);
    
    try {
      // Simuler un délai de traitement
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Utiliser les données mock pour le diagnostic
      const mockResponse = mockDiagnosisResponses[Math.floor(Math.random() * mockDiagnosisResponses.length)];
      
      // Vérifier si c'est une urgence basée sur les symptômes
      const emergencySymptoms = ['Difficultés respiratoires', 'Convulsions', 'Saignement'];
      const isEmergency = selectedSymptoms.some(symptom => 
        emergencySymptoms.some(emergency => symptom.includes(emergency))
      );

      const diagnosisResponse: DiagnosisResponse = {
        ...mockResponse,
        isEmergency: isEmergency || mockResponse.isEmergency
      };

      addMessage({
        type: 'diagnosis',
        content: `🔍 **Diagnostic pour ${selectedBreed}**\n\n**Symptômes observés:**\n${selectedSymptoms.map(s => `• ${s}`).join('\n')}\n\n**Diagnostic probable:**\n${diagnosisResponse.diagnosis}\n\n**Recommandations:**\n${diagnosisResponse.recommendation}\n\n**Niveau de confiance:** ${Math.round(diagnosisResponse.confidence * 100)}%\n\n**Sévérité:** ${diagnosisResponse.severity === 'critical' ? '🚨 CRITIQUE' : diagnosisResponse.severity === 'high' ? '⚠️ ÉLEVÉE' : diagnosisResponse.severity === 'medium' ? '⚡ MODÉRÉE' : '✅ FAIBLE'}`,
        metadata: {
          confidence: diagnosisResponse.confidence,
          category: 'diagnosis',
          animalBreed: selectedBreed,
          symptoms: selectedSymptoms,
          isEmergency: diagnosisResponse.isEmergency,
          diagnosis: diagnosisResponse.diagnosis,
          recommendation: diagnosisResponse.recommendation,
          severity: diagnosisResponse.severity,
          followUpRequired: diagnosisResponse.followUpRequired,
          suggestions: [
            'Obtenir plus de détails',
            'Conseils de prévention',
            'Quand consulter un vétérinaire',
            'Nouveau diagnostic'
          ]
        }
      });

      setCurrentStep('chat');
    } catch (error) {
      console.error('Erreur lors du diagnostic:', error);
      addMessage({
        type: 'bot',
        content: 'Désolé, je n\'ai pas pu établir un diagnostic. Veuillez consulter un vétérinaire.',
        metadata: { category: 'error' }
      });
    } finally {
      setIsLoading(false);
    }
  };

  const clearChat = () => {
    setMessages([]);
    setSelectedBreed(null);
    setSelectedSymptoms([]);
    setCurrentStep('breed');
    addMessage({
      type: 'bot',
      content: 'Chat effacé. Comment puis-je vous aider avec votre animal ?',
      metadata: {
        suggestions: [
          'Mon chien a des symptômes',
          'Mon chat semble malade',
          'Mon lapin ne mange plus',
          'Mon hamster est léthargique'
        ]
      }
    });
  };

  const exportChat = () => {
    const chatData = {
      messages: messages,
      selectedBreed: selectedBreed,
      selectedSymptoms: selectedSymptoms,
      exportedAt: new Date().toISOString()
    };
    
    const blob = new Blob([JSON.stringify(chatData, null, 2)], {
      type: 'application/json'
    });
    
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `veterinary-chat-${Date.now()}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const getMessageIcon = (type: string) => {
    switch (type) {
      case 'user': return User;
      case 'bot': return Bot;
      case 'diagnosis': return Stethoscope;
      case 'recommendation': return Heart;
      case 'system': return Settings;
      default: return Bot;
    }
  };

  const getMessageColor = (type: string) => {
    switch (type) {
      case 'user': return '#3b82f6';
      case 'bot': return '#22c55e';
      case 'diagnosis': return '#f59e0b';
      case 'recommendation': return '#8b5cf6';
      case 'system': return '#64748b';
      default: return '#64748b';
    }
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('fr-FR', { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  };

  const getSymptomSeverityColor = (severity: string) => {
    switch (severity) {
      case 'emergency': return '#ef4444';
      case 'high': return '#f97316';
      case 'medium': return '#eab308';
      case 'low': return '#22c55e';
      default: return '#64748b';
    }
  };

  return (
    <div className="veterinary-chatbot">
      <div className="chatbot-container">
        {/* Header */}
        <div className="chatbot-header">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="page-title">
              <Stethoscope className="title-icon" />
              Assistant Vétérinaire IA
            </h1>
            <p className="page-subtitle">
              Diagnostic intelligent pour vos animaux de compagnie
            </p>
          </motion.div>
        </div>

        {/* Stats Toggle */}
        <div className="stats-toggle">
          <button 
            className={`stats-btn ${showStats ? 'active' : ''}`}
            onClick={() => setShowStats(!showStats)}
          >
            <BarChart3 className="w-4 h-4" />
            Statistiques
          </button>
        </div>

        {/* Stats Panel */}
        {showStats && (
          <motion.div 
            className="stats-panel"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
          >
            <div className="stats-grid">
              <div className="stat-item">
                <Brain className="stat-icon" />
                <div className="stat-content">
                  <div className="stat-value">{stats.totalConsultations}</div>
                  <div className="stat-label">Consultations</div>
                </div>
              </div>
              <div className="stat-item">
                <Target className="stat-icon" />
                <div className="stat-content">
                  <div className="stat-value">{(stats.averageConfidence * 100).toFixed(1)}%</div>
                  <div className="stat-label">Confiance</div>
                </div>
              </div>
              <div className="stat-item">
                <Users className="stat-icon" />
                <div className="stat-content">
                  <div className="stat-value">{stats.supportedBreeds}</div>
                  <div className="stat-label">Races</div>
                </div>
              </div>
              <div className="stat-item">
                <Activity className="stat-icon" />
                <div className="stat-content">
                  <div className="stat-value">{stats.knownSymptoms}</div>
                  <div className="stat-label">Symptômes</div>
                </div>
              </div>
            </div>
          </motion.div>
        )}

        {/* Main Chat Area */}
        <div className="chatbot-main">
          {/* Breed Selection */}
          {currentStep === 'breed' && (
            <motion.div 
              className="breed-selection"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <h3 className="selection-title">Sélectionnez la race de votre animal :</h3>
              <div className="breeds-grid">
                {availableBreeds.map((breed) => (
                  <motion.button
                    key={breed.id}
                    className="breed-card"
                    onClick={() => handleBreedSelection(breed.name)}
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                  >
                    <div className="breed-icon">🐾</div>
                    <div className="breed-name">{breed.name}</div>
                    <div className="breed-category">{breed.category}</div>
                  </motion.button>
                ))}
              </div>
            </motion.div>
          )}

          {/* Symptom Selection */}
          {currentStep === 'symptoms' && (
            <motion.div 
              className="symptom-selection"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <h3 className="selection-title">Sélectionnez les symptômes observés :</h3>
              <div className="symptoms-grid">
                {availableSymptoms.map((symptom) => (
                  <motion.button
                    key={symptom.id}
                    className={`symptom-card ${selectedSymptoms.includes(symptom.name) ? 'selected' : ''}`}
                    onClick={() => handleSymptomToggle(symptom.name)}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="symptom-severity" style={{ backgroundColor: getSymptomSeverityColor(symptom.severity) }}>
                      {symptom.severity === 'emergency' ? '🚨' : 
                       symptom.severity === 'high' ? '⚠️' : 
                       symptom.severity === 'medium' ? '⚡' : 'ℹ️'}
                    </div>
                    <div className="symptom-name">{symptom.name}</div>
                    <div className="symptom-description">{symptom.description}</div>
                  </motion.button>
                ))}
              </div>
              
              {selectedSymptoms.length > 0 && (
                <motion.div 
                  className="diagnosis-actions"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6 }}
                >
                  <button 
                    className="diagnosis-btn"
                    onClick={handleDiagnosisRequest}
                    disabled={isLoading}
                  >
                    {isLoading ? <Loader2 className="spinning" /> : <Stethoscope />}
                    Obtenir un diagnostic
                  </button>
                </motion.div>
              )}
            </motion.div>
          )}

          {/* Chat Messages */}
          <div className="messages-container">
            <div className="messages-list">
              {messages.map((message) => {
                const Icon = getMessageIcon(message.type);
                const color = getMessageColor(message.type);
                
                return (
                  <motion.div 
                    key={message.id} 
                    className={`message-item message-${message.type}`}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.4 }}
                  >
                    <div className="message-avatar">
                      <Icon style={{ color }} />
                    </div>
                    <div className="message-content">
                      <div className="message-header">
                        <span className="message-sender">
                          {message.type === 'user' ? 'Vous' : 
                           message.type === 'diagnosis' ? 'Diagnostic IA' :
                           message.type === 'recommendation' ? 'Recommandations' :
                           'Assistant Vétérinaire'}
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
                            
                            {message.metadata.isEmergency && (
                              <div className="emergency-badge">
                                <AlertTriangle />
                                <span>URGENCE VÉTÉRINAIRE</span>
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
                  </motion.div>
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

          {/* Action Buttons */}
          <div className="action-buttons">
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
      </div>
    </div>
  );
};

export default VeterinaryChatbot;
