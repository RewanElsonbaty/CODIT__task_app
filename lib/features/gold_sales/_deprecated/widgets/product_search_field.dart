import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gold_sale_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import 'add_gold_item_dialog.dart';

class ProductSearchField extends StatefulWidget {
  const ProductSearchField({super.key});

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() => _isSearching = true);
    try {
      final cubit = context.read<GoldSaleCubit>();
      final product = await cubit.searchProductAndReturnResult(_controller.text.trim());
      
      if (!mounted) return;
      
      if (product != null) {
        // Show dialog to add product
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => BlocProvider.value(
            value: cubit,
            child: AddGoldItemDialog(product: product),
          ),
        );
      }
      
      _controller.clear();
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              enabled: !_isSearching,
              decoration: InputDecoration(
                hintText: localizations.goldSalesSearchProductHint,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isSearching ? null : _search,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localizations.goldSalesSearch,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
