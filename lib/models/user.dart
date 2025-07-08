import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 1, adapterName:  'UserAdapter' )
class User {
  @HiveField(0)
  final String username;
  @HiveField(1)
  Map<String, int> gameWins;

  User({
    required this.username,
    Map<String, int>? gameWins,
  }) : gameWins = gameWins ?? {};



  User copyWith({
    String? username,
    Map<String, int>? gameWins,
  }) {
    return User(
      username: username ?? this.username,
      gameWins: gameWins ?? Map.from(this.gameWins),
    );
  }



  int getWinsForGame(String gameName) {
    return gameWins[gameName] ?? 0;
  }

  void addWin(String gameName) {
    gameWins[gameName] = (gameWins[gameName] ?? 0) + 1;
    debugPrint("GAME $gameName ${gameWins[gameName]}  ");

  }


} 