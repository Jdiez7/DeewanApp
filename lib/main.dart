import 'package:appwithfirebase/Project2/Search/Xallvocabs.dart';
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
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: globalTextColor,
              displayColor: globalTextColor,
            ),
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: Colors.black,),
            primaryColor: Colors.black,// Change bubble to red
            
          ),
        )

    );
  }
}