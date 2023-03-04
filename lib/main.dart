import 'package:appwithfirebase/models/myuser.dart';
import 'package:appwithfirebase/screens/wrapper.dart';
import 'package:appwithfirebase/screens/wrapper2.dart';
import 'package:appwithfirebase/services/auth.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: appBarColor,
            ),
            hintColor: globalTextColor,

            textTheme: TextTheme(
              titleMedium: TextStyle(color: globalTextColor),
                titleSmall: TextStyle(color: globalTextColor),
                displayLarge: TextStyle(color: globalTextColor),
                displayMedium: TextStyle(color: globalTextColor),
                displaySmall: TextStyle(color: globalTextColor),
                headlineLarge: TextStyle(color: globalTextColor),
                headlineMedium: TextStyle(color: globalTextColor),
                headlineSmall: TextStyle(color: globalTextColor),
                bodyLarge: TextStyle(color:globalTextColor),
                bodyMedium: TextStyle(color: globalTextColor),
                bodySmall: TextStyle(color: globalTextColor),
                labelLarge: TextStyle(color: globalTextColor),
                labelMedium: TextStyle(color: globalTextColor),
                labelSmall: TextStyle(color: globalTextColor),

                titleLarge: TextStyle(color: globalTextColor)),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: globalTextColor,
              selectionColor: globalTextColor,
              selectionHandleColor: globalTextColor,
            ),

            primaryColor: globalTextColor,

          ),
        )

    );
  }
}