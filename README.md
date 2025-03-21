# 📖 Pokedex App

A simple 📱 Pokedex application built with Flutter that fetches Pokémon data from the PokéAPI and displays it in a user-friendly interface.

## ✨ Features

- 🔎 **Search Pokémon** by name.
- 🎭 **Filter Pokémon** by types.
- 🔄 **Pull-to-refresh** feature to reload the Pokémon list.
- 🖼️ **Beautiful UI** with grid and list views displaying Pokémon images and names.
- ⚠️ **Error handling** for API requests.
- ⭐ **Favorite Pokémon** functionality with local storage.
- 🔔 **Notifications** for favorite Pokémon changes.
- 🎲 **Random Pokémon** details button.
- 🔀 **Toggle grid & list views**.
- 🌙 **Dark mode & light mode** theme switching.

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/yliqi2/pokedex/blob/main/result/mainui.png" alt="Pokedex Screenshot 1" width="250" />
  <img src="https://github.com/yliqi2/pokedex/blob/main/result/details.png" alt="Pokedex Screenshot 2" width="250" />
  <img src="https://github.com/yliqi2/pokedex/blob/main/result/poisonbyid.png" alt="Pokedex Screenshot 3" width="250" />
</p>

<p align="center">
  🔗 <a href="https://github.com/yliqi2/pokedex/blob/main/result/">View all screenshots</a>
</p>

## 🛠 Installation

1. **📥 Clone the repository:**
   ```sh
   git clone https://github.com/yliqi2/pokedex.git
   cd pokedex
   ```

2. **📦 Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **▶️ Run the application:**
   ```sh
   flutter run
   ```

## 🚀 Technologies Used & Dependencies

### 🔹 Technologies Used

- 🎯 **[Flutter](https://flutter.dev/)** - Google’s UI toolkit for building beautiful apps.
- 💻 **[Dart](https://dart.dev/)** - The programming language used by Flutter.

### 📦 Dependencies

- `flutter` - Flutter SDK.
- `http` - Fetch data from PokéAPI.
- `shared_preferences` - Store favorite Pokémon locally.
- `flutter_local_notifications` - Display local notifications.

Check `pubspec.yaml` for a full list. 📜

## 🔗 API Usage

- **📜 List of Pokémon:** `https://pokeapi.co/api/v2/pokemon?limit=1302`
  - Retrieves all available Pokémon.
- **📊 Pokémon Details:** `https://pokeapi.co/api/v2/pokemon/{name}`
  - Fetches details such as ID, types, stats, and images.

## 🎲 Random Pokémon Button

Press the 🎲 button to view details of a random Pokémon!

## 🎨 Grid View & List View

Easily switch between 📌 grid and 📜 list views using the toggle button in the app bar.

## 🌗 Theme Change

Toggle between 🌞 **light mode** and 🌙 **dark mode** for better viewing experience.

## 🔍 Search & Filtering

- 🔎 **Search** Pokémon by name.
- 🏷️ **Filter** Pokémon by type.

## 📂 Project Structure

```
📂 lib/
├── 📂 model/
│   ├── basic_pokemon.dart
│   ├── pokemon.dart
├── 📂 service/
│   ├── connectivity.dart
│   ├── noti_service.dart
│   ├── pokeapi.dart
│   ├── shared_prefs.dart
├── 📂 widgets/
│   ├── pokemontile.dart
│   ├── pokemonlisttile.dart
├── 📂 screen/
│   ├── homescreen.dart
│   ├── pokemondetail.dart
├── main.dart
```
<p align="right">
  <a href="https://github.com/yliqi2/pokedex/archive/refs/heads/main.zip" target="_blank">
    <img src="https://img.shields.io/badge/Download-Pokedex%20App-blue?style=for-the-badge&logo=flutter" alt="Download Button">
  </a>
</p>

## 🤝 Contributions

Contributions are welcome! If you find any bugs 🐛 or have feature suggestions 💡, feel free to open an issue or submit a pull request.
## 📥 Download


## 👤 Author

[![yliqi2 GitHub](https://img.shields.io/badge/Visit%20yliqi2%20on%20GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yliqi2)

