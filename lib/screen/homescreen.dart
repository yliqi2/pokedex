import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/service/pokeapi.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/widgets/pokemontile.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Pokemon> pokemons = [];
  final Pokeapi api = Pokeapi();
  int offset = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Pokemon> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchList();
      }
    });
  }

  void fetchList() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Pokemon> newPokemons = await api.getPokemon(offset);
      setState(() {
        pokemons.addAll(newPokemons);
        offset += 21;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokémon')),
      );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      pokemons.clear();
      offset = 0;
    });
    fetchList();
  }

  void filterSearchResults(String query) {
    List<Pokemon> results = [];
    if (query.isEmpty) {
      results = pokemons;
    } else {
      results = pokemons.where((pokemon) {
        return pokemon.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      searchResults = results;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Pokedex',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  decoration: InputDecoration(
                    hintText: 'Enter Pokémon name...',
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: searchResults.isEmpty
                          ? pokemons.length
                          : searchResults.length,
                      itemBuilder: (context, index) {
                        final Pokemon pokemon = searchResults.isEmpty
                            ? pokemons[index]
                            : searchResults[index];
                        return Pokemontile(pokemon: pokemon);
                      },
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
