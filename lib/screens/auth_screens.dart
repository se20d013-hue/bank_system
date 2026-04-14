import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

// =============================================
// НЭВТРЭХ ДЭЛГЭЦ — утас эсвэл и-мэйл + нууц үг
// =============================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginCtrl = TextEditingController(); // утас эсвэл имэйл
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool get _isEmail => _loginCtrl.text.contains('@');

  Future<void> _login() async {
    if (_loginCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      AppSnackbar.show(context, 'Бүх талбарыг бөглөнө үү', isError: true);
      return;
    }
    setState(() => _loading = true);
    try {
      if (_isEmail) {
        // И-мэйлээр нэвтрэх
        await SupabaseService.signInWithEmail(
          email: _loginCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } else {
        // Утасны дугаараар нэвтрэх
        await SupabaseService.signIn(
          phone: _loginCtrl.text.trim(),
          password: _passCtrl.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          'Нэвтрэх мэдээлэл буруу байна',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 32),
              Text('Сайн уу!', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Зээлийн данстаа нэвтэрнэ үү',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              // Утас эсвэл и-мэйл — хоёуланг хүлээн авна
              AppTextField(
                controller: _loginCtrl,
                label: 'Утасны дугаар эсвэл и-мэйл',
                hint: '80000000 эсвэл example@gmail.com',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passCtrl,
                label: 'Нууц үг',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Нууц үг мартсан?',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Нэвтрэх',
                onPressed: _login,
                isLoading: _loading,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Бүртгэл байхгүй юу? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                    child: Text(
                      'Бүртгүүлэх',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================
// БҮРТГҮҮЛЭХ ДЭЛГЭЦ
// =============================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0;
  bool _loading = false;

  final _lastNameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _registerCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _lastNameCtrl.dispose();
    _firstNameCtrl.dispose();
    _registerCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_phoneCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _confirmPassCtrl.text.isEmpty) {
      AppSnackbar.show(context, 'Бүх талбарыг бөглөнө үү', isError: true);
      return;
    }
    if (!_emailCtrl.text.contains('@')) {
      AppSnackbar.show(context, 'И-мэйл хаяг буруу байна', isError: true);
      return;
    }
    if (_passCtrl.text.length < 8) {
      AppSnackbar.show(
        context,
        'Нууц үг хамгийн багадаа 8 тэмдэгт байна',
        isError: true,
      );
      return;
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      AppSnackbar.show(context, 'Нууц үг таарахгүй байна', isError: true);
      return;
    }
    setState(() => _loading = true);
    try {
      await SupabaseService.signUp(
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        registerNumber: _registerCtrl.text.trim().toUpperCase(),
      );
      if (mounted) {
        AppSnackbar.show(
          context,
          'Бүртгэл амжилттай! Утас эсвэл и-мэйлээрээ нэвтэрнэ үү.',
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          'Бүртгэл үүсгэхэд алдаа гарлаа: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Бүртгүүлэх (${_step + 1}/2)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () =>
              _step == 0 ? Navigator.pop(context) : setState(() => _step--),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  2,
                  (i) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: i <= _step
                            ? AppColors.primaryLight
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_step == 0) ...[
                Text('Хувийн мэдээлэл', style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                Text(
                  'Таны нэр, регистрийн дугаар',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _lastNameCtrl,
                  label: 'Овог',
                  hint: 'Овгоо оруулна уу',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _firstNameCtrl,
                  label: 'Нэр',
                  hint: 'Нэрээ оруулна уу',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _registerCtrl,
                  label: 'Регистрийн дугаар',
                  hint: 'АА00000000',
                  prefixIcon: Icons.badge_outlined,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                ),
                const Spacer(),
                AppButton(
                  label: 'Үргэлжлэх',
                  onPressed: () {
                    if (_lastNameCtrl.text.isEmpty ||
                        _firstNameCtrl.text.isEmpty ||
                        _registerCtrl.text.isEmpty) {
                      AppSnackbar.show(
                        context,
                        'Бүх талбарыг бөглөнө үү',
                        isError: true,
                      );
                      return;
                    }
                    setState(() => _step = 1);
                  },
                ),
              ] else ...[
                Text('Нэвтрэх мэдээлэл', style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                Text(
                  'Утас, и-мэйл болон нууц үг тохируулна уу',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _phoneCtrl,
                  label: 'Утасны дугаар',
                  hint: '8 оронтой дугаар',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailCtrl,
                  label: 'И-мэйл хаяг',
                  hint: 'example@gmail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passCtrl,
                  label: 'Нууц үг',
                  hint: 'Хамгийн багадаа 8 тэмдэгт',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscure,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPassCtrl,
                  label: 'Нууц үг давтах',
                  hint: 'Нууц үгийг дахин оруулна уу',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const Spacer(),
                AppButton(
                  label: 'Бүртгүүлэх',
                  onPressed: _register,
                  isLoading: _loading,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
