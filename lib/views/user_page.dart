import 'package:app_mm_v3/src/add.dart';
import 'package:app_mm_v3/src/app_widget.dart';
import 'package:app_mm_v3/views/home_page.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  // Dados do usuário
  final String fullName;
  final String nickname;
  final String email;
  final String avatarUrl;

  const UserProfilePage({
    Key? key,
    required this.fullName,
    required this.nickname,
    required this.email,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              fullName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              nickname,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppWidget(),));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionPage(),));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
