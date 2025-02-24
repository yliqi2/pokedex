# Pokedex App

A simple Pokedex application built with Flutter that fetches Pokémon data from the PokéAPI and displays it in a user-friendly interface.

## Features

- Infinite scrolling to load more Pokémon as you scroll.
- Search functionality to find Pokémon by name.
- Pull-to-refresh feature to reload the Pokémon list.
- Beautiful grid-based UI with Pokémon images and names.
- Error handling for API requests.

## Screenshots

![Pokedex Screenshot](https://github.com/yliqi2/pokedex/blob/main/result/mainscreen.png)
![Pokedex Screenshot](https://github.com/yliqi2/pokedex/blob/main/result/searchbar.png)

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yliqi2/pokedex.git
   cd pokedex
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the application:**
   ```sh
   flutter run
   ```

## Dependencies

This project uses the following dependencies:

- `flutter`: The Flutter SDK.
- `http`: For making API requests.

Make sure to check `pubspec.yaml` for the complete list.

## API Usage

This application fetches data from the [PokéAPI](https://pokeapi.co/). It retrieves a list of Pokémon and their details using the following endpoints:

- `https://pokeapi.co/api/v2/pokemon?limit=21&offset=offset_value`
- Individual Pokémon details are fetched from their respective URLs provided in the response.

## Project Structure

```
📂 lib/
├── 📂 model/
│   ├── pokemon.dart
├── 📂 service/
│   ├── pokeapi.dart
├── 📂 widgets/
│   ├── pokemontile.dart
├── 📂 widgets/
│   ├── homescreen.dart
├── main.dart
```

## Contributions

Contributions are welcome! If you find any bugs or have feature suggestions, feel free to open an issue or submit a pull request.

### Author

**Your Name**  
[yliqi2](https://github.com/yliqi2)  


