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
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String selectedType = 'All';

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

  void filterByType() {
    setState(() {
      filteredPokemons = pokemons.where((pokemon) {
        final matchesType = selectedType == 'All' ||
            pokemon.types.contains(selectedType.toLowerCase());
        final matchesName = pokemon.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        return matchesType && matchesName;
      }).toList();
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
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                  filterByType();
                },
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
                                      'No Pokémon found with that name',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
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
                              final Pokemon pokemon = filteredPokemons[index];
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
