import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';

/// Login screen with phone and password
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = true;
  String _deviceId = 'unknown_device';
  String _deviceName = 'Unknown Device';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _initializeDeviceInfo();
  }

  /// الحصول على معلومات الجهاز الحقيقية
  Future<void> _initializeDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (kIsWeb) {
        // Web platform
        final webInfo = await deviceInfo.webBrowserInfo;
        setState(() {
          _deviceId = 'web_${webInfo.userAgent.hashCode}';
          _deviceName = '${webInfo.browserName} on ${webInfo.platform}';
        });
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceId = androidInfo.id;
          _deviceName = '${androidInfo.brand} ${androidInfo.model}';
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceId = iosInfo.identifierForVendor ?? 'ios_unknown';
          _deviceName = '${iosInfo.name} (${iosInfo.model})';
        });
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        setState(() {
          _deviceId = windowsInfo.deviceId;
          _deviceName = windowsInfo.computerName;
        });
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        setState(() {
          _deviceId = linuxInfo.machineId ?? 'linux_unknown';
          _deviceName = linuxInfo.prettyName;
        });
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        setState(() {
          _deviceId = macInfo.systemGUID ?? 'mac_unknown';
          _deviceName = macInfo.computerName;
        });
      }
    } catch (e) {
      // في حالة فشل الحصول على المعلومات
      ExceptionHandler.logException(e);
      setState(() {
        _deviceId = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
        _deviceName = 'Unknown Device';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// تحميل البيانات المحفوظة
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (mounted && savedUsername != null && rememberMe) {
      setState(() {
        _usernameController.text = savedUsername;
        _rememberMe = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// حفظ البيانات
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_username', _usernameController.text.trim());
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
      await prefs.setBool('remember_me', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
        ),
      );
    }

    final maxWidth = ResponsiveUtils.valueWhen(
      context: context,
      mobile: double.infinity,
      tablet: 600.0,
      desktop: 500.0,
    );

    final padding = ResponsiveUtils.valueWhen(
      context: context,
      mobile: 24.0,
      tablet: 32.0,
      desktop: 48.0,
    );

    final fontSize = ResponsiveUtils.valueWhen(
      context: context,
      mobile: 28.0,
      tablet: 32.0,
      desktop: 36.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      _buildLogo(),
                      SizedBox(height: ResponsiveUtils.spacing(context, factor: 6)),

                      // Sign In title
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ve already met!',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.textSizeMedium(context),
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, factor: 4)),

                      // Username field
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        validator: _validateUsername,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),

                      // Phone number field
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),

                      // Password field
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFFD4AF37),
                            size: 20,
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),

                      // Remember me & Forgot password
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFFD4AF37),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          Text(
                            'Remember Me',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: const Color(0xFFD4AF37),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Divider with "Or"
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Face ID button
                      OutlinedButton.icon(
                        onPressed: () {
                        // TODO: Face ID authentication
                      },
                      icon: const Icon(Icons.face, size: 24),
                      label: const Text('Face ID'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD4AF37),
                        side: BorderSide(
                          color: const Color(0xFFD4AF37).withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Social login
                    Text(
                      'Get in with Social Account',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.g_mobiledata,
                          onPressed: () {
                            // TODO: Google sign in
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.apple,
                          onPressed: () {
                            // TODO: Apple sign in
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              disabledBackgroundColor:
                                  const Color(0xFFD4AF37).withOpacity(0.5),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor:
                                  const Color(0xFFD4AF37).withOpacity(0.5),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ], // children of Column
                ), // Column
              ), // Form
            ), // Container with constraints
          ), // SingleChildScrollView
        ), // Center
      ), // SafeArea
    ), // Container with decoration - body
    ); // Scaffold
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700),
            const Color(0xFFD4AF37),
            const Color(0xFFB8941E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.diamond,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFD4AF37),
          size: 20,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37),
            const Color(0xFFB8941E),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'اسم المستخدم مطلوب';
    }
    
    if (value.length < 3) {
      return 'اسم المستخدم قصير جداً (على الأقل 3 أحرف)';
    }
    
    if (value.length > 50) {
      return 'اسم المستخدم طويل جداً (حد أقصى 50 حرف)';
    }
    
    // يمكن أن يحتوي على حروف وأرقام وشرطة سفلية ونقطة فقط
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value)) {
      return 'اسم المستخدم يحتوي على أحرف غير صالحة';
    }
    
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    // إزالة المسافات والرموز
    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    
    // التحقق من طول الرقم (10-15 رقم)
    if (cleanPhone.length < 10) {
      return 'رقم الهاتف قصير جداً (على الأقل 10 أرقام)';
    }
    
    if (cleanPhone.length > 15) {
      return 'رقم الهاتف طويل جداً (حد أقصى 15 رقم)';
    }
    
    // التحقق من أن الأرقام صحيحة
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(cleanPhone)) {
      return 'رقم الهاتف غير صحيح';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (value.length < 6) {
      return 'كلمة المرور قصيرة جداً (على الأقل 6 أحرف)';
    }
    
    if (value.length > 50) {
      return 'كلمة المرور طويلة جداً (حد أقصى 50 حرف)';
    }
    
    // التحقق من وجود حرف واحد على الأقل
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي على حرف واحد على الأقل';
    }
    
    // التحقق من وجود رقم واحد على الأقل
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'يجب أن تحتوي على رقم واحد على الأقل';
    }
    
    return null;
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        // حفظ البيانات إذا كان Remember Me مفعّل
        await _saveCredentials();
        
        // تنظيف رقم الهاتف
        final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');
        
        if (mounted) {
          context.read<AuthCubit>().login(
                username: _usernameController.text.trim(),
                phone: cleanPhone,
                password: _passwordController.text,
                deviceId: _deviceId, // ✅ Device ID حقيقي
                deviceName: _deviceName, // ✅ Device Name حقيقي
              );
        }
      } catch (e) {
        ExceptionHandler.logException(e);
        if (mounted) {
          ExceptionHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  /// عرض Dialog لنسيان كلمة المرور
  void _showForgotPasswordDialog() {
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2A27),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: Color(0xFFD4AF37)),
            SizedBox(width: 12),
            Text(
              'نسيت كلمة المرور؟',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أدخل رقم الهاتف المسجل لإرسال رمز التحقق (OTP)',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                ),
                validator: _validatePhone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _sendResetOTP(phoneController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('إرسال OTP'),
          ),
        ],
      ),
    );
  }

  /// إرسال OTP لإعادة تعيين كلمة المرور
  void _sendResetOTP(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // عرض SnackBar للتأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'تم إرسال رمز التحقق إلى $cleanPhone',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // TODO: في الحقيقة، أرسل OTP عبر الـ API
    // context.read<AuthCubit>().sendPasswordResetOTP(cleanPhone);
    
    // عرض Dialog لإدخال OTP
    _showOTPVerificationDialog(cleanPhone);
  }

  /// عرض Dialog للتحقق من OTP
  void _showOTPVerificationDialog(String phone) {
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C2A27),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.verified_user, color: Color(0xFFD4AF37)),
              SizedBox(width: 12),
              Text(
                'تحقق من OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أدخل رمز التحقق المُرسل إلى $phone',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'رمز OTP',
                    labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرمز مطلوب';
                    }
                    if (value.length != 6) {
                      return 'الرمز يجب أن يكون 6 أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: _validatePassword,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  _resetPassword(
                    phone,
                    otpController.text,
                    newPasswordController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );
    });
  }

  /// إعادة تعيين كلمة المرور
  void _resetPassword(String phone, String otp, String newPassword) {
    // TODO: في الحقيقة، أرسل البيانات للـ API
    // context.read<AuthCubit>().resetPassword(phone, otp, newPassword);
    
    // عرض رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'تم تغيير كلمة المرور بنجاح! يمكنك تسجيل الدخول الآن',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
