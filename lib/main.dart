import 'package:customer_list/screens/chat_screen.dart';
import 'package:customer_list/screens/login_screen.dart';

import 'package:customer_list/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(FlashChat());
}
class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(


     //  theme:ThemeData.dark().copyWith(
     //    textTheme: TextTheme(
     //      bodyText2:TextStyle(color: Colors.black54),
     //  ),
     // ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),

        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}


