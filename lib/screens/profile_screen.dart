import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../widgets/common_widgets.dart';
import 'auth_screens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Профайл'), centerTitle: true),
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
                                AppColors.primaryLight,
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
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _profile?.fullName ?? '—',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profile?.phone ?? '—',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_profile?.isVerified == true) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Баталгаажсан',
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
                            label: 'Зээлийн оноо',
                            value: '${_profile?.creditScore ?? 0}',
                            suffix: '/850',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white24,
                          ),
                          _ScoreItem(
                            label: 'Зэрэглэл',
                            value: _profile?.creditScoreLabel ?? '—',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white24,
                          ),
                          _ScoreItem(
                            label: 'Орлого',
                            value: AppUtils.formatCurrencyShort(
                              _profile?.monthlyIncome ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal info
                    _SectionCard(
                      title: 'Хувийн мэдээлэл',
                      icon: Icons.person_outline,
                      children: [
                        InfoRow(
                          label: 'Регистр',
                          value: _profile?.registerNumber ?? '—',
                        ),
                        InfoRow(
                          label: 'Ажлын байр',
                          value: AppUtils.getEmploymentTypeLabel(
                            _profile?.employmentType,
                          ),
                        ),
                        InfoRow(
                          label: 'Ажил олгогч',
                          value: _profile?.employerName ?? '—',
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Menu items
                    _SectionCard(
                      title: 'Тохиргоо',
                      icon: Icons.settings_outlined,
                      children: [
                        _MenuItem(
                          icon: Icons.edit_outlined,
                          label: 'Мэдээлэл засах',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline,
                          label: 'Нууц үг солих',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          label: 'Мэдэгдлийн тохиргоо',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          label: 'Тусламж & Холбоо барих',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Logout
                    AppButton(
                      label: 'Гарах',
                      onPressed: () async {
                        await SupabaseService.signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
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

class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;

  const _ScoreItem({
    required this.label,
    required this.value,
    this.suffix = '',
  });

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
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
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
              fontFamily: 'Gilroy',
            ),
          ),
        ],
      );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

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

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textHint,
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

  final _employmentTypes = [
    {'value': 'employee', 'label': 'Ажилтан'},
    {'value': 'self_employed', 'label': 'Өөрөө ажиллагч'},
    {'value': 'business_owner', 'label': 'Бизнес эзэмшигч'},
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
        AppSnackbar.show(context, 'Мэдээлэл амжилттай хадгалагдлаа!');
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.show(context, 'Хадгалахад алдаа гарлаа', isError: true);
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
        title: const Text('Мэдээлэл засах'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppTextField(
              controller: _emailCtrl,
              label: 'И-мэйл',
              hint: 'email@example.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _employmentType,
              decoration: InputDecoration(
                labelText: 'Ажлын төрөл',
                prefixIcon: const Icon(
                  Icons.work_outline,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              items: _employmentTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t['value'],
                      child: Text(t['label']!),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _employmentType = v),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _employerCtrl,
              label: 'Ажил олгогчийн нэр',
              prefixIcon: Icons.business_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _incomeCtrl,
              label: 'Сарын орлого (₮)',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _addressCtrl,
              label: 'Гэрийн хаяг',
              prefixIcon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            AppButton(label: 'Хадгалах', onPressed: _save, isLoading: _loading),
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
        title: const Text('Мэдэгдлүүд'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            )
          : _notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 12),
                      Text('Мэдэгдэл байхгүй', style: AppTextStyles.body),
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
                              child: Icon(
                                _getIcon(n['type']),
                                color: color,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n['title'] ?? '',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
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
                                      DateTime.parse(n['created_at']),
                                    ),
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 11,
                                    ),
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
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
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
