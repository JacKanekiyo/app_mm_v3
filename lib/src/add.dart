import 'package:flutter/material.dart';
import 'package:app_mm_v3/views/home_page.dart';

class AddTransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Lançamento'),
      ),
      body: AddTransactionForm(),
    );
  }
}

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  double? _amount;
  DateTime? _selectedDate;
  bool _isIncome = true;

  List<String> _categories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Lazer',
    'Educação',
    'Outros'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
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
              decoration: InputDecoration(
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite um valor';
                }
                return null;
              },
              onSaved: (value) {
                // Convertendo o valor para double e ajustando de acordo com a seleção
                _amount = double.parse(value!) * (_isIncome ? 1 : -1);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Data (dd/mm/aaaa)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Digite uma data';
                }
                return null;
              },
              onSaved: (value) {
                // Converte a string de data para DateTime
                // Aqui você pode adicionar a lógica de conversão
                List<String> dateParts = value!.split('/');
                int day = int.parse(dateParts[0]);
                int month = int.parse(dateParts[1]);
                int year = int.parse(dateParts[2]);
                _selectedDate = DateTime(year, month, day);
              },
            ),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: _isIncome,
                  onChanged: (value) {
                    setState(() {
                      _isIncome = value as bool;
                    });
                  },
                ),
                Text('Receita'),
                SizedBox(width: 20),
                Radio(
                  value: false,
                  groupValue: _isIncome,
                  onChanged: (value) {
                    setState(() {
                      _isIncome = value as bool;
                    });
                  },
                ),
                Text('Despesa'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                  print('Categoria: $_selectedCategory');
                  print('Valor: $_amount');
                  print('Data: $_selectedDate');
                  print('É Receita? $_isIncome');
                }
              },
              child: Text('Adicionar Lançamento'),
            ),
          ],
        ),
      ),
    );
  }
}