class BasicPokemon {
  final String name;
  final int id;
  final List<String> types;

  BasicPokemon({
    required this.name,
    required this.id,
    required this.types,
  });

  factory BasicPokemon.fromJson(Map<String, dynamic> json) {
    return BasicPokemon(
      name: json['name'],
      id: json['id'],
      types: List<String>.from(json['types']),
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'types': types,
    };
  }
}
