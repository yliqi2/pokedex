import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/model/pokemon.dart';

class Pokeapi {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> getPokemon() async {
    final url = Uri.parse('$baseUrl?limit=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = await compute(jsonDecode, response.body);

      List<Future<Pokemon>> requests = data['results']
          .map<Future<Pokemon>>(
            (pokemonData) => _fetchPokemonDetails(pokemonData['url']),
          )
          .toList();

      return await Future.wait(requests);
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  Future<Pokemon> _fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final pokemonDetail = await compute(jsonDecode, response.body);
      return Pokemon.fromJson(pokemonDetail);
    } else {
      throw Exception('Pokémon not found');
    }
  }
}
