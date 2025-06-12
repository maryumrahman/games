import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';
import '../../data/services/hive_services.dart';



class LoadUsersGamesProvider extends ChangeNotifier {

  List<MapEntry<int, User>> _myHiveData=[];
  final Set<String> _gameTypes = {'Memory Game', 'TicTacToe', 'Duck Game', 'Words Game'};
  Set<String> get gameTypes => Set.unmodifiable(_gameTypes);
  MapEntry <int, User>? _player1;
  MapEntry <int, User>? _player2;
bool _isLoading=false ;


  List<MapEntry<int, User>> get myHiveData => _myHiveData;

  set myHiveData(List<MapEntry<int, User>> value) {
    _myHiveData = value;
    notifyListeners();
  }
  MapEntry<int, User>? get player2 => _player2;

  set player2(MapEntry<int, User>? value) {
    _player2 = value;
    notifyListeners();
  }

  MapEntry<int, User>? get player1 => _player1;

  set player1(MapEntry<int, User>? value) {
    _player1 = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }




  getHiveData() {
    myHiveData = HiveFunctions.getAllUsers();
  }
  updatePlayers(){
    HiveFunctions.setPlayer1(_player1!.value);
    HiveFunctions.setPlayer2(_player2!.value);
  }


  void addUser(String username) {

    if (!_myHiveData.any((user) => user.value.username == username)) {
      HiveFunctions.addUser(User(username: username, gameWins: {}));
      myHiveData=HiveFunctions.getAllUsers();

    }
  }

  MapEntry<int, User>? getUserEntryByUsername(String username) {
    try {
      return _myHiveData.firstWhere(
            (entry) => entry.value.username == username,
      );
    } catch (e) {
      return null; // No matching user found
    }
  }



  void addWin( String gameName) {
    if (HiveFunctions.hasActivePlayer1() == true){
      User active = HiveFunctions.getPlayer1()!;
      active.gameWins.putIfAbsent(gameName, () => 0);
      active.addWin(gameName);
      HiveFunctions.setPlayer1( active );
      final entry = getUserEntryByUsername( HiveFunctions.getPlayer1()!.username ) ;

      // Update in Hive
      HiveFunctions.updateUser(entry?.key??0,active);

      // Update local list
      myHiveData = HiveFunctions.getAllUsers();



  }}

  List<User> getUsersSortedByWins(String gameName) {
    return _myHiveData
        .map((entry) => entry.value) // extract User
        .toList()
      ..sort((a, b) => b.getWinsForGame(gameName).compareTo(a.getWinsForGame(gameName)));
  }


}