// Données mock pour le chatbot vétérinaire
import { AnimalBreed, Symptom } from '../types/veterinary';

export const mockBreeds: AnimalBreed[] = [
  {
    id: '1',
    name: 'Chien',
    category: 'chien',
    description: 'Animal domestique fidèle et loyal',
    commonSymptoms: ['Perte d\'appétit', 'Vomissements', 'Diarrhée', 'Léthargie', 'Toux', 'Démangeaisons'],
    averageLifespan: 12,
    size: 'moyen',
    temperament: ['Fidèle', 'Protecteur', 'Sociable']
  },
  {
    id: '2',
    name: 'Chat',
    category: 'chat',
    description: 'Animal domestique indépendant et élégant',
    commonSymptoms: ['Perte d\'appétit', 'Vomissements', 'Diarrhée', 'Léthargie', 'Éternuements', 'Démangeaisons'],
    averageLifespan: 15,
    size: 'petit',
    temperament: ['Indépendant', 'Curieux', 'Calme']
  },
  {
    id: '3',
    name: 'Lapin',
    category: 'lapin',
    description: 'Animal de compagnie doux et sociable',
    commonSymptoms: ['Perte d\'appétit', 'Diarrhée', 'Léthargie', 'Difficultés respiratoires', 'Démangeaisons'],
    averageLifespan: 8,
    size: 'petit',
    temperament: ['Doux', 'Sociable', 'Nerveux']
  },
  {
    id: '4',
    name: 'Hamster',
    category: 'hamster',
    description: 'Petit rongeur nocturne et actif',
    commonSymptoms: ['Léthargie', 'Perte d\'appétit', 'Difficultés respiratoires', 'Démangeaisons'],
    averageLifespan: 3,
    size: 'petit',
    temperament: ['Actif', 'Nocturne', 'Territorial']
  },
  {
    id: '5',
    name: 'Oiseau',
    category: 'oiseau',
    description: 'Animal volant coloré et vocal',
    commonSymptoms: ['Perte d\'appétit', 'Difficultés respiratoires', 'Léthargie', 'Changements de plumage'],
    averageLifespan: 10,
    size: 'petit',
    temperament: ['Vocal', 'Sociable', 'Intelligent']
  }
];

export const mockSymptoms: Symptom[] = [
  {
    id: '1',
    name: 'Perte d\'appétit',
    severity: 'medium',
    description: 'L\'animal refuse de manger ou mange moins que d\'habitude',
    category: 'digestif',
    commonBreeds: ['Chien', 'Chat', 'Lapin', 'Oiseau'],
    emergencyActions: ['Surveiller la consommation d\'eau', 'Vérifier la température'],
    relatedSymptoms: ['Léthargie', 'Vomissements']
  },
  {
    id: '2',
    name: 'Vomissements',
    severity: 'medium',
    description: 'L\'animal régurgite sa nourriture ou des liquides',
    category: 'digestif',
    commonBreeds: ['Chien', 'Chat'],
    emergencyActions: ['Mettre à la diète', 'Surveiller la fréquence'],
    relatedSymptoms: ['Perte d\'appétit', 'Diarrhée']
  },
  {
    id: '3',
    name: 'Diarrhée',
    severity: 'medium',
    description: 'Selles liquides ou très molles',
    category: 'digestif',
    commonBreeds: ['Chien', 'Chat', 'Lapin'],
    emergencyActions: ['Surveiller la déshydratation', 'Alimentation légère'],
    relatedSymptoms: ['Vomissements', 'Perte d\'appétit']
  },
  {
    id: '4',
    name: 'Léthargie',
    severity: 'high',
    description: 'L\'animal semble fatigué et moins actif que d\'habitude',
    category: 'comportemental',
    commonBreeds: ['Chien', 'Chat', 'Lapin', 'Hamster', 'Oiseau'],
    emergencyActions: ['Vérifier la température', 'Surveiller les autres symptômes'],
    relatedSymptoms: ['Perte d\'appétit', 'Difficultés respiratoires']
  },
  {
    id: '5',
    name: 'Difficultés respiratoires',
    severity: 'emergency',
    description: 'L\'animal a du mal à respirer ou respire rapidement',
    category: 'respiratoire',
    commonBreeds: ['Chien', 'Chat', 'Lapin', 'Hamster', 'Oiseau'],
    emergencyActions: ['Consulter immédiatement un vétérinaire', 'Maintenir l\'animal au calme'],
    relatedSymptoms: ['Toux', 'Éternuements']
  },
  {
    id: '6',
    name: 'Toux',
    severity: 'medium',
    description: 'L\'animal tousse de manière répétée',
    category: 'respiratoire',
    commonBreeds: ['Chien', 'Chat'],
    emergencyActions: ['Surveiller la fréquence', 'Éviter les irritants'],
    relatedSymptoms: ['Difficultés respiratoires', 'Éternuements']
  },
  {
    id: '7',
    name: 'Éternuements',
    severity: 'low',
    description: 'L\'animal éternue fréquemment',
    category: 'respiratoire',
    commonBreeds: ['Chat', 'Hamster'],
    emergencyActions: ['Surveiller les écoulements', 'Maintenir un environnement propre'],
    relatedSymptoms: ['Difficultés respiratoires', 'Toux']
  },
  {
    id: '8',
    name: 'Démangeaisons',
    severity: 'low',
    description: 'L\'animal se gratte excessivement',
    category: 'dermatologique',
    commonBreeds: ['Chien', 'Chat', 'Lapin', 'Hamster'],
    emergencyActions: ['Inspecter la peau', 'Éviter les bains fréquents'],
    relatedSymptoms: ['Perte de poils', 'Rougeurs']
  },
  {
    id: '9',
    name: 'Convulsions',
    severity: 'emergency',
    description: 'L\'animal a des spasmes musculaires involontaires',
    category: 'neurologique',
    commonBreeds: ['Chien', 'Chat'],
    emergencyActions: ['Consulter immédiatement un vétérinaire', 'Protéger l\'animal'],
    relatedSymptoms: ['Perte de conscience', 'Léthargie']
  },
  {
    id: '10',
    name: 'Saignement',
    severity: 'emergency',
    description: 'Saignement visible ou dans les selles/urines',
    category: 'autre',
    commonBreeds: ['Chien', 'Chat', 'Lapin'],
    emergencyActions: ['Consulter immédiatement un vétérinaire', 'Appliquer une pression si possible'],
    relatedSymptoms: ['Trauma', 'Diarrhée']
  }
];

