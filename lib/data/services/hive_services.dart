import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../utils/app_constants.dart';



class HiveFunctions {

  static final allUsersBox = Hive.box<User>(userHiveBox);
  static final player1Box = Hive.box<User>('player1UserBox');
  static final player2Box = Hive.box<User>('player2UserBox');


  static List<MapEntry<int, User>> getAllUsers() {
    return (allUsersBox.toMap() as Map<int, User>).entries.toList();
  }
  static List<User> getAllUsersNoKey() {
    return allUsersBox.values.cast<User>().toList();
  }

  static Future<void> addUser(User user) async {
    await allUsersBox.add(user);
  }
  static Future<void> deleteUser(int key) async {
    await allUsersBox.delete(key);
  }
  static Future<void> deleteAllUsers() async {
    await allUsersBox.clear();
  }

  static Future<void> updateUser(int key, User user) async {
    await allUsersBox.put(key,user);
  }

  // Set active user
  static Future<void> setPlayer1(User user) async {
    await player1Box.put('active', user);
  }

  // Get active user
  static User? getPlayer1() {
    return player1Box.get('active');
  }

  // Remove active user
  static Future<void> clearPlayer1() async {
    await player1Box.delete('active');
  }

  // Check if active user exists
  static bool hasActivePlayer1() {
    return player1Box.containsKey('active');
  }

  // Set active user
  static Future<void> setPlayer2(User user) async {
    await player2Box.put('active', user);
  }

  // Get active user
  static User? getPlayer2() {
    return player2Box.get('active');
  }

  // Remove active user
  static Future<void> clearPlayer2() async {
    await player2Box.delete('active');
  }

  // Check if active user exists
  static bool hasActivePlayer2() {
    return player2Box.containsKey('active');
  }





}