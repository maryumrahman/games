import 'package:flutter/material.dart';
import 'package:games/presentation/views/main_screen.dart';
import 'package:games/state_management/providers/games_user_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'data/models/user.dart';
import 'data/utils/app_constants.dart';




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>(allUserBox);
  await Hive.openBox<User>(player1Box);
  await Hive.openBox<User>(player2Box);

  runApp(
    ChangeNotifierProvider(
      create: (_) => LoadUsersGamesProvider()..getHiveData(),
      child: const GamesApp(),
    ),
  );
}

class GamesApp extends StatelessWidget {
  const GamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Game Center',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavScreen(),
    );
  }
}
