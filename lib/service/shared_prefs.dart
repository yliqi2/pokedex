import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<bool> isFavorite(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritePokemons = prefs.getStringList('favoritePokemons') ?? [];
    return favoritePokemons.contains(pokemonId.toString());
  }

  static Future<void> toggleFavorite(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritePokemons = prefs.getStringList('favoritePokemons') ?? [];
    if (favoritePokemons.contains(pokemonId.toString())) {
      favoritePokemons.remove(pokemonId.toString());
    } else {
      favoritePokemons.add(pokemonId.toString());
    }
    await prefs.setStringList('favoritePokemons', favoritePokemons);
  }

  static Future<List<String>> getFavoritePokemons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favoritePokemons') ?? [];
  }
}
