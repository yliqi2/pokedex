import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/model/basic_pokemon.dart';

class Pokeapi {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<Pokemon> fetchPokemonDetails(String pokemon) async {
    final response = await http.get(Uri.parse(baseUrl + pokemon.toLowerCase()));

    if (response.statusCode == 200) {
      final pokemonDetail = await compute(jsonDecode, response.body);
      return Pokemon.fromJson(pokemonDetail);
    } else {
      throw Exception('Pokémon not found');
    }
  }

  Future<List<BasicPokemon>> fetchAllPokemonBasic() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1302'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      List<Future<BasicPokemon>> requests =
          results.map<Future<BasicPokemon>>((result) async {
        final detailResponse = await http.get(Uri.parse(result['url']));

        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          return BasicPokemon.fromJson({
            'name': result['name'],
            'id': detailData['id'],
            'types': detailData['types']
                .map((typeInfo) => typeInfo['type']['name'])
                .toList(),
          });
        } else {
          throw Exception(
              'Failed to load Pokémon details for ${result['name']}');
        }
      }).toList();

      return await Future.wait(requests);
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }
}
