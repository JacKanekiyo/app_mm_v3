import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/src/lista_itens.dart';
import 'package:app_mm_v3/views/user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 80), // Adiciona um espaçamento à esquerda
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: AppBar().preferredSize.height * 0.6,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundoperfil.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder:
                  (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
                if (authSnapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${authSnapshot.error}'),
                  );
                }

                final User? user = authSnapshot.data;
                if (user == null) {
                  return Container(); // Retorna um container vazio quando o usuário não está autenticado
                }

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${userSnapshot.error}'),
                      );
                    }

                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      final userName = userData['username'];

                      return Container(
                        padding: const EdgeInsets.only(
                            top: 20), // Adiciona espaço no topo do texto
                        child: Center(
                          child: Text('Bem vindo, $userName!',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              )),
                        ),
                      );
                    }

                    return const Center(); // Retorna um container vazio quando não há dados de usuário
                  },
                );
              },
            ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder:
                  (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
                if (authSnapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${authSnapshot.error}'),
                  );
                }

                final User? user = authSnapshot.data;
                if (user == null) {
                  return Container(); // Retorna um container vazio quando o usuário não está autenticado
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('lancamentos')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.hasData) {
                      double totalReceita = 0;
                      double totalDespesa = 0;

                      for (DocumentSnapshot document in snapshot.data!.docs) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        if (data['tipo'] == 'Receita') {
                          totalReceita += data['valor'].toDouble();
                        } else {
                          totalDespesa += data['valor'].toDouble();
                        }
                      }

                      double totalCartao = totalReceita - totalDespesa;

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'TOTAL: R\$ ${totalCartao.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: totalCartao >= 0
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        Text(
                                          'RECEITA: R\$ ${totalReceita.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        Text(
                                          'DESPESA: R\$ ${totalDespesa.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
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
                    return const Center(); // Retorna um container vazio quando não há dados de lançamentos
                  },
                );
              },
            ),
            // Usando o widget ListaItens do arquivo lista_itens.dart
            Expanded(
              child: ListaItens(),
            ),
          ],
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
    );
  }
}
