class Allergen {
  final int id;
  final String code;
  final String label;

  Allergen({
    required this.id,
    required this.code,
    required this.label,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['id'] as int,
      code: json['code'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'label': label,
    };
  }

  @override
  String toString() => 'Allergen(code: $code, label: $label)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Allergen && other.code == code;
  }
  
  @override
  int get hashCode => code.hashCode;
}
