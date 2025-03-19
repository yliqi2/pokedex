import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/model/pokemon.dart';

class Pokeapi {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> getPokemon(int offset) async {
    final url = Uri.parse('$baseUrl?limit=20&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = await compute(jsonDecode, response.body);

      List<Future<Pokemon>> requests = data['results']
          .map<Future<Pokemon>>(
            (pokemonData) => getPokemonByName(pokemonData['name']),
          )
          .toList();

      List<Pokemon> pokemons = await Future.wait(requests);

      return pokemons;
    } else {
      throw Exception('No more Pokémon to load');
    }
  }

  Future<Pokemon> getPokemonByName(String name) async {
    final url = Uri.parse('$baseUrl/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final pokemonDetail = await compute(jsonDecode, response.body);
      return Pokemon.fromJson(pokemonDetail);
    } else {
      throw Exception('Pokémon not found');
    }
  }

  Future<List<Pokemon>> searchPokemon(String searchTerm) async {
    try {
      Pokemon exactMatch = await getPokemonByName(searchTerm);
      return [exactMatch];
    } catch (e) {
      final url = Uri.parse('$baseUrl?limit=100000');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = await compute(jsonDecode, response.body);
        final List<Future<Pokemon>> requests = data['results']
            .where((pokemonData) =>
                pokemonData['name'] != null &&
                pokemonData['name']
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .map<Future<Pokemon>>(
              (pokemonData) => getPokemonByName(pokemonData['name']),
            )
            .toList();

        List<Pokemon> pokemons = await Future.wait(requests);
        pokemons = pokemons
            .where((pokemon) =>
                pokemon.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();

        return pokemons;
      } else {
        throw Exception(
            'Failed to search Pokémon: ${response.statusCode} - ${response.reasonPhrase}');
      }
    }
  }
}
