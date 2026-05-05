import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _uploadingPhoto = false;
  String? _avatarUrl;

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
          _avatarUrl = p?.avatarUrl;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Нүүр зураг оруулах ──────────────────────
  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final picked =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;

      setState(() => _uploadingPhoto = true);
      final bytes = await picked.readAsBytes();
      final ext = picked.name.split('.').last;
      final url =
          await SupabaseService.uploadAvatar(bytes: bytes, extension: ext);
      if (mounted) {
        setState(() {
          _avatarUrl = url;
          _uploadingPhoto = false;
        });
        AppSnackbar.show(
            context,
            AppLocalizations.isMongolian
                ? 'Зураг шинэчлэгдлээ!'
                : 'Photo updated!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadingPhoto = false);
        AppSnackbar.show(
          context,
          AppLocalizations.isMongolian
              ? 'Зураг оруулахад алдаа гарлаа'
              : 'Failed to upload photo',
          isError: true,
        );
      }
    }
  }

  void _toggleLanguage() => setState(
      () => AppLocalizations.isMongolian = !AppLocalizations.isMongolian);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.profile),
        centerTitle: true,
        actions: [
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
              child: CircularProgressIndicator(color: AppColors.primaryLight))
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // ── Avatar + upload ──────────────────────────
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: _pickAndUploadPhoto,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: _avatarUrl == null
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryLight
                                      ],
                                    )
                                  : null,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              image: _avatarUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _uploadingPhoto
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : _avatarUrl == null
                                    ? Center(
                                        child: Text(
                                          _profile != null
                                              ? _profile!.firstName[0]
                                                  .toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickAndUploadPhoto,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 14),
                          ),
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

                    // ── Зээлийн оноо карт ────────────────────────
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

                    // ── Хувийн мэдээлэл ──────────────────────────
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

                    // ── Тохиргоо цэс ─────────────────────────────
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
                          ).then((_) => _load()),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const NotificationSettingsScreen()),
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          label: AppLocalizations.helpContact,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HelpContactScreen()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Гарах ────────────────────────────────────
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
// МЭДЭЭЛЭЛ ЗАСАХ ДЭЛГЭЦ (бүрэн талбартай)
// =============================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _lastNameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _employerCtrl = TextEditingController();
  final _incomeCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  String? _employmentType;
  bool _loading = false;
  bool _loadingProfile = true;

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

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await SupabaseService.getProfile();
      if (mounted && p != null) {
        _lastNameCtrl.text = p.lastName ?? '';
        _firstNameCtrl.text = p.firstName;
        _phoneCtrl.text = p.phone ?? '';
        _emailCtrl.text = p.email ?? '';
        _addressCtrl.text = p.address ?? '';
        _employerCtrl.text = p.employerName ?? '';
        _incomeCtrl.text =
            p.monthlyIncome != null ? p.monthlyIncome.toString() : '';
        _emergencyNameCtrl.text = p.emergencyContactName ?? '';
        _emergencyPhoneCtrl.text = p.emergencyContactPhone ?? '';
        _employmentType = p.employmentType;
        setState(() => _loadingProfile = false);
      } else {
        setState(() => _loadingProfile = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  @override
  void dispose() {
    _lastNameCtrl.dispose();
    _firstNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _employerCtrl.dispose();
    _incomeCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_lastNameCtrl.text.isEmpty || _firstNameCtrl.text.isEmpty) {
      AppSnackbar.show(
        context,
        AppLocalizations.isMongolian
            ? 'Овог нэрийг бөглөнө үү'
            : 'Please enter your name',
        isError: true,
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await SupabaseService.updateProfile({
        'last_name': _lastNameCtrl.text.trim(),
        'first_name': _firstNameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'employer_name': _employerCtrl.text.trim(),
        'monthly_income': double.tryParse(_incomeCtrl.text) ?? 0,
        'emergency_contact_name': _emergencyNameCtrl.text.trim(),
        'emergency_contact_phone': _emergencyPhoneCtrl.text.trim(),
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

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.editProfile),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: _loadingProfile
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Хувийн мэдээлэл ────────────────────────
                  _sectionHeader(AppLocalizations.isMongolian
                      ? 'Хувийн мэдээлэл'
                      : 'Personal Info'),
                  AppTextField(
                    controller: _lastNameCtrl,
                    label: AppLocalizations.isMongolian ? 'Овог' : 'Last Name',
                    hint: AppLocalizations.isMongolian
                        ? 'Овгоо оруулна уу'
                        : 'Enter last name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _firstNameCtrl,
                    label: AppLocalizations.isMongolian ? 'Нэр' : 'First Name',
                    hint: AppLocalizations.isMongolian
                        ? 'Нэрээ оруулна уу'
                        : 'Enter first name',
                    prefixIcon: Icons.person_outline,
                  ),

                  // ── Холбоо барих ────────────────────────────
                  _sectionHeader(AppLocalizations.isMongolian
                      ? 'Холбоо барих'
                      : 'Contact'),
                  AppTextField(
                    controller: _phoneCtrl,
                    label: AppLocalizations.isMongolian
                        ? 'Утасны дугаар'
                        : 'Phone Number',
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
                    label: AppLocalizations.isMongolian
                        ? 'И-мэйл / Gmail'
                        : 'Email / Gmail',
                    hint: 'example@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _addressCtrl,
                    label: AppLocalizations.homeAddress,
                    hint: AppLocalizations.isMongolian
                        ? 'Дүүрэг, хороо, байр, тоот'
                        : 'District, khoroo, building, apt',
                    prefixIcon: Icons.location_on_outlined,
                    maxLines: 2,
                  ),

                  // ── Ажлын мэдээлэл ──────────────────────────
                  _sectionHeader(AppLocalizations.isMongolian
                      ? 'Ажлын мэдээлэл'
                      : 'Employment Info'),
                  DropdownButtonFormField<String>(
                    value: _employmentType,
                    dropdownColor: AppColors.surface,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.employmentType,
                      labelStyle: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.work_outline,
                          size: 20, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
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
                    hint: AppLocalizations.isMongolian
                        ? 'Байгууллагын нэр'
                        : 'Company name',
                    prefixIcon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _incomeCtrl,
                    label: AppLocalizations.monthlyIncome,
                    hint: '0',
                    prefixIcon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  // ── Ойр дотны хүний мэдээлэл ────────────────
                  _sectionHeader(AppLocalizations.isMongolian
                      ? 'Ойр дотны хүний мэдээлэл'
                      : 'Emergency Contact'),
                  AppTextField(
                    controller: _emergencyNameCtrl,
                    label: AppLocalizations.isMongolian
                        ? 'Ойр дотны хүний овог нэр'
                        : 'Contact full name',
                    hint: AppLocalizations.isMongolian
                        ? 'Нэрийг оруулна уу'
                        : 'Enter full name',
                    prefixIcon: Icons.people_outline,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emergencyPhoneCtrl,
                    label: AppLocalizations.isMongolian
                        ? 'Ойр дотны хүний утас'
                        : 'Contact phone number',
                    hint: '8 оронтой дугаар',
                    prefixIcon: Icons.phone_in_talk_outlined,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),

                  const SizedBox(height: 32),
                  AppButton(
                    label: AppLocalizations.save,
                    onPressed: _save,
                    isLoading: _loading,
                  ),
                  const SizedBox(height: 32),
                ],
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
      if (mounted) AppSnackbar.show(context, e.toString(), isError: true);
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
                    child: Text(AppLocalizations.passwordHint,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
              Text(_strengthLabel,
                  style: AppTextStyles.caption.copyWith(
                      color: _strengthColor, fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 16),
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
                isLoading: _loading),
          ],
        ),
      ),
    );
  }
}

