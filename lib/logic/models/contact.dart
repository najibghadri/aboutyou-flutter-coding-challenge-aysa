class Contact {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isPinned;

  Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isPinned = false,
  });
}
