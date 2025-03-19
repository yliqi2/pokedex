import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/service/pokeapi.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/widgets/pokemontile.dart';
import 'package:pokedex/widgets/pokemondetail.dart';
import 'dart:async';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  List<Pokemon> pokemons = [];
  List<Pokemon> filteredPokemons = [];
  final Pokeapi api = Pokeapi();
  int offset = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  Timer? _debounce;

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
      if (isSearching) {
        List<Pokemon> searchResults =
            await api.searchPokemon(searchController.text.toLowerCase());
        setState(() {
          filteredPokemons.addAll(searchResults);
          isLoading = false;
        });
      } else {
        List<Pokemon> newPokemons = await api.getPokemon(offset);
        setState(() {
          pokemons.addAll(newPokemons);
          filteredPokemons = pokemons;
          offset += 20;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokémon: $e')),
      );
    }
  }

  void searchPokemon(String searchTerm) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Pokemon> searchResults = await api.searchPokemon(searchTerm);
      setState(() {
        filteredPokemons = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      setState(() {
        isSearching = value.isNotEmpty;
      });
      if (isSearching) {
        try {
          List<Pokemon> searchResults =
              await api.searchPokemon(value.toLowerCase());
          setState(() {
            filteredPokemons = searchResults;
          });
        } catch (e) {
          setState(() {
            filteredPokemons = [];
          });
        }
      } else {
        setState(() {
          filteredPokemons = pokemons;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      pokemons.clear();
      filteredPokemons.clear();
      offset = 0;
    });
    fetchList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Pokedex',
            style: TextStyle(
              fontFamily: 'Pokemon',
              color: Theme.of(context).appBarTheme.foregroundColor,
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
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Enter Pokémon name...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                      itemCount: isSearching
                          ? filteredPokemons.length
                          : pokemons.length,
                      itemBuilder: (context, index) {
                        final Pokemon pokemon = isSearching
                            ? filteredPokemons[index]
                            : pokemons[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PokemonDetail(pokemon: pokemon),
                              ),
                            );
                          },
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(
                                parent: AnimationController(
                                  duration: Duration(milliseconds: 300),
                                  vsync: this,
                                )..forward(),
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: Pokemontile(pokemon: pokemon),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: Image.asset(
                    'assets/loading_pokemon.gif',
                    height: 50,
                    width: 50,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
