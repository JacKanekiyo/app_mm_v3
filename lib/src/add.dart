import 'package:app_mm_v3/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Lançamento'),
      ),
      body: AddTransactionForm(),
    );
  }
}

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  double? _amount;
  String? _dateInput;
  DateTime? _selectedDate;
  String? _description;
  String? _tipo;

  final List<String> _categories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Lazer',
    'Educação',
    'Investimentos',
    'Salário',
    'Outros'
  ];

  // Referência para o Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Categoria',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Selecione uma categoria';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite um valor';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Data (ddmmaaaa)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite uma data';
                }
                return null;
              },
              inputFormatters: [LengthLimitingTextInputFormatter(8)],
              onChanged: (value) {
                setState(() {
                  _dateInput = value;
                });
              },
              onSaved: (value) {
                // Converte a string de data para DateTime
                if (value != null && value.isNotEmpty && value.length == 8) {
                  int day = int.parse(value.substring(0, 2));
                  int month = int.parse(value.substring(2, 4));
                  int year = int.parse(value.substring(4, 8));
                  _selectedDate = DateTime(year, month, day);
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite uma descrição';
                }
                return null;
              },
              onSaved: (value) {
                _description = value;
              },
            ),
            Row(
              children: [
                Radio(
                  value: 'Receita',
                  groupValue: _tipo,
                  onChanged: (value) {
                    setState(() {
                      _tipo = value;
                    });
                  },
                ),
                const Text('Receita'),
                const SizedBox(width: 20),
                Radio(
                  value: 'Despesa',
                  groupValue: _tipo,
                  onChanged: (value) {
                    setState(() {
                      _tipo = value;
                    });
                  },
                ),
                const Text('Despesa'),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Chamando método para salvar o lançamento
                  _saveTransaction();
                }
              },
              child: const Text('Adicionar Lançamento'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() {
    // Salvando o lançamento no Firestore
    _firestore.collection('lancamentos').add({
      'categoria': _selectedCategory,
      'valor': _amount,
      'data': _selectedDate,
      'descricao': _description,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'tipo': _tipo,
    }).then((value) {
      // Navegar para a página inicial após salvar o lançamento
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }).catchError((error) {
      // Tratar erro, se necessário
      print("Erro ao salvar o lançamento: $error");
    });
  }
}
