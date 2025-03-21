import 'basic_pokemon.dart';

class Pokemon extends BasicPokemon {
  final String imageUrl;
  final double weight;
  final double height;
  final Map<String, int> stats;

  Pokemon({
    required super.id,
    required super.name,
    required super.types,
    required this.imageUrl,
    required this.weight,
    required this.height,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      types: (json['types'] as List?)
              ?.map((type) => type['type']['name'] as String)
              .toList() ??
          [],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ?? '',
      weight: (json['weight'] ?? 0) / 10,
      height: (json['height'] ?? 0) / 10,
      stats: {
        "HP": json['stats']?[0]['base_stat'] ?? 0,
        "Attack": json['stats']?[1]['base_stat'] ?? 0,
        "Defense": json['stats']?[2]['base_stat'] ?? 0,
        "Speed": json['stats']?[5]['base_stat'] ?? 0,
      },
    );
  }
}
