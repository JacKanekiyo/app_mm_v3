import 'package:app_mm_v3/views/home_page.dart';
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

  @override
  void initState() {
    super.initState();
    geminiModel = GenerativeModel(
        model: 'gemini-1.0-pro',
        apiKey: 'AIzaSyASJpDWFpmKHNSdMRgtmIy49g_KlZ9phdc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Para exibir as mensagens de baixo para cima
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message),
                  dense: true,
                );
              },
            ),
          ),
          Visibility(
            visible: loading,
            child: const CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onFieldSubmitted: (value) async {
                final prompt = [Content.text(value)];
                setState(() {
                  loading = true;
                });
                final result = await geminiModel.generateContent(prompt);
                setState(() {
                  messages.insert(0, result.text ?? ''); // Adiciona a resposta no início da lista
                  messages.insert(0, value); // Adiciona a pergunta no início da lista
                  loading = false;
                });
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Implementar ação para lançamento de despesa ou receita
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    // Implementar a navegação para o perfil do usuário
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
