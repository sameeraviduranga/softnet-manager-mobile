import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/core/router/route.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<AuthCubit>())],
      child: MaterialApp.router(
        routerConfig: goRouter,
        title: "softnetmanager",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.light()),
      ),
    );
  }
}
