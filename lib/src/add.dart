import 'package:app_mm_v3/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Lançamento'),
      ),
      body: const AddTransactionForm(),
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

  // Controlador e formatação para o campo de data
  final TextEditingController _dateController = TextEditingController();
  var _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

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
                try {
                  double.parse(value);
                } catch (e) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            TextFormField(
              controller: _dateController,
              inputFormatters: [_dateMaskFormatter],
              decoration: const InputDecoration(
                labelText: 'Data (dd/mm/aaaa)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite uma data';
                }
                if (value.length != 10) {
                  return 'Digite a data no formato correto';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _dateInput = value;
                });
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty && value.length == 10) {
                  List<String> parts = value.split('/');
                  int day = int.parse(parts[0]);
                  int month = int.parse(parts[1]);
                  int year = int.parse(parts[2]);
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
            Center(
              child: Container(
                width: 180, // Ajuste o tamanho do botão aqui
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF734B9B), Color(0xFF3F8782)],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveTransaction();
                    }
                  },
                  child: const Text(
                    'Adicionar Lançamento',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() async {
    try {
      Map<String, dynamic> transactionData = {
        'categoria': _selectedCategory,
        'valor': _amount,
        'descricao': _description,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'tipo': _tipo,
      };

      // Verifica se _selectedDate não é nulo antes de adicionar ao mapa
      if (_selectedDate != null) {
        transactionData['data'] = Timestamp.fromDate(_selectedDate!);
      }

      await _firestore.collection('lancamentos').add(transactionData);

      // Exibir mensagem de sucesso e navegar de volta para a HomePage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lançamento adicionado com sucesso')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (error) {
      // Tratar erro, se necessário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o lançamento: $error')),
      );
    }
  }
}
