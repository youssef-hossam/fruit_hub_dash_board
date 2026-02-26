import 'package:flutter/material.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/dash_board_view.dart';

class FruitHubDashboard extends StatelessWidget {
  const FruitHubDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FruitHub Dashboard',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DashBoardView(),
    );
  }
}
