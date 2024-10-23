import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo here
            Image.network('https://via.placeholder.com/150'),
            SizedBox(height: 20),
            Text(
              'Welcome to AI Chatbot',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
