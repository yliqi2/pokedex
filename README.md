# Pokedex App

A simple Pokedex application built with Flutter that fetches Pokémon data from the PokéAPI and displays it in a user-friendly interface.

## Features

- Infinite scrolling to load more Pokémon as you scroll.
- Search functionality to find Pokémon by name.
- Pull-to-refresh feature to reload the Pokémon list.
- Beautiful grid-based UI with Pokémon images and names.
- Error handling for API requests.

## Screenshots

<p align="center">
  <img src="https://github.com/yliqi2/pokedex/blob/main/result/mainscreen.png" alt="Pokedex Screenshot" />
</p>



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

## Technologies Used & Dependencies

### Technologies Used

- **[Flutter](https://flutter.dev/)**: An open-source mobile application development framework created by Google. It uses the Dart programming language to build native apps for iOS and Android with a single codebase.

- **[Dart](https://dart.dev/)**: A programming language developed by Google, used to write mobile, web, and server applications. It is the base language on which Flutter runs.

- **[http](https://pub.dev/packages/http)**: A Dart package used to make HTTP requests. It allows making network requests, such as those used to fetch data from the PokéAPI in this project.

### Dependencies

This project uses the following dependencies:

- `flutter`: The Flutter SDK, used for building the mobile application.
- `http`: A package to make HTTP requests to retrieve data from external APIs (in this case, PokéAPI).

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

## Author

[![yliqi2 GitHub](https://img.shields.io/badge/Visit%20yliqi2%20on%20GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yliqi2)



