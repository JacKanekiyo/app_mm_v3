import 'package:app_mm_v3/auth/signup.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Login bem-sucedido, navegue para a página inicial
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // Login falhou, exiba uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro de login: ${e.message}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(
              top: 20), // Ajuste para descer a imagem e o texto
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 60), // Adicionado espaço extra
                  Container(
                    height: 210, // Ajuste a altura conforme necessário
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cadeado.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // Adicionado espaço extra
                  Column(
                    children: <Widget>[
                      inputFile(
                          label: "Email", textController: emailController),
                      SizedBox(height: 10),
                      inputFile(
                        label: "Senha",
                        obscureText: true,
                        textController: passwordController,
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Adicionado espaço extra
                  Container(
                    width: 200, // Defina a largura desejada aqui
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: MaterialButton(
                      height: 50, // Defina a altura desejada aqui
                      onPressed: () async {
                        await _signInWithEmailAndPassword(context);
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Não tem uma conta?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: Text(
                          " Cadastre-se",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para campo de texto
Widget inputFile(
    {required String label,
    bool obscureText = false,
    required TextEditingController textController}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        width: 300, // Defina a largura desejada aqui
        child: TextField(
          controller: textController,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // Bordas arredondadas
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // Bordas arredondadas
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // Bordas arredondadas
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}
