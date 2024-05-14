import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/src/lista_itens.dart';
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
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      color: Colors.white,
                      child: Center(
                        child: Text('TOTAL: R\$ -678,00'),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  flex: 4,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      color: Colors.white,
                      child: Center(
                        child: Text('TOTAL: R\$ 1890,00'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('TOTAL: R\$ 2580,00'),
              ],
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