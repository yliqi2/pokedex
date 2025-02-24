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
  int offset = 0; // Mantener un offset para cargar más
  bool isLoading = false; // Variable para saber si se está cargando más
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Pokemon> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchList(); // Cargar los primeros 20 Pokémon

    // Detectar cuando se llega al final de la lista
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchList(); // Llamar a fetchList cuando se llega al final
      }
    });
  }

  // Función para cargar Pokémon
  void fetchList() async {
    if (isLoading) return; // Si ya se está cargando, no hacer nada
    setState(() {
      isLoading = true; // Comenzamos a cargar, ponemos isLoading en true
    });

    try {
      List<Pokemon> newPokemons = await api.getPokemon(offset);
      setState(() {
        pokemons.addAll(newPokemons); // Agregar los nuevos Pokémon a la lista
        offset += 20; // Aumentar el offset para la siguiente llamada
        isLoading = false; // Terminó la carga, ponemos isLoading en false
      });
    } catch (e) {
      // Manejo de errores
      setState(() {
        isLoading = false; // Si hubo un error, también dejamos de cargar
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokémon')),
      );
    }
  }

  // Función de recarga cuando se hace pull-to-refresh
  Future<void> _onRefresh() async {
    setState(() {
      pokemons.clear(); // Limpiar la lista de Pokémon
      offset = 0; // Resetear el offset
    });
    fetchList(); // Cargar los primeros 20 Pokémon
  }

  // Función para filtrar resultados de búsqueda
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
    searchController
        .dispose(); // Asegurarnos de liberar el controlador de búsqueda
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Fondo general sigue siendo rojo
      appBar: AppBar(
        backgroundColor: Colors.red, // Fondo rojo del AppBar
        elevation: 0, // Sin sombra
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Pokedex',
            style: TextStyle(
              color: Colors.white, // Texto blanco en el título
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Menos espacio horizontal
          child: Column(
            children: [
              // Barra de búsqueda con fondo blanco
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  decoration: InputDecoration(
                    hintText: 'Enter Pokémon name...',
                    prefixIcon:
                        Icon(Icons.search, color: Colors.black), // Icono negro
                    filled: true,
                    fillColor:
                        Colors.white, // Fondo blanco en la barra de búsqueda
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color:
                              Colors.blue), // Borde azul cuando está enfocado
                    ),
                  ),
                ),
              ),

              // Si no hay resultados de búsqueda, mostrar todos los pokemones
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh, // Función de pull-to-refresh
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0, // Espacio entre columnas
                        mainAxisSpacing: 16.0, // Espacio entre filas
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

              // Si se está cargando, mostrar un indicador de progreso
              if (isLoading)
                Center(
                  child:
                      CircularProgressIndicator(), // Circular cuando se cargan más pokemones
                ),
            ],
          ),
        ),
      ),
    );
  }
}
