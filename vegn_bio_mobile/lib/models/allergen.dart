class Allergen {
  final String code;
  final String name;
  final String description;
  final String? icon;

  Allergen({
    required this.code,
    required this.name,
    required this.description,
    this.icon,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      code: json['code'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }
}
