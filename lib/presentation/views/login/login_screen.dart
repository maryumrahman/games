import 'package:flutter/material.dart';
import 'package:games/data/services/hive_services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user.dart';
import '../../../state_management/providers/games_user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New User'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              final provider = context.read<LoadUsersGamesProvider>();
              if (provider.myHiveData
                  .any((user) => user.value.username == value)) {
                return 'Username already exists';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<LoadUsersGamesProvider>(context, listen: false)
                    .addUser(_usernameController.text);
                _usernameController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  choosePlayerBox(int i) {
    return Consumer<LoadUsersGamesProvider>(
      builder: (context, provider, child) {
        return  SizedBox(
          width:  MediaQuery.of(context).size.width * 0.41,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
              children: [
                Icon(
                  Icons.person_outline,
                  size:  MediaQuery.of(context).size.width * 0.1,
                  color: Colors.teal,
                ),
                const SizedBox(height: 24),
                i == 1
                    ? DropdownButtonFormField<MapEntry<int, User>?>(
                        value:


                        HiveFunctions.hasActivePlayer1() == false
                            ? null
                            : provider.myHiveData.firstWhere((MapEntry entry) {
                                return
                                  entry.value.username ==
                                    HiveFunctions.getPlayer1()!.username;
                              }),
                        decoration: InputDecoration(
                          labelText: 'Select Username',
                          border: OutlineInputBorder(),
                        ),
                        items: provider.myHiveData.map((entry) {
                          return DropdownMenuItem(
                            value: entry,
                            child: Text(entry.value.username),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.player1 = value;
                        },
                      )
                    : DropdownButtonFormField<MapEntry<int, User>?>(
                        value: HiveFunctions.hasActivePlayer2() == false
                            ? null
                            : provider.myHiveData.firstWhere((MapEntry entry) {
                                return entry.value.username ==
                                    HiveFunctions.getPlayer2()!.username;
                              }),
                        decoration: InputDecoration(
                          labelText: 'Select Username',
                          border: OutlineInputBorder(),
                        ),
                        items: provider.myHiveData.map((entry) {
                          return DropdownMenuItem(
                            value: entry,
                            child: Text(entry.value.username, ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.player2 = value;
                        },
                      ),
              ],
            ),),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    choosePlayerBox(1), choosePlayerBox(2),
                    ]),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          final prov = Provider.of<LoadUsersGamesProvider>(context,
                              listen: false);
                          if( prov .player1 == null || prov .player2 == null ){ debugPrint("hivereturn");
                           return ;}
                          if(prov .player2 == prov.player1 ) { debugPrint("hivereturn turn");
                          AlertDialog(
                            title: Text("Choose two players!"),
                          ); return;
                          }
                          Provider.of<LoadUsersGamesProvider>(context,
                                  listen: false)
                              .updatePlayers();
                          AlertDialog(
                            title: Text("Updated! Now Start Playing!"),
                          );
                          debugPrint("hivesaved");
                        },
                        child: Text("Submit")),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _showAddUserDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Create New User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
