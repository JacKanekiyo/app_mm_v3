import 'package:flutter/material.dart';

class Transaction {
  final String category;
  final String descricao;
  final String valor;
  final DateTime data;
  final bool isIncome;
  final String tipo; // Adicionando o campo tipo

  Transaction({
    required this.category,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.isIncome,
    required this.tipo, // Atualizando o construtor
  });
}

class Item {
  final IconData icone;
  final String categoria;
  final String descricao;
  final String valor;
  final DateTime data;
  final String tipo; // Adicionando o campo tipo

  Item({
    required this.icone,
    required this.categoria,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipo, // Atualizando o construtor
  });

  // Novo construtor que aceita uma transação e converte para Item
  Item.fromTransaction(Transaction transaction)
      : icone = Icons.category, // Aqui você pode definir o ícone conforme necessário
        categoria = transaction.category,
        descricao = transaction.descricao,
        valor = transaction.valor,
        data = transaction.data,
        tipo = transaction.tipo; // Adicionando a atribuição do tipo
}
