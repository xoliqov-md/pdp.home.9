import 'package:database/firebase_options.dart';
import 'package:database/services/local/shared/auth/auth_service.dart';
import 'package:database/ui/auth/signin.dart';
import 'package:database/ui/main/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Sign In'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget main = const SignInUI();

  @override
  void initState() {
    _startAuth();
    super.initState();
  }

  void _startAuth(){
    Prefs.loadUserId().then((value) => {
      setState(() {
        if(value!.isNotEmpty){
          main = const MainScreen();
        }else{
          main = const SignInUI();
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return main; // This trailing comma makes auto-formatting nicer for build methods.
  }
}

