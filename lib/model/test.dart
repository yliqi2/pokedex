import 'dart:convert';
import 'package:http/http.dart' as http;

class Pokemon {
  final String name;
  final String spriteUrl;

  Pokemon({required this.name, required this.spriteUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      spriteUrl: json['sprites']['front_default'],
    );
  }
}

class Pokeapi {
  final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20');

  Future<List<Pokemon>> getPokemon() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Pokemon> pokemons = [];

      for (var pokemonData in data['results']) {
        final pokemonUrl = pokemonData['url'];
        //llama a la api para obtener la imagen
        final pokemonResponse = await http.get(Uri.parse(pokemonUrl));

        if (pokemonResponse.statusCode == 200) {
          final pokemonDetail = jsonDecode(pokemonResponse.body);
          // Crear una instancia de Pokemon y agregarla a la lista
          pokemons.add(Pokemon.fromJson(pokemonDetail));
        } else {
          throw Exception('Failed to load Pokémon details');
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
