import 'package:database/services/local/shared/auth/auth_service.dart';
import 'package:database/services/network/firebase/auth/authService.dart';
import 'package:database/ui/auth/signup.dart';
import 'package:database/ui/main/home_screen.dart';
import 'package:flutter/material.dart';

class SignInUI extends StatefulWidget {
  static const String id = "sign_in_ui";
  const SignInUI({Key? key}) : super(key: key);

  @override
  State<SignInUI> createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String title = 'SignUp';

  _doSignIn() async{
    bool s = true;
    String email = _email.text.trim();
    String password = _password.text.trim();
    AuthService.signInUser(context, email, password).then((value) => {
      Prefs.saveUserId(value!.uid),
      title = value.uid
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
                obscureText: true,
                controller: _password,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 35,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _doSignIn();
                      setState(() {
                        if(title!='SignIn'){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MainScreen()));
                        }
                      });
                    }, child: const Text('sign in')),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Didn\'t have an account ?'),
                  const SizedBox(width: 3,),
                  GestureDetector(
                    onTap: () {
                      // /// Send message via Telegram
                      // Telegram.send(
                      //     username:'uzcoder',
                      //     message:'Thanks for building Telegram Package :)'
                      // );
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpUI()));
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.blue
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
