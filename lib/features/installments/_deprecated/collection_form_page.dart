import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:codit/features/installments/presentation/collection_form_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/collection_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionFormPage extends StatelessWidget {
  const CollectionFormPage({super.key, required this.customer});

  final CustomerDebt customer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CollectionFormCubit>()..loadCustomerDebts(customer.customerId),
      child: _CollectionFormView(customer: customer),
    );
  }
}

class _CollectionFormView extends StatelessWidget {
  const _CollectionFormView({required this.customer});

  final CustomerDebt customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.successDark,
                    AppColors.successLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.successDark.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.payments, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'تسجيل تحصيل',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<CollectionFormCubit, CollectionFormState>(
        listener: (context, state) {
          if (state is CollectionFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('تم تسجيل التحصيل بنجاح'),
                  ],
                ),
                backgroundColor: AppColors.successDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state is CollectionFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: CollectionFormBody(customer: customer),
      ),
    );
  }
}
