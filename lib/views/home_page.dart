import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/src/lista_itens.dart';
import 'package:app_mm_v3/views/user_page.dart';
import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MINDS & MONEY', textAlign: TextAlign.center),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.blue,
            child: const Center(
              child: Text('Bem vindo! Jhon Doe!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2, // Ajuste a altura conforme necessário
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TOTAL: R\$ 2580,00',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.arrow_drop_up,
                              color: Colors.green,
                              size: 40,
                            ),
                            Text(
                              'RECEITA: R\$ 1890,00',
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
                              'DESPESA: R\$ -678,00',
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
          ),

          Expanded(
            flex: 11,
            child: Container(
              color: Colors.green,
              child: ListaItens(),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AppWidget(),));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionPage(),));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(fullName: 'EDUARDO FONSECA', nickname: 'DUNHA', email: 'edu@teste.com', avatarUrl: 'https://docservice.com.br/assets/img/PrintSafe/icon%20printsafe%203.svg'),));
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