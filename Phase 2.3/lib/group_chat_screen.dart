import 'package:flutter/material.dart';
import 'chat_group.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as ChatGroup;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryYellow,
              backgroundImage: NetworkImage(group.iconUrl),
              onBackgroundImageError: (exception, stackTrace) {},
              child: Text(
                group.name[0],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  Text(
                    '${group.memberCount} members',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages Area (Empty State)
          Expanded(
            child: Container(
              color: AppColors.backgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Start the conversation',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Be the first to send a message',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                top: BorderSide(color: AppColors.lightBlue, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                      color: AppColors.textHint,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.subtitle,
                        filled: true,
                        fillColor: AppColors.lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          // Send message logic
                          _messageController.clear();
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}