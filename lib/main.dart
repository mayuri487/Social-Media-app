import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './Screens/auth_screen.dart';
import './Screens/tabs_screen.dart';
import './Screens/edit_account_screen.dart';
import './Screens/account_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapshot) {
             if(userSnapshot.hasData){
              return TabsScreen();
            }
            return AuthScreen();
          },
        ),
      routes: {
        '/editaccountScreen': (ctx) => EditAccountScreen(),
        '/accountScreen': (ctx) => ProfileScreen()
      },
    );
  }
}