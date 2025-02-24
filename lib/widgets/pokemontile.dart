import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';

class Pokemontile extends StatelessWidget {
  final Pokemon pokemon;
  const Pokemontile({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Imagen del Pokémon
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(
              pokemon.url,
              fit: BoxFit.contain,
            ),
          ),

          // Nombre del Pokémon
          Container(
            height: 25,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                pokemon.name.substring(0, 1).toUpperCase() +
                    pokemon.name.substring(1, pokemon.name.length),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
