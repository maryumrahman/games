import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../services/hive_services.dart';



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
    myHiveData = HiveServices.getAllUsers();
  }

  updatePlayers(){
    HiveServices.setPlayer1(_player1!.value);
    HiveServices.setPlayer2(_player2!.value);
  }


  void addUser(String username) {

    if (!_myHiveData.any((user) => user.value.username == username)) {
      HiveServices.addUser(User(username: username, gameWins: {}));
      myHiveData=HiveServices.getAllUsers();

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





  List<User> getUsersSortedByWins(String gameName) {
    return _myHiveData
        .map((entry) => entry.value) // extract User
        .toList()
      ..sort((a, b) => b.getWinsForGame(gameName).compareTo(a.getWinsForGame(gameName)));
  }


}