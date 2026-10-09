import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softnetmanager/core/locators/locator.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';
import 'package:softnetmanager/features/auth/data/datasources/auth_remote_data_source.dart';

class Home extends StatelessWidget {
  final ds = getIt<AuthRemoteDataSource>();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Softnet Manager"),
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthCubit>().logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(child: Center(child: Text("Content"))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = ds.getProduct();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.toString())));
        },
        child: Text("add"),
      ),
    );
  }
}
