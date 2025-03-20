import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Pokemontile extends StatelessWidget {
  final Pokemon pokemon;
  const Pokemontile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeColors = pokemon.getTypeColors();
    final colors = pokemon.types
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Hero(
              tag: 'pokemon_image_${pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                fit: BoxFit.contain,
                height: 100,
                placeholder: (context, url) => Center(
                  child: Image.asset(
                    'assets/loading_pokemon.gif',
                    height: 50,
                    width: 50,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 100,
                ),
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
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
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
                        color: Color(int.parse(
                                typeColors[type]!.substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.asset(
                        'assets/icons/$type.webp',
                        height: 16,
                        width: 16,
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
