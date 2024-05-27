import 'package:app_mm_v3/src/icons_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          stream: FirebaseFirestore.instance
              .collection('lancamentos')
              .where('uid', isEqualTo: user.uid)
              .snapshots(),
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
                    String categoria = data['categoria'] ?? 'Desconhecida';
                    String? iconePath = categoriaIconeMap[categoria];

                    double valor = data['valor'].toDouble() * (data['tipo'] == 'Receita' ? 1 : -1);
                    
                    DateTime? date;
                    if (data['data'] != null) {
                      date = (data['data'] as Timestamp).toDate();
                    } else {
                      date = DateTime.now(); // ou qualquer valor padrão que você queira atribuir
                    }
                    String formattedDate = DateFormat('dd/MM/yyyy').format(date!);

                    return Card(
                      child: ListTile(
                        leading: iconePath != null
                            ? Image.asset(
                                iconePath,
                                width: 40,
                                height: 40,
                              )
                            : Icon(
                                Icons.category,
                              ),
                        title: Text(categoria),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['descricao'] ?? ''),
                            Text("Data: $formattedDate"),
                          ],
                        ),
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
