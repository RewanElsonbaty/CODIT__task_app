import 'dart:async';

import 'package:codit/core/config/app_config.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
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
    // Auto-focus على أول خانة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
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

  void _submit() {
    if (!_isComplete) return;
    FocusScope.of(context).unfocus();
    getIt<AuthenticationCubit>().submitOtp(_otp);
  }

  void _resendOtp() {
    // في تطبيق حقيقي، هنا نطلب إعادة إرسال OTP
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إرسال رمز جديد'),
        backgroundColor: AppColors.successDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldenNeon.withOpacity(0.2),
                  AppColors.goldenNeon.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: isSmallScreen ? 60 : 80,
              color: AppColors.goldenNeon,
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 24),

          // العنوان
          Text(
            'تأكيد رمز التحقق',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : 24,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isSmallScreen ? 8 : 12),

          // الوصف
          Text(
            'أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: isSmallScreen ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isSmallScreen ? 4 : 8),

          // OTP للاختبار
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: AppColors.goldenNeon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.goldenNeon.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.goldenNeon,
                ),
                const SizedBox(width: 8),
                Text(
                  'رمز الاختبار: $testOtp',
                  style: TextStyle(
                    color: AppColors.goldenNeon,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 16 : 32),

          // حقول OTP
          Directionality(
            textDirection: TextDirection.rtl, // ✅ من اليمين لليسار
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fieldWidth = (constraints.maxWidth - 60) / 6;
                final maxFieldWidth = 50.0;
                final actualWidth = fieldWidth > maxFieldWidth
                    ? maxFieldWidth
                    : fieldWidth;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    // ✅ عكس الترتيب عشان يبدأ من اليمين
                    final rtlIndex = 5 - index;
                    
                    return SizedBox(
                      width: actualWidth,
                      height: isSmallScreen ? 50 : 55,
                      child: TextField(
                        controller: _controllers[rtlIndex],
                        focusNode: _focusNodes[rtlIndex],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        autofocus: rtlIndex == 0,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldenNeon,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.card,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.goldenNeon,
                              width: 2.5,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            // ✅ الانتقال من اليمين لليسار
                            if (rtlIndex < 5) {
                              _focusNodes[rtlIndex + 1].requestFocus();
                            } else {
                              // آخر خانة، تحقق من الاكتمال
                              FocusScope.of(context).unfocus();
                              if (_isComplete) {
                                _submit();
                              }
                            }
                          }
                          setState(() {});
                        },
                        onTap: () {
                          // اختار كل النص عند الضغط
                          _controllers[rtlIndex].selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controllers[rtlIndex].text.length,
                          );
                        },
                      ),
                    );
                  }),
                );
              },
            ),
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
                      color: AppColors.textSecondary,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  )
                : TextButton.icon(
                    onPressed: _resendOtp,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.goldenNeon,
                    ),
                    label: const Text(
                      'إعادة إرسال الرمز',
                      style: TextStyle(color: AppColors.goldenNeon),
                    ),
                  ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 24),

          // رسالة خطأ
          if (widget.authState is AuthError)
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.errorLight,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      (widget.authState as AuthError).message,
                      style: const TextStyle(color: AppColors.errorLight),
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
