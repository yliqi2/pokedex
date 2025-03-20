import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/service/pokeapi.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/widgets/pokemontile.dart';
import 'package:pokedex/widgets/pokemondetail.dart';
import 'package:pokedex/widgets/pokemonlisttile.dart';
import 'package:pokedex/service/connectivity.dart'; // Add this import
import 'package:pokedex/service/shared_prefs.dart'; // Add this import
import 'dart:async';

class Homescreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const Homescreen({super.key, required this.toggleTheme});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  List<Pokemon> pokemons = [];
  List<Pokemon> filteredPokemons = [];
  final Pokeapi api = Pokeapi();
  final ConnectivityService connectivityService =
      ConnectivityService(); // Add this line
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String selectedType = 'All';
  String sortBy = 'ID';
  bool isGridView = true;
  bool isConnected = true;
  bool showFavorites = false; // Add this line

  @override
  void initState() {
    super.initState();
    checkConnectivityAndFetchList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        checkConnectivityAndFetchList();
      }
    });
  }

  void checkConnectivityAndFetchList() async {
    isConnected = await connectivityService.isConnectedToWifi();
    if (isConnected) {
      fetchList();
    }
  }

  void fetchList() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Pokemon> newPokemons = await api.getPokemon();
      setState(() {
        pokemons = newPokemons;
        filteredPokemons = pokemons;
        isLoading = false;
      });
      filterByType();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokémon: $e')),
      );
    }
  }

  void filterByType() async {
    final favoritePokemons = await SharedPrefs.getFavoritePokemons();

    setState(() {
      filteredPokemons = pokemons.where((pokemon) {
        final matchesType = selectedType == 'All' ||
            pokemon.types.contains(selectedType.toLowerCase());
        final matchesName = pokemon.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        final matchesFavorite =
            !showFavorites || favoritePokemons.contains(pokemon.id.toString());
        return matchesType && matchesName && matchesFavorite;
      }).toList();

      if (sortBy == 'ID') {
        filteredPokemons.sort((a, b) => a.id.compareTo(b.id));
      } else if (sortBy == 'Alphabetical') {
        filteredPokemons.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      filterByType();
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      pokemons.clear();
      filteredPokemons.clear();
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

  Color? getTypeColor(String type) {
    final typeColors =
        pokemons.isNotEmpty ? pokemons.first.getTypeColors() : {};
    if (typeColors.containsKey(type.toLowerCase())) {
      return Color(int.parse(typeColors[type.toLowerCase()]!.substring(1, 7),
              radix: 16) +
          0xFF000000);
    }
    return null;
  }

  void _onFavoriteChanged() {
    filterByType();
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
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(showFavorites ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
              filterByType();
            },
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                          filterByType();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: getTypeColor(selectedType),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: <String>[
                          'All',
                          'Normal',
                          'Fire',
                          'Water',
                          'Electric',
                          'Grass',
                          'Ice',
                          'Fighting',
                          'Poison',
                          'Ground',
                          'Flying',
                          'Psychic',
                          'Bug',
                          'Rock',
                          'Ghost',
                          'Dragon',
                          'Dark',
                          'Steel',
                          'Fairy'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: sortBy,
                        onChanged: (String? newValue) {
                          setState(() {
                            sortBy = newValue!;
                          });
                          filterByType();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: <String>['ID', 'Alphabetical']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: filteredPokemons.isEmpty && !isLoading
                        ? Center(
                            child: Card(
                              color: Colors.white.withAlpha(51),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/pokemon.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      isConnected
                                          ? 'No Pokémon found'
                                          : 'No internet connection. Please try again later.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : isGridView
                            ? GridView.builder(
                                controller: _scrollController,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: filteredPokemons.length,
                                itemBuilder: (context, index) {
                                  final Pokemon pokemon =
                                      filteredPokemons[index];
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
                                      scale: Tween<double>(begin: 0.8, end: 1.0)
                                          .animate(
                                        CurvedAnimation(
                                          parent: AnimationController(
                                            duration:
                                                Duration(milliseconds: 300),
                                            vsync: this,
                                          )..forward(),
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                      child: Pokemontile(
                                        pokemon: pokemon,
                                        onFavoriteChanged:
                                            _onFavoriteChanged, // Update this line
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: filteredPokemons.length,
                                itemBuilder: (context, index) {
                                  final Pokemon pokemon =
                                      filteredPokemons[index];
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
                                      scale: Tween<double>(begin: 0.8, end: 1.0)
                                          .animate(
                                        CurvedAnimation(
                                          parent: AnimationController(
                                            duration:
                                                Duration(milliseconds: 300),
                                            vsync: this,
                                          )..forward(),
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                      child: PokemonListTile(
                                        pokemon: pokemon,
                                        onFavoriteChanged:
                                            _onFavoriteChanged, // Update this line
                                      ),
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
                    height: 200,
                    width: 200,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (filteredPokemons.isNotEmpty) {
            final randomPokemon = (filteredPokemons..shuffle()).first;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetail(pokemon: randomPokemon),
              ),
            );
          }
        },
        mini: true,
        backgroundColor: Colors.red,
        child: Icon(Icons.shuffle),
      ),
    );
  }
}
