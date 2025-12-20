import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'user_stats.dart';
import 'user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColors.primaryYellow,
                      size: 32,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Text(
                      'My Profile',
                      style: AppTextStyles.h1,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Profile Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryYellow,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: AppColors.primaryYellow,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Name
                      Text(
                        UserService.currentUser.name,
                        style: AppTextStyles.h1,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        UserService.currentUser.bio,
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // User Info Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.email, 'Email', UserService.currentUser.email),
                      const Divider(color: AppColors.lightBlue, height: 32),
                      _buildInfoRow(Icons.school, 'University', UserService.currentUser.university),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('${UserStats.moviesRated}', 'Movies Rated'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildStatCard('${UserStats.reviewsWritten}', 'Reviews'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildStatCard('${UserStats.groupsJoined}', 'Groups'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Logout Button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error, width: 2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.cardBackground,
                          title: const Text(
                            'Logout',
                            style: AppTextStyles.h3,
                          ),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: AppTextStyles.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                      (route) => false,
                                );
                              },
                              child: Text(
                                'Logout',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Logout',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/browse');
              break;
            case 2:
              Navigator.pushNamed(context, '/chat-groups');
              break;
            case 3:
            // Already on Profile
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryYellow, size: 24),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xs),
              Text(value, style: AppTextStyles.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.primaryYellow,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}