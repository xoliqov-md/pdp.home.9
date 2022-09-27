import 'package:database/services/local/shared/auth/auth_service.dart';
import 'package:database/services/network/firebase/auth/authService.dart';
import 'package:database/ui/main/home_screen.dart';
import 'package:flutter/material.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({Key? key}) : super(key: key);

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {


  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String title = 'SignUp';

  void _doSignUp(){

    String email = _email.text.trim();
    String name = _name.text.trim();
    String password = _password.text.trim();

    AuthService.signUpUser(context, name, email, password).then((value) => {
      // print('UID ::::${value!.uid}')
        title = value!.uid,
        Prefs.saveUserId(value.uid)
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                controller: _name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
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
                      _doSignUp();
                      if(title!='SignUp') {
                        Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const MainScreen()));
                      }
                    }, child: const Text('sign up')),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Do you have an account ?'),
                  const SizedBox(width: 3,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Sign In',
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
