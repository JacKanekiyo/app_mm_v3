import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: null, // Removendo o título da barra de navegação
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots()
            : null,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final username = userData['username'] ?? '';
            final email = userData['email'] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                      fit: BoxFit.contain, // Ajuste aqui para evitar o zoom
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *
                      0.25, // Altura ajustada para 25% da tela
                ),
                SizedBox(height: 20),
                Text(
                  username,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Color(0xFF3F8782),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          // Implemente a ação do botão conforme necessário
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // Implemente a ação do botão conforme necessário
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () {
                          // Implemente a ação do botão conforme necessário
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Text('Dados do usuário não encontrados.'),
          );
        },
      ),
    );
  }
}
