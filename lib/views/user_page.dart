import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(50.0), // Ajuste conforme necessário
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 60, // Ajuste a altura conforme necessário
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        color: const Color(0xFF3F8782),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppWidget(),
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
                    builder: (context) => const AddTransactionPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/fundoperfil.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            top: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: 0, // Ajuste a altura conforme necessário
                child: StreamBuilder<DocumentSnapshot>(
                  stream: user != null
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots()
                      : null,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final username = userData['username'] ?? '';
                      final email = userData['email'] ?? '';

                      // Verifica se o nome do usuário não está vazio
                      /*if (username != null && username.isNotEmpty)*/ {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userData['profilePictureUrl'] ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10), // Aumenta o espaçamento
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey, // Alterado para cinza
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Implemente a ação de editar perfil
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF3F8782),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                              ),
                              child: const Text('Editar Perfil'),
                            ),
                          ],
                        );
                      }
                    }

                    return const Center(
                      child: Text('Dados do usuário não encontrados.',
                          style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
