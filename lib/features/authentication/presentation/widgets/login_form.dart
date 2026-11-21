import 'package:codit/core/di/injection.dart';
import 'package:codit/core/widgets/app_button.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.authState});

  final AuthenticationState authState;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _phone = TextEditingController(text: '01000000000');
  final _password = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    final state = widget.authState;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'كلمة المرور'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          if (state is AuthError)
            Text(state.message, style: const TextStyle(color: Colors.red)),
          AppButton(
            label: 'دخول',
            loading: state is AuthLoading,
            onPressed: () =>
                getIt<AuthenticationCubit>().login(_phone.text, _password.text),
          ),
        ],
      ),
    );
  }
}
