import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonListTile extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonListTile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeColors = pokemon.getTypeColors();
    final colors = pokemon.types
        .map((type) => Color(
            int.parse(typeColors[type]!.substring(1, 7), radix: 16) +
                0xFF000000))
        .toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: colors.length > 1 ? LinearGradient(colors: colors) : null,
        color: colors.length == 1 ? colors[0] : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/pokeball.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Hero(
                tag: 'pokemon_image_${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  fit: BoxFit.contain,
                  height: 80,
                  width: 80,
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
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
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
