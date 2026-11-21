import 'package:codit/core/di/injection.dart';
import 'package:codit/core/widgets/app_button.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:flutter/material.dart';

class DeviceVerifyBody extends StatelessWidget {
  const DeviceVerifyBody({super.key, required this.authState});

  final AuthenticationState authState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('جهاز جديد يتطلب تأكيداً من الخادم.'),
          const SizedBox(height: 24),
          AppButton(
            label: 'تحقق من الجهاز',
            loading: authState is AuthLoading,
            onPressed: () => getIt<AuthenticationCubit>().verifyDevice(),
          ),
        ],
      ),
    );
  }
}
