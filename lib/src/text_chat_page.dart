import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:app_mm_v3/views/user_page.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextChatPage extends StatefulWidget {
  const TextChatPage({Key? key}) : super(key: key);

  @override
  State<TextChatPage> createState() => _TextChatPageState();
}

class _TextChatPageState extends State<TextChatPage> {
  late final GenerativeModel geminiModel;
  var loading = false;
  var messages = <String>[];
  var chatHistory = <Content>[];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    geminiModel = GenerativeModel(
      model: 'gemini-1.0-pro',
      apiKey: 'AIzaSyASJpDWFpmKHNSdMRgtmIy49g_KlZ9phdc',
    );
  }

  void addMessage(String message, bool isUserMessage) {
    setState(() {
      messages.insert(0, message);
      chatHistory.add(Content.text(message));
    });
  }

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isEmpty) return;

    addMessage(message, true);
    _messageController.clear();

    setState(() {
      loading = true;
    });

    final result = await geminiModel.generateContent(chatHistory);

    if (result.text != null) {
      addMessage(result.text!, false);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/retangulo.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seja Bem Vindo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fale com a MiMi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUserMessage = index % 2 == 0;
                        return Row(
                          mainAxisAlignment: isUserMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? const Color(0xFF3F8782)
                                    : const Color(0xFF734B9B),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: isUserMessage
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  const Divider(height: 1, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Digite sua mensagem...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                          ),
                          child: FloatingActionButton(
                            onPressed: _sendMessage,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: const Color(0xFF3F8782),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddTransactionPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.account_circle),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserProfilePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
