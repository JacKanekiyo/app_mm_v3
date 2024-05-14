import 'package:flutter/material.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/views/user_page.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
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
          ),
        ),
        SizedBox(height: 100), // Adiciona espaço no final da tela
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                },
              ),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppWidget(),));
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
    );
  }
}
