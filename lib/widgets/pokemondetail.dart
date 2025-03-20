import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetail extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeColors = pokemon.getTypeColors();
    final colors = pokemon.types
        .map((type) => Color(
            int.parse(typeColors[type]!.substring(1, 7), radix: 16) +
                0xFF000000))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: colors.length > 1
                          ? LinearGradient(colors: colors)
                          : null,
                      color: colors.length == 1 ? colors[0] : null,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/pokeball.png',
                        fit: BoxFit.contain,
                        height: 100,
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'pokemon_image_${pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        fit: BoxFit.contain,
                        height: 150,
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
                          size: 150,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: colors.length == 1 ? colors[0] : null,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Wrap(
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
                              backgroundColor: Color(int.parse(
                                      typeColors[type]!.substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              labelStyle: TextStyle(color: Colors.white),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Characteristics:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.fitness_center, size: 24),
                                      SizedBox(height: 4),
                                      Text(
                                        '${pokemon.weight} kg',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Weight',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.height, size: 24),
                                      SizedBox(height: 4),
                                      Text(
                                        '${pokemon.height} m',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Height',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stats:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...pokemon.stats.entries.map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: entry.value / 100,
                                            backgroundColor: Colors.grey[300],
                                            color: colors.length > 1
                                                ? colors[1]
                                                : colors[0],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '${entry.value}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
