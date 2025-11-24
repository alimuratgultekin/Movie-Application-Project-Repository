class ChatGroup {
  final String id;
  final String name;
  final String lastMessage;
  final String timeAgo;
  final int memberCount;
  final String iconUrl;

  ChatGroup({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeAgo,
    required this.memberCount,
    required this.iconUrl,
  });

  static List<ChatGroup> getSampleGroups() {
    return [
      ChatGroup(
        id: '1',
        name: 'Horror Movie Fans',
        lastMessage: 'Just watched The Conjuring, so scary!',
        timeAgo: '2 min ago',
        memberCount: 24,
        iconUrl: 'https://via.placeholder.com/100/5C6BC0/FFFFFF?text=H',
      ),
      ChatGroup(
        id: '2',
        name: 'Sci-Fi Enthusiasts',
        lastMessage: 'Inception is mind-blowing!',
        timeAgo: '15 min ago',
        memberCount: 31,
        iconUrl: 'https://via.placeholder.com/100/42A5F5/FFFFFF?text=SF',
      ),
      ChatGroup(
        id: '3',
        name: 'Classic Cinema Club',
        lastMessage: 'Who\'s watching Casablanca tonight?',
        timeAgo: '1 hour ago',
        memberCount: 18,
        iconUrl: 'https://via.placeholder.com/100/26A69A/FFFFFF?text=CC',
      ),
    ];
  }
}