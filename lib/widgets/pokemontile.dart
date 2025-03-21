import 'package:flutter/material.dart';
import 'package:pokedex/model/basic_pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/service/noti_service.dart';
import 'package:pokedex/service/shared_prefs.dart';

class Pokemontile extends StatefulWidget {
  final BasicPokemon pokemon;
  final VoidCallback onFavoriteChanged;
  const Pokemontile({
    super.key,
    required this.pokemon,
    required this.onFavoriteChanged,
  });

  @override
  State<Pokemontile> createState() => _PokemontileState();
}

class _PokemontileState extends State<Pokemontile> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  void didUpdateWidget(Pokemontile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemon.id != widget.pokemon.id) {
      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    final favorite = await SharedPrefs.isFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    final newFavoriteStatus = !isFavorite;
    await SharedPrefs.toggleFavorite(widget.pokemon.id);
    setState(() {
      isFavorite = newFavoriteStatus;
    });
    widget.onFavoriteChanged();
    NotiService().showNotification(
      id: widget.pokemon.id,
      title: newFavoriteStatus
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

    return Stack(
      children: [
        Container(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          'assets/pokeball.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'pokemon_image_${widget.pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png',
                        fit: BoxFit.contain,
                        height: 130,
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
                  ],
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
                      widget.pokemon.name[0].toUpperCase() +
                          widget.pokemon.name.substring(1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.pokemon.types.map((type) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ),
      ],
    );
  }
}
