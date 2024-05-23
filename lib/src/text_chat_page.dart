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

    addMessage(message, true); // Adiciona a mensagem do usuário ao histórico
    _messageController.clear();

    setState(() {
      loading = true;
    });

    // Passa todo o histórico de mensagens para o modelo
    final result = await geminiModel.generateContent(chatHistory);
    
    if (result.text != null) {
      addMessage(result.text!, false); // Adiciona a resposta ao histórico
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
          // Imagem substituindo o AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, // Ajuste a altura conforme necessário
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/retangulo.png"), // Substitua pelo caminho da sua imagem
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0), // Arredonde o canto inferior esquerdo
                  bottomRight: Radius.circular(0), // Arredonde o canto inferior direito
                ),
              ),
              child: Column(
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
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4, // Ajuste o preenchimento conforme necessário
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/chat_background.jpg"), // Substitua pelo caminho da sua imagem
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true, // Para exibir as mensagens de baixo para cima
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUserMessage = index % 2 == 0;
                        return Align(
                          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUserMessage ? Color(0xFF3F8782) : Color(0xFF734B9B),
                              borderRadius: BorderRadius.circular(20), // Arredondar todas as bordas
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              message,
                              style: TextStyle(color: isUserMessage ? const Color.fromARGB(255, 255, 255, 255) : Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (loading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  Divider(height: 1, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40, // Defina a altura desejada
                            child: TextFormField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Digite sua mensagem...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20), // Arredonda todas as bordas
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                          child: FloatingActionButton(
                            onPressed: _sendMessage,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.home, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionPage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.account_circle, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
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
