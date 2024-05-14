import 'package:flutter/material.dart';

import 'item.dart';

class ListaItens extends StatelessWidget {
  const ListaItens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de itens
    List<Item> listaDeItens = [
      Item(
        icone: Icons.category,
        categoria: 'Categoria 1',
        descricao: 'Descrição do item 1',
        valor: 'R\$ 10,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 2',
        descricao: 'Descrição do item 2',
        valor: 'R\$ 20,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 3',
        descricao: 'Descrição do item 3',
        valor: 'R\$ 30,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 4',
        descricao: 'Descrição do item 4',
        valor: 'R\$ 40,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 5',
        descricao: 'Descrição do item 5',
        valor: 'R\$ 50,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 6',
        descricao: 'Descrição do item 6',
        valor: 'R\$ 60,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
      Item(
        icone: Icons.category,
        categoria: 'Categoria 7',
        descricao: 'Descrição do item 7',
        valor: 'R\$ 70,00',
        data: DateTime.now(), // Adicionando a data atual
      ),
    ];

    // Construindo a lista de itens
    return ListView.builder(
      itemCount: listaDeItens.length,
      itemBuilder: (context, index) {
        var item = listaDeItens[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 2.0), // Adicionando espaçamento
          child: Container(
            color: Colors.white, // Cor de fundo do ListTile
            child: ListTile(
              leading: Icon(item.icone),
              title: Text(item.categoria),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.descricao),
                  Text("Data: ${item.data.day}/${item.data.month}/${item.data.year}"), // Exibindo a data
                ],
              ),
              trailing: Text(item.valor),
            ),
          ),
        );
      },
    );
  }
}
