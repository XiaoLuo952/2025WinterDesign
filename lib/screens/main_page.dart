import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("主页面")),
      body: Center(child: Text("欢迎进入主页面！")),
    );
  }
}
