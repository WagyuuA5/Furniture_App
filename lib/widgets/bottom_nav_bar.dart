// lib/widgets/bottom_nav_bar.dart
// FIX: index 2 → ChatListScreen (bukan _ChatPlaceholder lagi)

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../screens/cart_screen.dart';
import '../screens/chat_list_screen.dart'; // ← FIX: uncomment + import nyata

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded,                label: 'Beranda',   index: 0),
    _NavItem(icon: Icons.shopping_cart_outlined,      label: 'Keranjang', index: 1),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat',      index: 2),
    _NavItem(icon: Icons.person_outline_rounded,      label: 'Profil',    index: 3),
  ];

  void _handleTap(BuildContext context, int index) {
    widget.onTap(index);
  }

  PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, anim, __) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.navbarBg,
          borderRadius: BorderRadius.circular(AppRadius.bottomNavbar),
          boxShadow: AppShadows.navbar,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _items.length,
            (index) => _NavBarItem(
              item: _items[index],
              isActive: widget.currentIndex == index,
              onTap: () => _handleTap(context, index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) {
        _animController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _animController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: widget.isActive ? 52 : 44,
          height: 52,
          decoration: BoxDecoration(
            color: widget.isActive ? AppColors.darkTeal : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              widget.item.icon,
              color: AppColors.navbarActiveIcon,
              size: widget.isActive ? 24 : 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem(
      {required this.icon, required this.label, required this.index});
}