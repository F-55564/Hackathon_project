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

    final userText = _controller.text;

    setState(() {
      _messages.add({
        'sender': 'user',
        'message': userText,
      });
    });

    _controller.clear();

    try {
      final response = await _getChatGPTResponse(userText);

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
    final apiKey = 'YOUR_OPENAI_API_KEY'; // Замени на свой ключ
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
      throw Exception('Ошибка API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red.shade800,
        elevation: 0,
        title: const Text('Nomad Jarvis', style: TextStyle(color: Colors.white)),
      ),
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
                      color: isUserMessage ? Colors.red.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUserMessage ? Colors.red.shade300 : Colors.grey.shade400,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade800,
                        child: Text(
                          isUserMessage ? 'Ты' : 'J',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        message['message'] ?? '',
                        style: const TextStyle(color: Colors.black87),
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
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: 'Введите сообщение...',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.red.shade800),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}