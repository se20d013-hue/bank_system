import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'loan_products_screen.dart';
import 'my_loans_screen.dart';
import 'ai_chat_screen.dart';
import 'profile_screen.dart';

// =============================================
// BOTTOM NAVIGATION WRAPPER
// =============================================
class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  static const _bg = Color(0xFF12121D);
  static const _navBg = Color(0xFF1A1A2E);
  static const _purple = Color(0xFF8A2BE2);

  final List<Widget> _screens = const [
    HomeScreen(),
    MyLoansScreen(),
    LoanProductsScreen(),
    AiChatScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _navBg,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.grid_view_rounded,
                activeIcon: Icons.grid_view_rounded,
                label: 'Нүүр',
                index: 0,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              _NavItem(
                icon: Icons.credit_card_outlined,
                activeIcon: Icons.credit_card_rounded,
                label: 'Зээл',
                index: 1,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              // ── Бүтээгдэхүүн (голд, том товч) ──
              _CenterNavItem(
                isActive: _currentIndex == 2,
                onTap: () => _onTap(2),
              ),
              // ── AI Chat ──────────────────────────
              _NavItem(
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome_rounded,
                label: 'AI',
                index: 3,
                currentIndex: _currentIndex,
                onTap: _onTap,
                badge: true, // ✅ "Шинэ" badge
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Профайл',
                index: 4,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

// ── Энгийн nav item ──────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, currentIndex;
  final ValueChanged<int> onTap;
  final bool badge;

  static const _purple = Color(0xFF8A2BE2);

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _purple.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  active ? activeIcon : icon,
                  color: active ? _purple : Colors.grey,
                  size: 24,
                ),
                // "Шинэ" badge
                if (badge && !active)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? _purple : Colors.grey,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Голын том товч (Бүтээгдэхүүн) ────────────────
class _CenterNavItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterNavItem({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [Color(0xFF8A2BE2), Color(0xFF4A00E0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF6B21A8), Color(0xFF3730A3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(0xFF8A2BE2).withOpacity(isActive ? 0.5 : 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Бүтээгдэхүүн',
            style: TextStyle(
              color: isActive ? const Color(0xFF8A2BE2) : Colors.grey,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
