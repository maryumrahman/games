import 'package:hive_flutter/hive_flutter.dart';
import '../infrastructure/utils/app_strings.dart';
import '../models/user.dart';



class HiveServices {


  static final allBox = Hive.box<User>(AppStrings().allUserBox);
  static final box2 = Hive.box<  User>(AppStrings().player1Box);
  static final box3 = Hive.box< User>(AppStrings().player2Box);



    static List<MapEntry<int, User>> getAllUsers() {
      return allBox.toMap().entries.map((entry) => MapEntry(entry.key as int, entry.value )).toList();
    }

  static Future<void> addUser(User user) async {
    await allBox.add(user);
  }
  static Future<void> deleteUser(int key) async {
    await allBox.delete(key);
  }
  static Future<void> deleteAllUsers() async {
    await allBox.clear();
  }

  static Future<void> updateUser(int key, User user) async {
    await allBox.put(key,user);
  }

  // Set active user
  static Future<void> setPlayer1(User user) async {
    await box2.put('active', user);
  }

  // Get active user
  static   User? getPlayer1() {
    return box2.get('active');
  }

  // Remove active user
  static Future<void> clearPlayer1() async {
    await box2.delete('active');
  }

  // Check if active user exists
  static bool hasActivePlayer1() {
    return box2.containsKey('active');
  }

  // Set active user
  static Future<void> setPlayer2( User user) async {
    await box3.put('active', user);
  }

  // Get active user
  static   User? getPlayer2() {
    return box3.get('active');
  }

  // Remove active user
  static Future<void> clearPlayer2() async {
    await box3.delete('active');
  }

  // Check if active user exists
  static bool hasActivePlayer2() {
    return box3.containsKey('active');
  }


  void incrementPlayerWin( String gameName, int player ) {
    if (player == 1 ){
      if (HiveServices.hasActivePlayer1() ){

        User user = HiveServices.getPlayer1()!;
        user. gameWins.putIfAbsent(gameName, () => 0);
        user.addWin(gameName);
        // Update in Hive's Player1Box
        HiveServices.setPlayer1( user );

        // Update in Hive's AllUsersBox
        final allEntry = HiveServices.getAllUsers().firstWhere((entry)=> entry.value.username==user. username);
        HiveServices.updateUser(allEntry.key,user);

      }
    }else if(player==2) {
      if (HiveServices.hasActivePlayer2() ){

        User user = HiveServices.getPlayer2()!;
        user. gameWins.putIfAbsent(gameName, () => 0);
        user.addWin(gameName);
        // Update in Hive's Player1Box
        HiveServices.setPlayer2( user );

        // Update in Hive's AllUsersBox
        final allEntry = HiveServices.getAllUsers().firstWhere((entry)=> entry.value.username==user. username);
        HiveServices.updateUser(allEntry.key,user);
      }

    }}



}