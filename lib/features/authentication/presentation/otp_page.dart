import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/presentation/widgets/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رمز التحقق')),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthReady) context.go('/device');
        },
        builder: (context, state) => OtpForm(authState: state),
      ),
    );
  }
}
