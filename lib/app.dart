import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/on_genrate_route.dart';
import 'package:fruit_hub_dash_board/features/dash_board/presentation/views/dash_board_view.dart';

class FruitHubDashboard extends StatelessWidget {
  const FruitHubDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        home: DashBoardView(),
        onGenerateRoute: onGenerateRoute,
        initialRoute: DashBoardView.routeName,
      ),
    );
  }
}