// =============================================
// МЭДЭГДЛИЙН ТОХИРГОО ДЭЛГЭЦ
// =============================================
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _paymentReminder = true;
  bool _loanStatus = true;
  bool _promotions = false;
  bool _overdue = true;
  bool _appUpdates = false;

  Widget _buildToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primaryLight).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: iconColor ?? AppColors.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMn = AppLocalizations.isMongolian;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.notificationSettings),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggle(
              icon: Icons.alarm_rounded,
              title: isMn ? 'Төлбөрийн сануулга' : 'Payment Reminder',
              subtitle: isMn
                  ? 'Төлбөрийн хугацаа болоход мэдэгдэл авах'
                  : 'Get notified before payment due date',
              value: _paymentReminder,
              onChanged: (v) => setState(() => _paymentReminder = v),
            ),
            _buildToggle(
              icon: Icons.credit_score_rounded,
              title: isMn ? 'Зээлийн төлөв' : 'Loan Status',
              subtitle: isMn
                  ? 'Зээлийн хүсэлтийн шийдвэр гарахад мэдэгдэл авах'
                  : 'Get notified on loan application updates',
              value: _loanStatus,
              onChanged: (v) => setState(() => _loanStatus = v),
            ),
            _buildToggle(
              icon: Icons.warning_amber_rounded,
              title: isMn ? 'Хугацаа хэтэрсэн' : 'Overdue Alert',
              subtitle: isMn
                  ? 'Хугацаа хэтэрсэн төлбөрийн мэдэгдэл'
                  : 'Alert when payment is overdue',
              value: _overdue,
              iconColor: AppColors.error,
              onChanged: (v) => setState(() => _overdue = v),
            ),
            _buildToggle(
              icon: Icons.local_offer_rounded,
              title: isMn ? 'Урамшуулал & Санал' : 'Promotions & Offers',
              subtitle: isMn
                  ? 'Тусгай санал болон урамшууллын мэдээлэл'
                  : 'Special offers and promotions',
              value: _promotions,
              iconColor: AppColors.warning,
              onChanged: (v) => setState(() => _promotions = v),
            ),
            _buildToggle(
              icon: Icons.system_update_rounded,
              title: isMn ? 'Аппын шинэчлэлт' : 'App Updates',
              subtitle: isMn
                  ? 'Шинэ хувилбарын талаар мэдэгдэл авах'
                  : 'Get notified about new versions',
              value: _appUpdates,
              onChanged: (v) => setState(() => _appUpdates = v),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: AppLocalizations.save,
              onPressed: () {
                AppSnackbar.show(
                  context,
                  isMn ? 'Тохиргоо хадгалагдлаа!' : 'Settings saved!',
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================
// ТУСЛАМЖ & ХОЛБОО БАРИХ ДЭЛГЭЦ
// =============================================
class HelpContactScreen extends StatefulWidget {
  const HelpContactScreen({super.key});

  @override
  State<HelpContactScreen> createState() => _HelpContactScreenState();
}

class _HelpContactScreenState extends State<HelpContactScreen> {
  final _messageCtrl = TextEditingController();
  bool _sending = false;
  int _expandedIndex = -1;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'Зээл хэрхэн авах вэ?',
      'a':
          '"Зээл авах" товчийг дарж, шаардлагатай мэдээллийг бөглөж, хүсэлт илгээнэ үү. Бид 24 цагийн дотор хариу өгнө.'
    },
    {
      'q': 'Төлбөрийг хэрхэн хийх вэ?',
      'a':
          'Доорх "Зээл" таб руу орж, идэвхтэй зээлээ сонгоод "Төлбөр хийх" товчийг дарна уу.'
    },
    {
      'q': 'Зээлийн оноо яаж нэмэгдэх вэ?',
      'a':
          'Төлбөрөө хугацаандаа хийх, зээлийн дүнгийн хязгаарт хүрэхгүй байх, мэдээллээ бүрэн оруулах зэрэг нь зээлийн оноог нэмэгдүүлнэ.'
    },
    {
      'q': 'Нууц үгээ мартсан бол яах вэ?',
      'a':
          'Нэвтрэх дэлгэц дээрх "Нууц үг мартсан?" товчийг дарж, утасны дугаар эсвэл и-мэйлээр шинэчлэнэ үү.'
    },
    {
      'q': 'Хэдэн зээл нэгэн зэрэг авч болох вэ?',
      'a':
          'Зээлийн оноо болон орлогын түвшингээс хамааран нэгэн зэрэг 1-3 зээл авах боломжтой.'
    },
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageCtrl.text.trim().isEmpty) {
      AppSnackbar.show(
        context,
        AppLocalizations.isMongolian
            ? 'Мессеж оруулна уу'
            : 'Please enter your message',
        isError: true,
      );
      return;
    }
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _sending = false);
      _messageCtrl.clear();
      AppSnackbar.show(
        context,
        AppLocalizations.isMongolian
            ? 'Мессеж илгээгдлээ! Удахгүй холбогдоно.'
            : 'Message sent! We will contact you soon.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMn = AppLocalizations.isMongolian;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.helpContact),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Холбоо барих мэдээлэл ───────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3730A3), AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _ContactTile(
                    icon: Icons.phone_rounded,
                    label: isMn ? 'Утас' : 'Phone',
                    value: '+976 7700-0000',
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  _ContactTile(
                    icon: Icons.email_outlined,
                    label: isMn ? 'И-мэйл' : 'Email',
                    value: 'support@zeel.mn',
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  _ContactTile(
                    icon: Icons.access_time_rounded,
                    label: isMn ? 'Ажлын цаг' : 'Working Hours',
                    value: isMn
                        ? 'Да-Ба: 09:00 - 18:00'
                        : 'Mon-Fri: 09:00 - 18:00',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Түгээмэл асуулт ─────────────────────────
            Text(
              isMn ? 'Түгээмэл асуулт' : 'FAQ',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            ...List.generate(_faqs.length, (i) {
              final expanded = _expandedIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _expandedIndex = expanded ? -1 : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: expanded
                        ? AppColors.primaryLight.withOpacity(0.08)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: expanded
                          ? AppColors.primaryLight.withOpacity(0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[i]['q']!,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 10),
                        Text(
                          _faqs[i]['a']!,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 28),

            // ── Мессеж илгээх ───────────────────────────
            Text(
              isMn ? 'Мессеж илгээх' : 'Send Message',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _messageCtrl,
              label: isMn
                  ? 'Таны асуулт эсвэл санал'
                  : 'Your question or feedback',
              hint: isMn ? 'Энд бичнэ үү...' : 'Write here...',
              prefixIcon: Icons.message_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: isMn ? 'Илгээх' : 'Send',
              onPressed: _sendMessage,
              isLoading: _sending,
              icon: Icons.send_rounded,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontFamily: 'Gilroy')),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy')),
            ],
          ),
        ],
      );
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
                                  Text(n['title'] ?? '',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(n['body'] ?? '',
                                      style: AppTextStyles.caption,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
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
