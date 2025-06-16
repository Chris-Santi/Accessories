import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final url = Uri.parse('https://fakestoreapi.com/users');

    final body = {
      "email": _emailController.text.trim(),
      "username": _usernameController.text.trim(),
      "password": _passwordController.text.trim(),
      "name": {"firstname": "John", "lastname": "Doe"},
      "address": {
        "city": "Lagos",
        "street": "5th Avenue",
        "number": 3,
        "zipcode": "110001",
        "geolocation": {"lat": "0", "long": "0"},
      },
      "phone": "09012345678",
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _message = 'Account created successfully!';
        });

        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context); // Return to LoginPage
      } else {
        setState(() {
          _message = 'Signup failed. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_message.isNotEmpty)
              Text(_message, style: TextStyle(color: Colors.green)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : registerUser,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Color(0xffF17547),
              ),
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Color(0xffF17547))
                      : Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
