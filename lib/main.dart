import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  bool get useLightMode {
    switch (_themeMode) {
      case ThemeMode.system:
        return SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AI Chatbot',
          theme: ThemeData.from(
            colorScheme: lightColorScheme ??
                ColorScheme.fromSeed(
                  seedColor: Colors.teal,
                  brightness: Brightness.light,
                ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.from(
            colorScheme: darkColorScheme ??
                ColorScheme.fromSeed(
                  seedColor: Colors.teal,
                  brightness: Brightness.dark,
                ),
            useMaterial3: true,
          ),
          themeMode: _themeMode,
          home: _isLoading
              ? WelcomeScreen()
              : MyHomePage(
                  title: 'AI Chatbot',
                  useLightMode: useLightMode,
                  handleBrightnessChange: (useLightMode) => setState(() {
                    _themeMode =
                        useLightMode ? ThemeMode.light : ThemeMode.dark;
                  }),
                ),
        );
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.network(
              'https://example.com/your-logo.png', // Replace with your logo URL
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            // Headline
            Text(
              'Welcome to AI Chatbot',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            // Progress Bar
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
