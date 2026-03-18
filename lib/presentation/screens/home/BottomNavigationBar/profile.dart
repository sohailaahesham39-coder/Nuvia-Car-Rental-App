import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../l10n/AppLocalizations.dart';
import '../../../../providers/LocaleProvider.dart';
import '../../../../providers/ThemeProvider.dart';
import '../../../../providers/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if user is authenticated
    if (!authProvider.isAuthenticated || authProvider.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/sign-in');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Fetch user data from AuthProvider
    final currentUser = authProvider.currentUser!;
    final userProfileUrl = currentUser.profileImageUrl ??
        'https://i.pinimg.com/564x/94/df/a7/94dfa7b8d24e1b8944b663d2777e4c1f.jpg';
    final userName = currentUser.fullName;
    final userEmail = currentUser.email;
    final userPhone = currentUser.phoneNumber ?? l10n.notAvailable;
    final memberSince = currentUser.createdAt.year.toString();

    // Mock user stats (replace with real data from a service)
    final userStats = {
      'trips': '12',
      'rating': '4.8',
      'favorites': '${currentUser.favoriteCarIds.length}',
    };

    return Directionality(
      textDirection: l10n.localeName == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // AppBar with gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(l10n.profile, style: const TextStyle(fontWeight: FontWeight.bold)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: l10n.editProfile,
                  onPressed: () => context.push('/complete-profile'),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: FadeInUp(
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // User Avatar with animation
                          ZoomIn(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: userProfileUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userEmail,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userPhone,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${l10n.memberSince} $memberSince',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stats Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(context, Icons.directions_car, userStats['trips']!, l10n.trips),
                          _buildStatCard(context, Icons.star, userStats['rating']!, l10n.rating),
                          _buildStatCard(context, Icons.favorite, userStats['favorites']!, l10n.favorites),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Menu Options
                    _buildProfileMenuItem(
                      context,
                      Icons.account_circle,
                      l10n.personalInformation,
                          () => context.push('/complete-profile'), // Use the correct route path with hyphen
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      Icons.payment,
                      l10n.paymentMethods,
                          () => context.push('/payment-methods'),
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      Icons.notifications,
                      l10n.notifications,
                          () => context.push('/notifications'),
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      Icons.language,
                      l10n.language,
                          () => _showLanguageDialog(context, localeProvider),
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      themeProvider.themeMode == ThemeMode.dark
                          ? l10n.lightMode
                          : l10n.darkMode,
                          () => themeProvider.toggleTheme(),
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      Icons.help_outline,
                      l10n.helpSupport,
                          () => context.push('/help-support'),
                    ),
                    _buildDivider(),
                    _buildProfileMenuItem(
                      context,
                      Icons.info_outline,
                      l10n.aboutUs,
                          () => context.push('/about-us'),
                    ),
                    _buildDivider(),
                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () => _showLogoutDialog(context, authProvider),
                        icon: const Icon(Icons.logout),
                        label: Text(l10n.logout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
      indent: 16,
      endIndent: 16,
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/ba/ea/67/baea676a31aa43faa034a734a621add1.jpg',
                ),
              ),
              title: const Text('English'),
              trailing: localeProvider.locale?.languageCode == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                localeProvider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/87/1a/91/871a91c988d513dcc5a3c96bf120459a.jpg',
                ),
              ),
              title: const Text('العربية'),
              trailing: localeProvider.locale?.languageCode == 'ar'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                localeProvider.setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.signOut();
              if (!context.mounted) return;
              Navigator.pop(context);
              context.go('/sign-in');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}