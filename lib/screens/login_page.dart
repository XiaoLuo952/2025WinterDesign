import 'package:flutter/material.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  // Adding key parameter to constructor
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  void _login() {
    final phone = _phoneController.text;
    final code = _codeController.text;

    if (phone.isEmpty || code.isEmpty) {
      // 显示错误信息
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('请输入手机号和验证码'),
      ));
      return;
    }

    // 进行登录操作，比如调用登录API
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()), // 登录成功后跳转到主页面
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: '手机号',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '验证码',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _login,
              child: Text('登录'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green, // Changed from 'primary' to 'backgroundColor'
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // 跳转到注册页面，未实现
              },
              child: Text('没有账号？立即注册'),
            ),
          ],
        ),
      ),
    );
  }
}
