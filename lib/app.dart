import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/on_genrate_route.dart';
import 'package:fruit_hub_dash_board/core/repos/orders_repo/orders_repo.dart';
import 'package:fruit_hub_dash_board/core/repos/product_repo/product_repo.dart';
import 'package:fruit_hub_dash_board/core/services/get_it_service.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/features/main_layout/presentation/views/main_view.dart';
import 'package:fruit_hub_dash_board/features/orders/presentation/manger/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/manger/products_cubit/products_cubit.dart';

class FruitHubDashboard extends StatelessWidget {
  const FruitHubDashboard({super.key, this.initialRoute = MainView.routeName});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductsCubit(getIt<ProductRepo>())..load(),
        ),
        BlocProvider(create: (_) => OrdersCubit(getIt<OrdersRepo>())..load()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          title: 'FruitHub Dashboard',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: 'Cairo',
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.green1500,
              primary: AppColors.green1500,
            ),
            scaffoldBackgroundColor: const Color(0xffF7F8F8),
            snackBarTheme: const SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
            ),
          ),
          onGenerateRoute: onGenerateRoute,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
