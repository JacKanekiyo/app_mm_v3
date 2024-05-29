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

<<<<<<< HEAD
    addMessage(message, true); // Adiciona a mensagem do usuário ao histórico
=======
    addMessage(message, true);
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
    _messageController.clear();

    setState(() {
      loading = true;
    });

<<<<<<< HEAD
    // Passa todo o histórico de mensagens para o modelo
    final result = await geminiModel.generateContent(chatHistory);
    
    if (result.text != null) {
      addMessage(result.text!, false); // Adiciona a resposta ao histórico
=======
    final result = await geminiModel.generateContent(chatHistory);

    if (result.text != null) {
      addMessage(result.text!, false);
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
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
<<<<<<< HEAD
          // Imagem substituindo o AppBar
=======
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
<<<<<<< HEAD
              height: MediaQuery.of(context).size.height * 0.3, // Ajuste a altura conforme necessário
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/nav.png"), // Substitua pelo caminho da sua imagem
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

=======
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
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
                ],
              ),
            ),
          ),
          Positioned.fill(
<<<<<<< HEAD
            top: MediaQuery.of(context).size.height * 0.4, // Ajuste o preenchimento conforme necessário
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/chat_background.p"), // Substitua pelo caminho da sua imagem
                  fit: BoxFit.cover,
                ),
              ),
=======
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: const BoxDecoration(),
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
<<<<<<< HEAD
                      reverse: true, // Para exibir as mensagens de baixo para cima
=======
                      reverse: true,
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUserMessage = index % 2 == 0;
<<<<<<< HEAD
                        return Align(
                          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isUserMessage) 
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage("assets/images/icon2.png"), // Substitua pelo caminho da sua imagem
                                ),
                              SizedBox(width: 8),
                              Container(
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
                                  style: TextStyle(color: isUserMessage ? Colors.white : Colors.white),
                                ),
                              ),
                              if (isUserMessage)
                                SizedBox(width: 8),
                              if (isUserMessage)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage("assets/images/user_avatar.png"), // Substitua pelo caminho da sua imagem
                                ),
                            ],
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
                                  borderRadius: BorderRadius.circular(10), // Arredonda todas as bordas
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
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
=======
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
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
                            ),
                          ),
                          child: FloatingActionButton(
                            onPressed: _sendMessage,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
<<<<<<< HEAD
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
=======
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    color: const Color(0xFF3F8782),
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
<<<<<<< HEAD
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(
                            
                            )));
=======
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
>>>>>>> 0f8867f44b93fca4b18e3a2baf3a0e0e22265c8b
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
