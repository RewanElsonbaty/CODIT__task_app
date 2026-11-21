import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthReady) context.go('/otp');
        },
        builder: (context, state) => LoginForm(authState: state),
      ),
    );
  }
}
