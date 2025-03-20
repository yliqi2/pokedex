import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/service/noti_service.dart';
import 'package:pokedex/service/shared_prefs.dart'; // Update this import

class PokemonListTile extends StatefulWidget {
  final Pokemon pokemon;
  final VoidCallback onFavoriteChanged; // Add this line
  const PokemonListTile(
      {super.key,
      required this.pokemon,
      required this.onFavoriteChanged}); // Update this line

  @override
  State<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends State<PokemonListTile> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorite = await SharedPrefs.isFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    await SharedPrefs.toggleFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoriteChanged(); // Add this line
    NotiService().showNotification(
      id: widget.pokemon.id,
      title: isFavorite
          ? '${widget.pokemon.name} added to favorites'
          : '${widget.pokemon.name} removed from favorites',
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColors = widget.pokemon.getTypeColors();
    final colors = widget.pokemon.types
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
                tag: 'pokemon_image_${widget.pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.pokemon.imageUrl,
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
                  widget.pokemon.name[0].toUpperCase() +
                      widget.pokemon.name.substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ...widget.pokemon.types.map((type) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                                  typeColors[type]!.substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.asset(
                          'assets/icons/$type.webp',
                          height: 24,
                          width: 24,
                        ),
                      );
                    }),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.red,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
