import 'dart:async';

import 'package:codit/core/config/app_config.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/widgets/app_button.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key, required this.authState});

  final AuthenticationState authState;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _resendCountdown = 60);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isComplete => _otp.length == 6;

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_isComplete) {
      // Auto-submit عند اكتمال الإدخال
      _submit();
    }

    setState(() {});
  }

  void _submit() {
    if (!_isComplete) return;
    FocusScope.of(context).unfocus();
    getIt<AuthenticationCubit>().submitOtp(_otp);
  }

  void _resendOtp() {
    // في تطبيق حقيقي، هنا نطلب إعادة إرسال OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال رمز جديد'),
        backgroundColor: Colors.green,
      ),
    );
    _startResendTimer();

    // مسح الحقول
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final testOtp = getIt<AppConfig>().testOtp;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: isSmallScreen ? 16 : 32),

          // أيقونة
          Icon(
            Icons.lock_outline,
            size: isSmallScreen ? 60 : 80,
            color: theme.primaryColor,
          ),

          SizedBox(height: isSmallScreen ? 12 : 24),

          // العنوان
          Text(
            'تأكيد رمز التحقق',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : 24,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isSmallScreen ? 8 : 12),

          // الوصف
          Text(
            'أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: isSmallScreen ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isSmallScreen ? 4 : 8),

          // OTP للاختبار
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'رمز الاختبار: $testOtp',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 16 : 32),

          // حقول OTP
          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = (constraints.maxWidth - 60) / 6;
              final maxFieldWidth = 50.0;
              final actualWidth = fieldWidth > maxFieldWidth
                  ? maxFieldWidth
                  : fieldWidth;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: actualWidth,
                    height: isSmallScreen ? 50 : 55,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onChanged(index, value),
                      onTap: () {
                        _controllers[index].clear();
                      },
                    ),
                  );
                }),
              );
            },
          ),

          SizedBox(height: isSmallScreen ? 16 : 24),

          // زر التأكيد
          AppButton(
            label: 'تأكيد الرمز',
            loading: widget.authState is AuthLoading,
            onPressed: _isComplete ? _submit : null,
          ),

          SizedBox(height: isSmallScreen ? 12 : 16),

          // إعادة إرسال
          Center(
            child: _resendCountdown > 0
                ? Text(
                    'إعادة الإرسال بعد $_resendCountdown ثانية',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  )
                : TextButton.icon(
                    onPressed: _resendOtp,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة إرسال الرمز'),
                  ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 24),

          // رسالة خطأ
          if (widget.authState is AuthError)
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      (widget.authState as AuthError).message,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
