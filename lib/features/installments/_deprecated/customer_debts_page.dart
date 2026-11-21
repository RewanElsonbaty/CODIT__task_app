import 'package:codit/core/di/injection.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/installments/presentation/installments_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/customer_debts_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomerDebtsPage extends StatefulWidget {
  const CustomerDebtsPage({super.key});

  static const customerId = 'C-9001';

  @override
  State<CustomerDebtsPage> createState() => _CustomerDebtsPageState();
}

class _CustomerDebtsPageState extends State<CustomerDebtsPage> {
  final _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InstallmentsCubit>()..load(CustomerDebtsPage.customerId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مديونيات العميل'),
          actions: [
            IconButton(
              onPressed: () => context.push('/installments/pending'),
              icon: const Icon(Icons.sync),
            ),
          ],
        ),
        body: BlocBuilder<InstallmentsCubit, InstallmentsState>(
          builder: (context, state) {
            if (state is InstallmentsLoading) return const AppLoading();
            if (state is InstallmentsError) return Center(child: Text(state.message));
            if (state is! InstallmentsReady) return const SizedBox.shrink();
            return CustomerDebtsBody(
              customerId: CustomerDebtsPage.customerId,
              data: state.data,
              amountController: _amount,
            );
          },
        ),
      ),
    );
  }
}