import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:app_mm_v3/views/user_page.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TextChatPage extends StatefulWidget {
  const TextChatPage({Key? key});

  @override
  State<TextChatPage> createState() => _TextChatPageState();
}

class _TextChatPageState extends State<TextChatPage> {
  late final GenerativeModel geminiModel;
  var loading = false;
  var messages = <String>[];
  var chatHistory = <Content>[];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 12, 137, 104),
        title: Text(
          'Fale com a MiMi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Adiciona a imagem de fundo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/chat_background.jpg"), // Substitua pelo caminho da sua imagem
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true, // Para exibir as mensagens de baixo para cima
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = index % 2 == 0;
                    return Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Color.fromARGB(255, 194, 230, 195)
                              : Color.fromARGB(255, 12, 137, 104),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: isUserMessage
                                ? Radius.circular(12)
                                : Radius.circular(0),
                            bottomRight: isUserMessage
                                ? Radius.circular(0)
                                : Radius.circular(12),
                          ),
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
                          style: TextStyle(
                              color:
                                  isUserMessage ? Colors.black : Colors.white),
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
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Digite sua mensagem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.green.shade50,
                        ),
                        onFieldSubmitted: (value) async {
                          addMessage(value,
                              true); // Adiciona a mensagem do usuário ao histórico
                          setState(() {
                            loading = true;
                          });

                          // Passa todo o histórico de mensagens para o modelo
                          final result =
                              await geminiModel.generateContent(chatHistory);

                          if (result.text != null) {
                            addMessage(result.text!,
                                false); // Adiciona a resposta ao histórico
                          }

                          setState(() {
                            loading = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Color.fromARGB(255, 12, 137, 104),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                color: Color.fromARGB(255, 12, 137, 104),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTransactionPage(),
                            ));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.account_circle, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                  fullName: 'EDUARDO FONSECA',
                                  nickname: 'DUNHA',
                                  email: 'edu@teste.com',
                                  avatarUrl:
                                      'https://docservice.com.br/assets/img/PrintSafe/icon%20printsafe%203.svg'),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
