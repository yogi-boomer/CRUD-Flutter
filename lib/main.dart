import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yipiempleado/screens/screens.dart';
import 'package:yipiempleado/services/user_service.dart';


void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => UserService(),)
      ],
      child: MyApp(),);
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner:  false,
      title: 'Usuarios YIPI',
      initialRoute: 'home',
      routes: {
        'login' : (_) => const LoginScreen(),
        'home'  : (_) => HomePage(),
        'user'  : (_) => UserScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const  AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}
