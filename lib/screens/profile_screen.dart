import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../widgets/common_widgets.dart';
import 'auth_screens.dart';

// =============================================
// ХЭЛНИЙ МЕНЕЖЕР
// =============================================
class AppLocalizations {
  static bool isMongolian = true;

  static String get profile => isMongolian ? 'Профайл' : 'Profile';
  static String get verified => isMongolian ? 'Баталгаажсан' : 'Verified';
  static String get creditScore =>
      isMongolian ? 'Зээлийн оноо' : 'Credit Score';
  static String get grade => isMongolian ? 'Зэрэглэл' : 'Grade';
  static String get income => isMongolian ? 'Орлого' : 'Income';
  static String get personalInfo =>
      isMongolian ? 'Хувийн мэдээлэл' : 'Personal Info';
  static String get register => isMongolian ? 'Регистр' : 'Register No.';
  static String get employment => isMongolian ? 'Ажлын байр' : 'Employment';
  static String get employer => isMongolian ? 'Ажил олгогч' : 'Employer';
  static String get settings => isMongolian ? 'Тохиргоо' : 'Settings';
  static String get editProfile =>
      isMongolian ? 'Мэдээлэл засах' : 'Edit Profile';
  static String get changePassword =>
      isMongolian ? 'Нууц үг солих' : 'Change Password';
  static String get notificationSettings =>
      isMongolian ? 'Мэдэгдлийн тохиргоо' : 'Notification Settings';
  static String get helpContact =>
      isMongolian ? 'Тусламж & Холбоо барих' : 'Help & Contact';
  static String get logout => isMongolian ? 'Гарах' : 'Sign Out';
  static String get save => isMongolian ? 'Хадгалах' : 'Save';
  static String get email => isMongolian ? 'И-мэйл' : 'Email';
  static String get employerName =>
      isMongolian ? 'Ажил олгогчийн нэр' : 'Employer Name';
  static String get monthlyIncome =>
      isMongolian ? 'Сарын орлого (₮)' : 'Monthly Income (₮)';
  static String get homeAddress => isMongolian ? 'Гэрийн хаяг' : 'Home Address';
  static String get employmentType =>
      isMongolian ? 'Ажлын төрөл' : 'Employment Type';
  static String get currentPassword =>
      isMongolian ? 'Одоогийн нууц үг' : 'Current Password';
  static String get newPassword =>
      isMongolian ? 'Шинэ нууц үг' : 'New Password';
  static String get confirmPassword =>
      isMongolian ? 'Нууц үг давтах' : 'Confirm Password';
  static String get passwordMismatch =>
      isMongolian ? 'Нууц үг таарахгүй байна' : 'Passwords do not match';
  static String get passwordSaved => isMongolian
      ? 'Нууц үг амжилттай солигдлоо!'
      : 'Password changed successfully!';
  static String get passwordWeak => isMongolian ? 'Сул' : 'Weak';
  static String get passwordMedium => isMongolian ? 'Дунд' : 'Medium';
  static String get passwordStrong => isMongolian ? 'Хүчтэй' : 'Strong';
  static String get passwordHint => isMongolian
      ? 'Аюулгүй байдлын үүднээс нууц үгээ тогтмол солиорой.'
      : 'For your security, change your password regularly.';
  static String get langToggle => isMongolian ? 'EN' : 'МН';
}

