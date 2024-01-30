import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login/FirstPage.dart';
import 'package:login/Register.dart';
import 'package:login/main.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isSuccess = false;
Future<bool> login(String username, String password) async {
  var client = http.Client();
  try {
    var url = Uri.http('10.0.2.2:5296', '/api/account/login');
    var headers = {'Content-Type': 'application/json'};
    var body = convert.jsonEncode({
      'username': username,
      'password': password,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Success');
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  } finally {
    client.close();
  }
}

class _LoginSignupState extends State<LoginSignup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Add a GlobalKey to the Scaffold
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'username', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  bool loginSuccess = await login(
                    usernameController.text.toString(),
                    passwordController.text.toString(),
                  );

                  if (loginSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                    // loginUser(usernameController.text.toString());
                  } else {
                    // Show a SnackBar if login is unsuccessful
                    const snackBar = SnackBar(
                      content: Text('Error Account or Password'),
                    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add some spacing between buttons
              GestureDetector(
                onTap: () {
                  // Navigate to the Register page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue, // You can change the color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
