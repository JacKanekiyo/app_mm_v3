import 'package:flutter/material.dart';

class Transaction {
  final String category;
  final String descricao;
  final String valor;
  final DateTime data;
  final bool isIncome;

  Transaction({
    required this.category,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.isIncome,
  });
}

class Item {
  final IconData icone;
  final String categoria;
  final String descricao;
  final String valor;
  final DateTime data;

  Item({
    required this.icone,
    required this.categoria,
    required this.descricao,
    required this.valor,
    required this.data,
  });

  // Novo construtor que aceita uma transação e converte para Item
  Item.fromTransaction(Transaction transaction)
      : icone = Icons.category, // Aqui você pode definir o ícone conforme necessário
        categoria = transaction.category,
        descricao = transaction.descricao,
        valor = transaction.valor,
        data = transaction.data;
}