export const mockDiagnosisResponses: DiagnosisResponse[] = [
  {
    diagnosis: 'Gastro-entérite légère',
    recommendation: 'Mettez votre animal à la diète pendant 12-24h, proposez de l\'eau en petites quantités fréquentes, et surveillez l\'évolution des symptômes. Si les symptômes persistent plus de 48h, consultez un vétérinaire.',
    confidence: 0.85,
    isEmergency: false,
    severity: 'medium',
    alternativeDiagnoses: ['Intoxication alimentaire', 'Parasites intestinaux'],
    riskFactors: ['Changement d\'alimentation récent', 'Accès à des aliments inappropriés'],
    preventionTips: ['Alimentation régulière', 'Éviter les aliments toxiques', 'Vermifugation régulière'],
    followUpRequired: true,
    followUpTimeframe: '48 heures'
  },
  {
    diagnosis: 'Infection respiratoire',
    recommendation: 'URGENCE VÉTÉRINAIRE : Consultez immédiatement un vétérinaire. En attendant, maintenez l\'animal au calme, évitez l\'exposition à la fumée ou aux irritants, et surveillez la respiration.',
    confidence: 0.92,
    isEmergency: true,
    severity: 'critical',
    alternativeDiagnoses: ['Pneumonie', 'Asthme', 'Allergie'],
    riskFactors: ['Exposition à la fumée', 'Environnement pollué', 'Stress'],
    preventionTips: ['Environnement propre', 'Éviter les courants d\'air', 'Vaccination'],
    followUpRequired: true,
    followUpTimeframe: 'Immédiatement'
  },
  {
    diagnosis: 'Stress ou anxiété',
    recommendation: 'Créez un environnement calme et stable pour votre animal. Identifiez les sources de stress et éliminez-les si possible. Utilisez des phéromones apaisantes si approprié. Si le comportement persiste, consultez un vétérinaire comportementaliste.',
    confidence: 0.75,
    isEmergency: false,
    severity: 'low',
    alternativeDiagnoses: ['Dépression', 'Maladie sous-jacente'],
    riskFactors: ['Changements récents', 'Manque d\'exercice', 'Environnement stressant'],
    preventionTips: ['Routine stable', 'Exercice régulier', 'Enrichissement environnemental'],
    followUpRequired: false,
    followUpTimeframe: '1-2 semaines'
  }
];

export const mockStats = {
  totalConsultations: 1247,
  averageConfidence: 0.87,
  responseTime: 1.2,
  satisfactionRate: 94,
  supportedBreeds: 5,
  knownSymptoms: 10,
  popularBreeds: [
    { breed: 'Chien', count: 456 },
    { breed: 'Chat', count: 389 },
    { breed: 'Lapin', count: 234 },
    { breed: 'Hamster', count: 98 },
    { breed: 'Oiseau', count: 70 }
  ],
  commonSymptoms: [
    { symptom: 'Perte d\'appétit', count: 234 },
    { symptom: 'Léthargie', count: 198 },
    { symptom: 'Vomissements', count: 156 },
    { symptom: 'Diarrhée', count: 134 },
    { symptom: 'Démangeaisons', count: 112 },
    { symptom: 'Toux', count: 89 },
    { symptom: 'Difficultés respiratoires', count: 67 },
    { symptom: 'Éternuements', count: 45 }
  ],
  emergencyCases: 23,
  successfulDiagnoses: 1089,
  learningProgress: 87
};
