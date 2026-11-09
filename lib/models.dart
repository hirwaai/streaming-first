class ProgramSlot {
  const ProgramSlot({
    required this.title,
    required this.time,
    required this.description,
  });

  final String title;
  final String time;
  final String description;
}

class Channel {
  const Channel({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.description,
    required this.tagline,
    required this.color,
    required this.schedule,
  });

  final int id;
  final String name;
  final String category;
  final String status;
  final String description;
  final String tagline;
  final int color;
  final List<ProgramSlot> schedule;
}

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.lang,
    required this.avatar,
  });

  final String name;
  final String email;
  final String lang;
  final String avatar;
}
