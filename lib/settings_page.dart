import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dynamic_color/dynamic_color.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  ColorScheme _currentColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  );

  @override
  void initState() {
    super.initState();
    _isDarkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('About This App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Developed by Your Name'),
              Text('Email: your-email@gmail.com'),
              GestureDetector(
                onTap: () => _launchURL('https://www.youtube.com/your-channel'),
                child: Text('YouTube: Your Channel',
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  _currentColorScheme = ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness:
                        _isDarkMode ? Brightness.dark : Brightness.light,
                  );
                });
              },
            ),
            ListTile(
              title: Text('Color Palette'),
              subtitle: Text('Choose a color palette'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Tonal Spot'),
                          onTap: () {
                            setState(() {
                              _currentColorScheme = ColorScheme.fromSeed(
                                seedColor: Colors.teal,
                                brightness: _isDarkMode
                                    ? Brightness.dark
                                    : Brightness.light,
                                primary: Colors.teal,
                              );
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Neutral'),
                          onTap: () {
                            setState(() {
                              _currentColorScheme = ColorScheme.fromSeed(
                                seedColor: Colors.teal,
                                brightness: _isDarkMode
                                    ? Brightness.dark
                                    : Brightness.light,
                                primary: Colors.grey,
                              );
                            });
                            Navigator.pop(context);
                          },
                        ),
                        // Add more palette options as needed
                      ],
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Font Size'),
              subtitle: Text('Adjust font size'),
              trailing: Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('About'),
              onTap: _showAboutDialog,
            ),
          ],
        ),
      ),
    );
  }
}
