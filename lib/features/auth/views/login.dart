import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softnetmanager/core/component/CustomButton.dart';
import 'package:softnetmanager/core/component/customTextField.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHieght = MediaQuery.sizeOf(context).height;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error.toString())));
          }
          isLoading = state is AuthLoading;
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: screenHieght * 0.3,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/back1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHieght * 0.2),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/back2.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/login.jpg',
                                      width: 150,
                                      height: 150,
                                    ),

                                    CustomTextField(
                                      label: const Text('Email'),
                                      controller: emailController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Email is empty";
                                        }

                                        return null;
                                      },
                                    ),

                                    CustomTextField(
                                      label: const Text('Password'),
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Password is empty";
                                        }

                                        return null;
                                      },
                                    ),

                                    CustomButton(
                                      isLoading: isLoading,
                                      backcolor: Colors.purple,
                                      textColor: Colors.white,

                                      onPressed: !isLoading
                                          ? () async {
                                              if (!formKey.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              await context
                                                  .read<AuthCubit>()
                                                  .login(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                  );
                                            }
                                          : null,
                                      child: isLoading
                                          ? CircularProgressIndicator()
                                          : const Text("LogIn"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
