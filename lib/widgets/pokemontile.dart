import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';

class Pokemontile extends StatelessWidget {
  final Pokemon pokemon;
  const Pokemontile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeColors = pokemon.getTypeColors();
    final List<Color> colors = pokemon.types
        .map((type) => Color(
            int.parse(typeColors[type]!.substring(1, 7), radix: 16) +
                0xFF000000))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: colors.length > 1 ? LinearGradient(colors: colors) : null,
        color: colors.length == 1 ? colors[0] : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Hero(
              tag: 'pokemon_image_${pokemon.id}',
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.contain,
                height: 100,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border.all(
                color: Colors.white.withAlpha(77),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pokemon.name.substring(0, 1).toUpperCase() +
                      pokemon.name.substring(1, pokemon.name.length),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pokemon.types.map((type) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColors[type] != null
                            ? Color(int.parse(typeColors[type]!.substring(1, 7),
                                    radix: 16) +
                                0xFF000000)
                            : Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type.substring(0, 1).toUpperCase() +
                            type.substring(1, type.length),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
