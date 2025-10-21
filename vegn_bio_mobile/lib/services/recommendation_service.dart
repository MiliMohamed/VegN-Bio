import '../models/chat.dart';

class RecommendationService {
  // Recommandations générales par type de symptôme
  static const Map<String, List<String>> _symptomRecommendations = {
    'Perte d\'appétit': [
      'Surveillez la consommation d\'eau de votre animal',
      'Vérifiez la température corporelle (nez, oreilles)',
      'Proposez des aliments appétents et frais',
      'Évitez de forcer l\'alimentation',
      'Consultez un vétérinaire si la perte d\'appétit persiste plus de 24h'
    ],
    'Vomissements': [
      'Mettez votre animal à la diète pendant 12-24h',
      'Proposez de l\'eau en petites quantités fréquentes',
      'Surveillez la fréquence et l\'apparence des vomissements',
      'Notez si l\'animal a mangé quelque chose d\'inhabituel',
      'Consultez immédiatement si vomissements répétés ou avec du sang'
    ],
    'Diarrhée': [
      'Proposez une alimentation légère (riz, poulet bouilli)',
      'Surveillez la déshydratation (test du pli de peau)',
      'Évitez les produits laitiers',
      'Maintenez l\'accès à l\'eau propre',
      'Consultez si la diarrhée persiste plus de 48h ou contient du sang'
    ],
    'Léthargie': [
      'Vérifiez la température corporelle',
      'Surveillez les autres symptômes associés',
      'Assurez-vous que l\'animal boit suffisamment',
      'Évitez les efforts physiques',
      'Consultez rapidement si la léthargie s\'aggrave'
    ],
    'Toux': [
      'Surveillez la fréquence et le type de toux',
      'Vérifiez s\'il y a des difficultés respiratoires',
      'Évitez l\'exposition à la fumée ou aux irritants',
      'Maintenez un environnement calme',
      'Consultez rapidement si la toux s\'aggrave ou persiste'
    ],
    'Éternuements': [
      'Surveillez les écoulements nasaux',
      'Vérifiez s\'il y a des difficultés respiratoires',
      'Évitez l\'exposition aux allergènes',
      'Maintenez un environnement propre',
      'Consultez si les éternuements sont fréquents ou avec écoulement'
    ],
    'Démangeaisons': [
      'Inspectez la peau pour des lésions ou parasites',
      'Évitez les bains fréquents qui assèchent la peau',
      'Utilisez des produits hypoallergéniques',
      'Surveillez l\'apparition de zones rouges ou chauves',
      'Consultez si les démangeaisons sont intenses ou persistantes'
    ],
    'Boiterie': [
      'Surveillez quel membre est affecté',
      'Évitez les exercices intenses',
      'Vérifiez s\'il y a des blessures visibles',
      'Appliquez de la glace en cas de gonflement',
      'Consultez rapidement si la boiterie persiste ou s\'aggrave'
    ]
  };

  // Recommandations spécifiques par race
  static const Map<String, Map<String, List<String>>> _breedSpecificRecommendations = {
    'Chien': {
      'Perte d\'appétit': [
        'Les chiens peuvent refuser de manger pour diverses raisons',
        'Vérifiez les dents et les gencives',
        'Surveillez le comportement général',
        'Proposez des aliments de différentes textures'
      ],
      'Vomissements': [
        'Les chiens vomissent facilement, souvent sans gravité',
        'Surveillez s\'il a mangé de l\'herbe ou des objets',
        'Vérifiez la couleur et la consistance des vomissements'
      ]
    },
    'Chat': {
      'Perte d\'appétit': [
        'Les chats sont très sensibles aux changements alimentaires',
        'Vérifiez la fraîcheur de la nourriture',
        'Surveillez les habitudes de toilettage',
        'Une perte d\'appétit chez un chat est souvent préoccupante'
      ],
      'Vomissements': [
        'Les chats vomissent fréquemment (boules de poils)',
        'Surveillez la fréquence et le contenu',
        'Vérifiez s\'il y a des boules de poils dans les vomissements'
      ]
    },
    'Lapin': {
      'Perte d\'appétit': [
        'Très préoccupant chez les lapins (système digestif fragile)',
        'Surveillez la production de crottes',
        'Vérifiez la consommation de foin',
        'Consultez immédiatement un vétérinaire spécialisé NAC'
      ]
    },
    'Hamster': {
      'Léthargie': [
        'Les hamsters sont nocturnes, vérifiez les horaires',
        'Surveillez la température de la cage',
        'Vérifiez la qualité de la litière'
      ]
    },
    'Oiseau': {
      'Perte d\'appétit': [
        'Surveillez la consommation de graines',
        'Vérifiez l\'état du plumage',
        'Observez le comportement social',
        'Consultez rapidement un vétérinaire aviaire'
      ]
    }
  };

