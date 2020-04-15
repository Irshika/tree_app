
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_app/screens/feed.dart';
import 'package:tree_app/screens/login.dart';

import 'notifier/auth_notifier.dart';

void main() => runApp(
  MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AuthNotifier(),
    )
  ],
    child: MyApp(),
  ));
//app

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child){
          return notifier.user != null? Feed() : Login();
        },
      ),
    );
  }
}
