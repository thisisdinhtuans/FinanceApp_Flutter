import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login/LoginSignup.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();
bool registrationSuccess = false;
void register(String username, email, password) async {
  var client = http.Client();
  try {
    var url = Uri.http('10.0.2.2:5296', '/api/account/register');
    var headers = {'Content-Type': 'application/json'};
    var body = convert.jsonEncode({
      'username': username,
      'email': email,
      'password': password,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Success');
      registrationSuccess = true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (error) {
    print('Error: $error');
  } finally {
    client.close();
  }
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            controller: emailController,
            decoration: InputDecoration(
                hintText: 'email', border: OutlineInputBorder()),
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
            onTap: () {
              register(
                  usernameController.text.toString(),
                  emailController.text.toString(),
                  passwordController.text.toString());
              // Check if registration was successful
              if (registrationSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSignup()),
                );
                // // Navigate to the Login page
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginSignup()),
                // );
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
        ],
      ),
    ));
  }
}
