// Interfaces pour le système vétérinaire

export interface AnimalBreed {
  id: string;
  name: string;
  category: 'chien' | 'chat' | 'lapin' | 'hamster' | 'oiseau' | 'autre';
  description?: string;
  commonSymptoms: string[];
  averageLifespan?: number;
  size?: 'petit' | 'moyen' | 'grand';
  temperament?: string[];
}

export interface Symptom {
  id: string;
  name: string;
  severity: 'low' | 'medium' | 'high' | 'emergency';
  description: string;
  category: 'digestif' | 'respiratoire' | 'neurologique' | 'dermatologique' | 'comportemental' | 'autre';
  commonBreeds?: string[];
  emergencyActions?: string[];
  relatedSymptoms?: string[];
}

export interface VeterinaryDiagnosis {
  id: string;
  animalBreed: string;
  symptoms: string[];
  diagnosis: string;
  recommendation: string;
  confidence: number;
  isEmergency: boolean;
  severity: 'low' | 'medium' | 'high' | 'critical';
  createdAt: Date;
  userId?: string;
  metadata?: {
    alternativeDiagnoses?: string[];
    riskFactors?: string[];
    preventionTips?: string[];
    followUpRequired?: boolean;
    followUpTimeframe?: string;
  };
}

export interface VeterinaryConsultation {
  id: string;
  animalBreed: string;
  symptoms: string[];
  userMessage: string;
  botResponse: string;
  diagnosis?: VeterinaryDiagnosis;
  feedback?: ConsultationFeedback;
  createdAt: Date;
  userId?: string;
  sessionId?: string;
}

export interface ConsultationFeedback {
  id: string;
  consultationId: number;
  rating: number; // 1-5
  accuracy: number; // 1-5
  helpfulness: number; // 1-5
  comments?: string;
  wasCorrect?: boolean;
  actualDiagnosis?: string;
  createdAt: Date;
}

export interface VeterinaryRecommendation {
  id: string;
  breed: string;
  category: 'preventive' | 'feeding' | 'behavioral' | 'emergency' | 'general';
  title: string;
  description: string;
  priority: 'low' | 'medium' | 'high';
  applicableSymptoms?: string[];
  applicableBreeds?: string[];
}

export interface EmergencyProtocol {
  id: string;
  symptom: string;
  breed?: string;
  immediateActions: string[];
  warningSigns: string[];
  timeCritical: boolean;
  maxWaitTime?: number; // en minutes
  contactInfo?: {
    emergencyVet?: string;
    poisonControl?: string;
    localVet?: string;
  };
}

export interface LearningData {
  totalConsultations: number;
  successfulDiagnoses: number;
  averageConfidence: number;
  mostCommonBreeds: Array<{ breed: string; count: number }>;
  mostCommonSymptoms: Array<{ symptom: string; count: number }>;
  accuracyByBreed: Array<{ breed: string; accuracy: number }>;
  accuracyBySymptom: Array<{ symptom: string; accuracy: number }>;
  userSatisfaction: number;
  responseTime: number;
}

export interface ChatbotStats {
  totalConsultations: number;
  averageConfidence: number;
  responseTime: number;
  satisfactionRate: number;
  supportedBreeds: number;
  knownSymptoms: number;
  popularBreeds: Array<{ breed: string; count: number }>;
  commonSymptoms: Array<{ symptom: string; count: number }>;
  emergencyCases: number;
  successfulDiagnoses: number;
  learningProgress: number;
}

export interface VeterinaryMessage {
  id: string;
  type: 'user' | 'bot' | 'system' | 'diagnosis' | 'recommendation' | 'emergency';
  content: string;
  timestamp: Date;
  isTyping?: boolean;
  metadata?: {
    confidence?: number;
    category?: string;
    suggestions?: string[];
    animalBreed?: string;
    symptoms?: string[];
    isEmergency?: boolean;
    diagnosis?: string;
    recommendation?: string;
    severity?: 'low' | 'medium' | 'high' | 'critical';
    followUpRequired?: boolean;
  };
}

export interface DiagnosisRequest {
  animalBreed: string;
  symptoms: string[];
  userMessage?: string;
  timestamp: string;
  userId?: string;
  sessionId?: string;
}

export interface DiagnosisResponse {
  diagnosis: string;
  recommendation: string;
  confidence: number;
  isEmergency: boolean;
  severity: 'low' | 'medium' | 'high' | 'critical';
  alternativeDiagnoses?: string[];
  riskFactors?: string[];
  preventionTips?: string[];
  followUpRequired?: boolean;
  followUpTimeframe?: string;
  emergencyActions?: string[];
}

export interface BreedInfo {
  name: string;
  category: string;
  commonHealthIssues: string[];
  preventiveCare: string[];
  feedingRequirements: string[];
  behavioralTraits: string[];
  exerciseNeeds: string;
  groomingNeeds: string;
  averageLifespan: string;
  size: string;
}

export interface SymptomAnalysis {
  symptom: string;
  severity: 'low' | 'medium' | 'high' | 'emergency';
  possibleCauses: string[];
  immediateActions: string[];
  whenToSeeVet: string;
  preventionTips: string[];
  relatedSymptoms: string[];
}

export interface VeterinarySession {
  id: string;
  userId?: string;
  animalBreed?: string;
  selectedSymptoms: string[];
  messages: VeterinaryMessage[];
  currentStep: 'breed' | 'symptoms' | 'chat' | 'diagnosis' | 'recommendations';
  createdAt: Date;
  lastActivity: Date;
  isActive: boolean;
  diagnosis?: VeterinaryDiagnosis;
  feedback?: ConsultationFeedback;
}

export interface VeterinarySettings {
  language: 'fr' | 'en';
  notifications: boolean;
  emergencyAlerts: boolean;
  dataSharing: boolean;
  learningMode: boolean;
  voiceEnabled: boolean;
  autoDiagnosis: boolean;
  followUpReminders: boolean;
}

export interface VeterinaryAlert {
  id: string;
  type: 'emergency' | 'warning' | 'info' | 'success';
  title: string;
  message: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  timestamp: Date;
  breed?: string;
  symptom?: string;
  actionRequired?: boolean;
  actionText?: string;
  actionUrl?: string;
  dismissed?: boolean;
}

export interface VeterinaryReport {
  id: string;
  consultationId: number;
  breed: string;
  symptoms: string[];
  diagnosis: string;
  recommendation: string;
  confidence: number;
  isEmergency: boolean;
  createdAt: Date;
  userId?: string;
  feedback?: ConsultationFeedback;
  followUpStatus?: 'pending' | 'completed' | 'cancelled';
  followUpDate?: Date;
  actualOutcome?: string;
  accuracy?: number;
}