  // Recommandations d'urgence
  static const List<String> _emergencyRecommendations = [
    '🚨 URGENCE VÉTÉRINAIRE : Consultez immédiatement un vétérinaire',
    'Appelez un vétérinaire d\'urgence si disponible',
    'Transportez l\'animal en toute sécurité',
    'Notez tous les symptômes observés',
    'Apportez le carnet de santé si disponible'
  ];

  // Symptômes d'urgence
  static const List<String> _emergencySymptoms = [
    'difficultés respiratoires',
    'saignement',
    'trauma',
    'convulsions',
    'perte de conscience',
    'vomissements répétés',
    'diarrhée avec sang',
    'gonflement soudain'
  ];

  // Obtenir des recommandations basées sur les symptômes
  static List<String> getRecommendations({
    required String animalBreed,
    required List<String> symptoms,
  }) {
    List<String> recommendations = [];

    // Vérifier les urgences en premier
    if (_isEmergency(symptoms)) {
      recommendations.addAll(_emergencyRecommendations);
      return recommendations;
    }

    // Ajouter des recommandations générales
    for (String symptom in symptoms) {
      if (_symptomRecommendations.containsKey(symptom)) {
        recommendations.addAll(_symptomRecommendations[symptom]!);
      }
    }

    // Ajouter des recommandations spécifiques à la race
    if (_breedSpecificRecommendations.containsKey(animalBreed)) {
      final breedRecs = _breedSpecificRecommendations[animalBreed]!;
      for (String symptom in symptoms) {
        if (breedRecs.containsKey(symptom)) {
          recommendations.addAll(breedRecs[symptom]!);
        }
      }
    }

    // Ajouter des recommandations générales de suivi
    recommendations.addAll(_getGeneralFollowUpRecommendations());

    // Supprimer les doublons et limiter le nombre
    return recommendations.toSet().take(8).toList();
  }

  // Obtenir des recommandations préventives par race
  static List<String> getPreventiveRecommendations(String animalBreed) {
    switch (animalBreed.toLowerCase()) {
      case 'chien':
        return [
          'Vaccinations régulières selon le calendrier',
          'Vermifugation tous les 3 mois',
          'Nettoyage régulier des dents',
          'Exercice quotidien adapté',
          'Alimentation équilibrée selon l\'âge',
          'Surveillance du poids'
        ];
      case 'chat':
        return [
          'Vaccinations et rappels annuels',
          'Vermifugation tous les 3 mois',
          'Brossage régulier du pelage',
          'Alimentation adaptée (croquettes ou pâtée)',
          'Enrichissement de l\'environnement',
          'Surveillance des boules de poils'
        ];
      case 'lapin':
        return [
          'Alimentation riche en foin (80%)',
          'Légumes frais quotidiens',
          'Vermifugation régulière',
          'Surveillance des dents',
          'Enrichissement de l\'environnement',
          'Vaccination contre la myxomatose'
        ];
      case 'hamster':
        return [
          'Cage spacieuse avec roue',
          'Alimentation équilibrée',
          'Litière changée régulièrement',
          'Surveillance du poids',
          'Éviter les bains (stress)',
          'Enrichissement avec jouets'
        ];
      case 'oiseau':
        return [
          'Volière spacieuse',
          'Alimentation variée (graines, fruits, légumes)',
          'Nettoyage régulier de la cage',
          'Surveillance du plumage',
          'Stimulation mentale',
          'Éviter les courants d\'air'
        ];
      default:
        return [
          'Consultation vétérinaire régulière',
          'Alimentation adaptée à l\'espèce',
          'Environnement propre et stimulant',
          'Surveillance du comportement',
          'Prévention des parasites'
        ];
    }
  }

