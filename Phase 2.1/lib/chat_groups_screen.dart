import 'package:flutter/material.dart';
import 'chat_group.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class ChatGroupsScreen extends StatelessWidget {
  const ChatGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = ChatGroup.getSampleGroups();
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? AppSpacing.md : AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat,
                    color: AppColors.primaryYellow,
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Text(
                    'Chat Groups',
                    style: AppTextStyles.h1,
                  ),
                ],
              ),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: const Text(
                'Join groups to discuss movies with fellow students',
                style: AppTextStyles.subtitle,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Groups List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      color: AppColors.cardBackground,
                      elevation: AppSpacing.elevationSm,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/group-chat',
                            arguments: group,
                          );
                        },
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              // Group Icon
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.primaryYellow,
                                backgroundImage: NetworkImage(group.iconUrl),
                                onBackgroundImageError: (exception, stackTrace) {},
                                child: Text(
                                  group.name[0],
                                  style: AppTextStyles.h2.copyWith(
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Group Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      group.lastMessage,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Time and Member Count
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    group.timeAgo,
                                    style: AppTextStyles.caption,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 16,
                                        color: AppColors.textHint,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        '${group.memberCount}',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/browse');
              break;
            case 2:
            // Already on Chat Groups
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
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
}