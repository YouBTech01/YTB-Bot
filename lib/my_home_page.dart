import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.handleBrightnessChange,
    required this.useLightMode,
  });
  final String title;
  final bool useLightMode;
  final void Function(bool useLightMode) handleBrightnessChange;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'You', 'message': message});
      _isLoading = true;
    });
    _messageController.clear();

    final response = await _getAIResponse(message);

    setState(() {
      _messages.add({'sender': 'AI', 'message': response});
      _isLoading = false;
    });
  }

  Future<String> _getAIResponse(String message) async {
    const url =
        'https://backend.buildpicoapps.com/aero/run/llm-api?pk=v1-Z0FBQUFBQm0zRjd0Mlpqb1NzYm5sM0VRU2c2WHF1MlpkZENKUEVOR043VnBlZDhBOFBpQ09VWmtjYUt3SzFGRGplbkxEaUhyMXhzT3VXV0ktVnhOWWFWQVR2d2gzZHkyN1E9PQ==';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'prompt': message}),
      );
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        return data['text'];
      } else {
        return 'An error occurred while getting a response from the AI.';
      }
    } catch (error) {
      print('Fetch error: $error');
      return 'Failed to fetch AI response. Please check your network connection.';
    }
  }

  void _restartApp() {
    // Code to restart the app
  }

  void _onLongPressMessage(String message) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy,
          offset.dx + renderBox.size.width, offset.dy + renderBox.size.height),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              Share.share(message);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _BrightnessButton(
            handleBrightnessChange: widget.handleBrightnessChange,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _restartApp,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return GestureDetector(
                  onLongPress: () => _onLongPressMessage(message['message']!),
                  child: Align(
                    alignment: message['sender'] == 'You'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'You'
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '${message['sender']}: ${message['message']}',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary),
              backgroundColor:
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Type your message...',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).colorScheme.primary,
                  iconSize: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton({
    required this.handleBrightnessChange,
    this.showTooltipBelow = true,
  });

  final Function handleBrightnessChange;
  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () => handleBrightnessChange(!isBright),
      ),
    );
  }
}