  // Vérifier si les symptômes sont une urgence
  static bool _isEmergency(List<String> symptoms) {
    return symptoms.any((symptom) => 
      _emergencySymptoms.any((emergency) => 
        symptom.toLowerCase().contains(emergency.toLowerCase())
      )
    );
  }

  // Recommandations générales de suivi
  static List<String> _getGeneralFollowUpRecommendations() {
    return [
      'Surveillez l\'évolution des symptômes',
      'Notez tout changement de comportement',
      'Maintenez un environnement calme',
      'Consultez un vétérinaire si les symptômes persistent',
      'Gardez les informations de contact d\'un vétérinaire d\'urgence'
    ];
  }

  // Obtenir des conseils d'alimentation par race
  static List<String> getFeedingRecommendations(String animalBreed) {
    switch (animalBreed.toLowerCase()) {
      case 'chien':
        return [
          '2-3 repas par jour selon l\'âge',
          'Alimentation adaptée à la taille et l\'âge',
          'Éviter les os cuits (danger d\'étouffement)',
          'Eau fraîche toujours disponible',
          'Attention aux aliments toxiques (chocolat, oignon, etc.)'
        ];
      case 'chat':
        return [
          'Alimentation libre ou repas fractionnés',
          'Préférer les aliments humides pour l\'hydratation',
          'Éviter le lait de vache (intolérance)',
          'Surveiller l\'obésité',
          'Aliments adaptés aux besoins spécifiques'
        ];
      case 'lapin':
        return [
          'Foin à volonté (base de l\'alimentation)',
          'Légumes frais quotidiens',
          'Granulés en quantité limitée',
          'Éviter les fruits sucrés',
          'Eau propre et fraîche'
        ];
      case 'hamster':
        return [
          'Mélange de graines spécialisé',
          'Légumes frais en petites quantités',
          'Fruits occasionnellement',
          'Éviter les aliments sucrés',
          'Surveiller le stockage (ne pas gaspiller)'
        ];
      case 'oiseau':
        return [
          'Mélange de graines varié',
          'Fruits et légumes frais',
          'Éviter l\'avocat (toxique)',
          'Eau changée quotidiennement',
          'Suppléments minéraux si nécessaire'
        ];
      default:
        return [
          'Alimentation adaptée à l\'espèce',
          'Eau propre et fraîche',
          'Éviter les aliments toxiques',
          'Surveiller l\'appétit',
          'Consultation vétérinaire pour les besoins spécifiques'
        ];
    }
  }

  // Obtenir des conseils de comportement
  static List<String> getBehavioralRecommendations(String animalBreed, List<String> symptoms) {
    List<String> recommendations = [];
    
    if (symptoms.any((s) => s.toLowerCase().contains('léthargie'))) {
      recommendations.add('Surveillez les changements de routine');
      recommendations.add('Maintenez un environnement stable');
    }
    
    if (symptoms.any((s) => s.toLowerCase().contains('stress'))) {
      recommendations.add('Identifiez les sources de stress');
      recommendations.add('Créez un environnement calme');
      recommendations.add('Utilisez des phéromones apaisantes si approprié');
    }

    switch (animalBreed.toLowerCase()) {
      case 'chien':
        recommendations.addAll([
          'Maintenez une routine d\'exercice régulière',
          'Utilisez le renforcement positif',
          'Surveillez les interactions sociales'
        ]);
        break;
      case 'chat':
        recommendations.addAll([
          'Respectez les espaces de retrait',
          'Fournissez des postes d\'observation élevés',
          'Surveillez les interactions avec d\'autres animaux'
        ]);
        break;
      case 'lapin':
        recommendations.addAll([
          'Surveillez le comportement social',
          'Fournissez des cachettes',
          'Évitez les manipulations excessives'
        ]);
        break;
    }

    return recommendations;
  }
}


