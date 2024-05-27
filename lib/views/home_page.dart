import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/src/lista_itens.dart';
import 'package:app_mm_v3/views/user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 80),
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
      body: Column(
        children: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (authSnapshot.hasError) {
                return Center(
                  child: Text('Erro: ${authSnapshot.error}'),
                );
              }

              final User? user = authSnapshot.data;
              if (user == null) {
                return Center(
                  child: Text('Nenhum usuário autenticado.'),
                );
              }

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Text('Bem vindo, $userName!',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            )),
                      ),
                    );
                  }

                  return Center(
                    child: Text('Nome do usuário não encontrado.'),
                  );
                },
              );
            },
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (authSnapshot.hasError) {
                return Center(
                  child: Text('Erro: ${authSnapshot.error}'),
                );
              }

              final User? user = authSnapshot.data;
              if (user == null) {
                return Center(
                  child: Text('Nenhum usuário autenticado.'),
                );
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lancamentos')
                    .where('uid', isEqualTo: user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        child: Container(
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
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_up,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                      Text(
                                        'RECEITA: R\$ ${totalReceita.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                      Text(
                                        'DESPESA: R\$ ${totalDespesa.toStringAsFixed(2)}',
                                        style: TextStyle(
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
                  return Center(
                    child: Text('Nenhum lançamento encontrado.'),
                  );
                },
              );
            },
          ),
          // Usando o widget ListaItens do arquivo lista_itens.dart
          ListaItens(),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            color: Color(0xFF3F8782),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppWidget(),
                        ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionPage(),
                        ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage()));
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
