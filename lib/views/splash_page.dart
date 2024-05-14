import 'package:app_mm_v3/auth/sign.dart';
import 'package:app_mm_v3/auth/signup.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MINDS & MONEY', style: TextStyle(
            backgroundColor: Colors.white,
          ),
        ),
      centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fundo.png',
            fit: BoxFit.cover,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.asset('assets/images/ilustracao.png')),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 300, // Largura desejada para os botões
                      height: 50, // Altura desejada para os botões
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignPage(),));                        },
                        child: const Text('Login', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300, // Largura desejada para os botões
                      height: 50, // Altura desejada para os botões
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage(),));
                        },
                        child: const Text('Cadastro', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 40)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
