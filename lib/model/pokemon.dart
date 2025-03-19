class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final double weight;
  final double height;
  final List<String> types;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.height,
    required this.types,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      weight: json['weight'] / 10,
      height: json['height'] / 10,
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: {
        "HP": json['stats'][0]['base_stat'],
        "Attack": json['stats'][1]['base_stat'],
        "Defense": json['stats'][2]['base_stat'],
        "Speed": json['stats'][5]['base_stat'],
      },
    );
  }

  Map<String, String> getTypeColors() {
    const typeColors = {
      'normal': '#A8A77A',
      'fire': '#EE8130',
      'water': '#6390F0',
      'electric': '#F7D02C',
      'grass': '#7AC74C',
      'ice': '#96D9D6',
      'fighting': '#C22E28',
      'poison': '#A33EA1',
      'ground': '#E2BF65',
      'flying': '#A98FF3',
      'psychic': '#F95587',
      'bug': '#A6B91A',
      'rock': '#B6A136',
      'ghost': '#735797',
      'dragon': '#6F35FC',
      'dark': '#705746',
      'steel': '#B7B7CE',
      'fairy': '#D685AD',
    };

    return {for (var type in types) type: typeColors[type] ?? '#000000'};
  }
}
