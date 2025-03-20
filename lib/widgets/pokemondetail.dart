import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetail extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeColors = pokemon.getTypeColors().map((key, value) => MapEntry(
        key, Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000)));

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: typeColors.values.first,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'pokemon_image_${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
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
                    size: 200,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                pokemon.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: typeColors.values.first,
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: pokemon.types.map((type) {
                return Chip(
                  avatar: Image.asset(
                    'assets/icons/$type.webp',
                    height: 16,
                    width: 16,
                  ),
                  label: Text(
                    type[0].toUpperCase() + type.substring(1),
                  ),
                  backgroundColor: typeColors[type],
                  labelStyle: TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Height'),
                trailing: Text('${pokemon.height} m'),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Weight'),
                trailing: Text('${pokemon.weight} kg'),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Stats:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            ...pokemon.stats.entries.map((entry) => Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(entry.key),
                    trailing: Text('${entry.value}'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
