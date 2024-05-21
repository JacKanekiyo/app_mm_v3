import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaItens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (authSnapshot.hasError) {
          return Center(child: Text('Erro: ${authSnapshot.error}'));
        }

        final User? user = authSnapshot.data;
        if (user == null) {
          return Center(child: Text('Nenhum usuário autenticado.'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('lancamentos').where('uid', isEqualTo: user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    IconData icon = data['tipo'] == 'Receita' ? Icons.arrow_drop_up : Icons.arrow_drop_down;
                    Color iconColor = data['tipo'] == 'Receita' ? Colors.green : Colors.red;
                    double valor = data['valor'].toDouble() * (data['tipo'] == 'Receita' ? 1 : -1); // Ajusta o sinal do valor para negativo em caso de despesa
                    return Card(
                      child: ListTile(
                        leading: Icon(icon, color: iconColor),
                        title: Text(data['descricao'] ?? ''),
                        subtitle: Text("Categoria: ${data['categoria'] ?? ''}"),
                        trailing: Text('R\$ ${valor.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
              );
            }
            return Center(child: Text('Nenhum lançamento encontrado.'));
          },
        );
      },
    );
  }
}
