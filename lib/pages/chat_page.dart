import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'message': _controller.text,
      });
    });

    _controller.clear();

    try {
      final response = await _getChatGPTResponse(_controller.text);

      if (response != null) {
        setState(() {
          _messages.add({
            'sender': 'gpt',
            'message': response,
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'gpt',
          'message': 'Ошибка: не удалось получить ответ.',
        });
      });
    }
  }

  Future<String?> _getChatGPTResponse(String userMessage) async {
    final apiKey = 'YOUR_OPENAI_API_KEY'; // Вставь свой ключ API
    final url = Uri.parse('https://api.openai.com/v1/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'text-davinci-003',
        'prompt': userMessage,
        'max_tokens': 100,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to load response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Чат GPT-3', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: const Color(0xFFB71C1C),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['sender'] == 'user';
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.white : Colors.red.shade800,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(isUserMessage ? 'Ты' : 'GPT', style: const TextStyle(color: Colors.red)),
                      ),
                      title: Text(
                        message['message'] ?? '',
                        style: TextStyle(color: isUserMessage ? Colors.black : Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildTextInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.red.shade800,
                hintText: 'Введите сообщение...',
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
