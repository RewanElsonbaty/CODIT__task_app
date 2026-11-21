import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/presentation/widgets/device_verify_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeviceVerifyPage extends StatelessWidget {
  const DeviceVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الجهاز')),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthReady && state.session.isAuthenticated) {
            final target = state.deepLinkTarget;
            context.go(target != null ? '/approvals/$target' : '/home');
          }
        },
        builder: (context, state) => DeviceVerifyBody(authState: state),
      ),
    );
  }
}