// =============================================
// ПРОФАЙЛ ДЭЛГЭЦ
// =============================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await SupabaseService.getProfile();
      if (mounted) {
        setState(() {
          _profile = p;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleLanguage() {
    setState(() {
      AppLocalizations.isMongolian = !AppLocalizations.isMongolian;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.profile),
        centerTitle: true,
        actions: [
          // Хэл солих товч
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _toggleLanguage,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language_rounded,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.langToggle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _profile != null
                                  ? _profile!.firstName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(_profile?.fullName ?? '—',
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    Text(
                      _profile?.phone ?? '—',
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    if (_profile?.isVerified == true) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: AppColors.success, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.verified,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Credit score card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B3A6B), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ScoreItem(
                            label: AppLocalizations.creditScore,
                            value: '${_profile?.creditScore ?? 0}',
                            suffix: '/850',
                          ),
                          Container(
                              width: 1, height: 40, color: Colors.white24),
                          _ScoreItem(
                            label: AppLocalizations.grade,
                            value: _profile?.creditScoreLabel ?? '—',
                          ),
                          Container(
                              width: 1, height: 40, color: Colors.white24),
                          _ScoreItem(
                            label: AppLocalizations.income,
                            value: AppUtils.formatCurrencyShort(
                                _profile?.monthlyIncome ?? 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal info
                    _SectionCard(
                      title: AppLocalizations.personalInfo,
                      icon: Icons.person_outline,
                      children: [
                        InfoRow(
                            label: AppLocalizations.register,
                            value: _profile?.registerNumber ?? '—'),
                        InfoRow(
                          label: AppLocalizations.employment,
                          value: AppUtils.getEmploymentTypeLabel(
                              _profile?.employmentType),
                        ),
                        InfoRow(
                          label: AppLocalizations.employer,
                          value: _profile?.employerName ?? '—',
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Settings menu
                    _SectionCard(
                      title: AppLocalizations.settings,
                      icon: Icons.settings_outlined,
                      children: [
                        _MenuItem(
                          icon: Icons.edit_outlined,
                          label: AppLocalizations.editProfile,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EditProfileScreen()),
                          ).then((_) => setState(() {})),
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline,
                          label: AppLocalizations.changePassword,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen()),
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          label: AppLocalizations.notificationSettings,
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          label: AppLocalizations.helpContact,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Logout
                    AppButton(
                      label: AppLocalizations.logout,
                      onPressed: () async {
                        await SupabaseService.signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        }
                      },
                      isOutlined: true,
                      color: AppColors.error,
                      icon: Icons.logout_rounded,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

// =============================================
// НУУЦ ҮГ СОЛИХ ДЭЛГЭЦ
// =============================================
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;
  double _strength = 0;
  String _strengthLabel = '';
  Color _strengthColor = AppColors.error;

  void _checkStrength(String val) {
    int score = 0;
    if (val.length >= 8) score++;
    if (val.contains(RegExp(r'[A-Z]'))) score++;
    if (val.contains(RegExp(r'[0-9]'))) score++;
    if (val.contains(RegExp(r'[^A-Za-z0-9]'))) score++;

    setState(() {
      if (score <= 1) {
        _strength = 0.25;
        _strengthLabel = AppLocalizations.passwordWeak;
        _strengthColor = AppColors.error;
      } else if (score <= 2) {
        _strength = 0.6;
        _strengthLabel = AppLocalizations.passwordMedium;
        _strengthColor = AppColors.warning;
      } else {
        _strength = 1.0;
        _strengthLabel = AppLocalizations.passwordStrong;
        _strengthColor = AppColors.success;
      }
    });
  }

  Future<void> _save() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      AppSnackbar.show(context, AppLocalizations.passwordMismatch,
          isError: true);
      return;
    }
    setState(() => _loading = true);
    try {
      await SupabaseService.changePassword(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      if (mounted) {
        AppSnackbar.show(context, AppLocalizations.passwordSaved);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.changePassword),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hint card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primaryLight, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.passwordHint,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current password
            AppTextField(
              controller: _currentCtrl,
              label: AppLocalizations.currentPassword,
              prefixIcon: Icons.lock_outline,
              obscureText: !_showCurrent,
              suffixIcon: IconButton(
                icon: Icon(
                  _showCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showCurrent = !_showCurrent),
              ),
            ),
            const SizedBox(height: 16),

            // New password
            AppTextField(
              controller: _newCtrl,
              label: AppLocalizations.newPassword,
              prefixIcon: Icons.lock_reset_outlined,
              obscureText: !_showNew,
              onChanged: _checkStrength,
              suffixIcon: IconButton(
                icon: Icon(
                  _showNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showNew = !_showNew),
              ),
            ),

            // Strength bar
            if (_newCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _strength,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(_strengthColor),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _strengthLabel,
                style: AppTextStyles.caption.copyWith(
                    color: _strengthColor, fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 16),

            // Confirm password
            AppTextField(
              controller: _confirmCtrl,
              label: AppLocalizations.confirmPassword,
              prefixIcon: Icons.lock_outline,
              obscureText: !_showConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showConfirm = !_showConfirm),
              ),
            ),

            // Match indicator
            if (_confirmCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    _newCtrl.text == _confirmCtrl.text
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    size: 14,
                    color: _newCtrl.text == _confirmCtrl.text
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _newCtrl.text == _confirmCtrl.text
                        ? (AppLocalizations.isMongolian
                            ? 'Нууц үг таарч байна'
                            : 'Passwords match')
                        : AppLocalizations.passwordMismatch,
                    style: AppTextStyles.caption.copyWith(
                      color: _newCtrl.text == _confirmCtrl.text
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),

            AppButton(
              label: AppLocalizations.save,
              onPressed: _save,
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================
// МЭДЭЭЛЭЛ ЗАСАХ ДЭЛГЭЦ
// =============================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _emailCtrl = TextEditingController();
  final _incomeCtrl = TextEditingController();
  final _employerCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _employmentType;
  bool _loading = false;

  List<Map<String, String>> get _employmentTypes => [
        {
          'value': 'employee',
          'label': AppLocalizations.isMongolian ? 'Ажилтан' : 'Employee'
        },
        {
          'value': 'self_employed',
          'label':
              AppLocalizations.isMongolian ? 'Өөрөө ажиллагч' : 'Self-employed'
        },
        {
          'value': 'business_owner',
          'label': AppLocalizations.isMongolian
              ? 'Бизнес эзэмшигч'
              : 'Business Owner'
        },
      ];

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      await SupabaseService.updateProfile({
        'email': _emailCtrl.text.trim(),
        'monthly_income': double.tryParse(_incomeCtrl.text) ?? 0,
        'employer_name': _employerCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'employment_type': _employmentType,
      });
      if (mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.isMongolian
              ? 'Мэдээлэл амжилттай хадгалагдлаа!'
              : 'Profile updated successfully!',
        );
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.show(
          context,
          AppLocalizations.isMongolian
              ? 'Хадгалахад алдаа гарлаа'
              : 'Failed to save',
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
        title: Text(AppLocalizations.editProfile),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              controller: _emailCtrl,
              label: AppLocalizations.email,
              hint: 'email@example.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _employmentType,
              decoration: InputDecoration(
                labelText: AppLocalizations.employmentType,
                prefixIcon: const Icon(Icons.work_outline,
                    size: 20, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              items: _employmentTypes
                  .map((t) => DropdownMenuItem(
                      value: t['value'], child: Text(t['label']!)))
                  .toList(),
              onChanged: (v) => setState(() => _employmentType = v),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _employerCtrl,
              label: AppLocalizations.employerName,
              prefixIcon: Icons.business_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _incomeCtrl,
              label: AppLocalizations.monthlyIncome,
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _addressCtrl,
              label: AppLocalizations.homeAddress,
              prefixIcon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            AppButton(
                label: AppLocalizations.save,
                onPressed: _save,
                isLoading: _loading),
          ],
        ),
      ),
    );
  }
}

// =============================================
// МЭДЭГДЭЛ ДЭЛГЭЦ
// =============================================
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final n = await SupabaseService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = n;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'payment_due':
        return Icons.alarm_rounded;
      case 'payment_received':
        return Icons.check_circle_rounded;
      case 'loan_approved':
        return Icons.thumb_up_rounded;
      case 'loan_rejected':
        return Icons.cancel_rounded;
      case 'overdue':
        return Icons.warning_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'payment_due':
        return AppColors.warning;
      case 'payment_received':
        return AppColors.success;
      case 'loan_approved':
        return AppColors.success;
      case 'loan_rejected':
        return AppColors.error;
      case 'overdue':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            Text(AppLocalizations.isMongolian ? 'Мэдэгдлүүд' : 'Notifications'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight))
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.notifications_none_rounded,
                          size: 64, color: AppColors.textHint),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.isMongolian
                            ? 'Мэдэгдэл байхгүй'
                            : 'No notifications',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _notifications.length,
                  itemBuilder: (context, i) {
                    final n = _notifications[i];
                    final isRead = n['is_read'] == true;
                    final color = _getColor(n['type']);
                    return GestureDetector(
                      onTap: () {
                        SupabaseService.markNotificationRead(n['id']);
                        setState(() => _notifications[i]['is_read'] = true);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isRead
                              ? AppColors.surface
                              : color.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isRead
                                ? AppColors.border
                                : color.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_getIcon(n['type']),
                                  color: color, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n['title'] ?? '',
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n['body'] ?? '',
                                    style: AppTextStyles.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppUtils.formatDateTime(
                                        DateTime.parse(n['created_at'])),
                                    style: AppTextStyles.caption
                                        .copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// =============================================
// ДЭМЖИХ WIDGET-УУД
// =============================================
class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;

  const _ScoreItem(
      {required this.label, required this.value, this.suffix = ''});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          RichText(
            text: TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Gilroy',
              ),
              children: [
                if (suffix.isNotEmpty)
                  TextSpan(
                    text: suffix,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 13),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11,
                fontFamily: 'Gilroy'),
          ),
        ],
      );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.body)),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
