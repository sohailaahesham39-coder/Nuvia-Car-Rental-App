// lib/presentation/screens/home/AppBottomNavigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/AppLocalizations.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Widget child; // إضافة متغير child للمحتوى

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.child, // إضافة متغير child كمطلوب
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: child, // استخدام child كمحتوى الـ Scaffold
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  if (currentIndex != 0) context.go('/home');
                  break;
                case 1:
                  if (currentIndex != 1) context.go('/explore');
                  break;
                case 2:
                  if (currentIndex != 2) context.go('/my-bookings');
                  break;
                case 3:
                  if (currentIndex != 3) context.go('/chat');
                  break;
                case 4:
                  if (currentIndex != 4) context.go('/profile');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.w),
                activeIcon: Icon(Icons.home, size: 24.w),
                label: l10n.home,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined, size: 24.w),
                activeIcon: Icon(Icons.explore, size: 24.w),
                label: l10n.explore,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined, size: 24.w),
                activeIcon: Icon(Icons.calendar_today, size: 24.w),
                label: l10n.bookings,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined, size: 24.w),
                activeIcon: Icon(Icons.chat, size: 24.w),
                label: l10n.chat,
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 24.w),
                activeIcon: Icon(Icons.person, size: 24.w),
                label: l10n.profile,
                backgroundColor: Colors.white,
              ),
            ],
            // تخصيص الألوان
            selectedItemColor: theme.colorScheme.primary, // لون العنصر النشط
            unselectedItemColor: Colors.grey.shade600, // لون العناصر غير النشطة
            backgroundColor: Colors.white, // خلفية شريط التنقل
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed, // يضمن ظهور جميع العناصر
            elevation: 8.0, // يضيف ظل خفيف للعمق
            selectedIconTheme: IconThemeData(
              size: 28.w,
            ),
            // تأثير الارتداد عند النقر
            enableFeedback: true,
          ),
        ),
      ),
    );
  }
}