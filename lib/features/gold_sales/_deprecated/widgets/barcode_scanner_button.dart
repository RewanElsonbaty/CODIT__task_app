import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gold_sale_cubit.dart';
import '../../../../core/localization/app_localizations.dart';

class BarcodeScannerButton extends StatefulWidget {
  const BarcodeScannerButton({super.key});

  @override
  State<BarcodeScannerButton> createState() => _BarcodeScannerButtonState();
}

class _BarcodeScannerButtonState extends State<BarcodeScannerButton> {
  bool _isScanning = false;

  Future<void> _scanBarcode() async {
    setState(() => _isScanning = true);
    
    try {
      // Mock barcode scanner - في الـ production يتم استخدام mobile_scanner package
      await Future.delayed(const Duration(milliseconds: 800));
      
      // محاكاة نتيجة المسح - في الـ production يأتي من الـ scanner
      final mockBarcodes = ['G001', 'G002', 'G003', 'G004'];
      final randomBarcode = mockBarcodes[DateTime.now().second % mockBarcodes.length];
      
      if (mounted) {
        await context.read<GoldSaleCubit>().searchProduct(randomBarcode);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.goldSalesScanError,
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isScanning ? Icons.qr_code_scanner : Icons.qr_code_2,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.goldSalesScanBarcode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanBarcode,
              icon: _isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.camera_alt),
              label: Text(
                _isScanning
                    ? localizations.goldSalesScanning
                    : localizations.goldSalesStartScan,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.goldSalesScanHint,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
