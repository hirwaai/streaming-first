import 'package:flutter/material.dart';

import 'models.dart';

void main() {
  runApp(const LiveStreamApp());
}

class LiveStreamApp extends StatelessWidget {
  const LiveStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FF),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeTab(),
    GuideTab(),
    FavoritesTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Guide'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favoris'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static final List<Channel> _channels = [
    Channel(
      id: 1,
      name: 'Sport Live',
      category: 'Sport',
      status: 'Live',
      description: 'Direct du match de la journée.',
      tagline: 'Interviews et analyses en direct',
      color: 0xFF2563EB,
      schedule: [
        const ProgramSlot(title: 'Match du jour', time: '18:00', description: 'Match de coupe'),
        const ProgramSlot(title: 'Le journal', time: '20:00', description: 'Informations sportives'),
      ],
    ),
    Channel(
      id: 2,
      name: 'News 24',
      category: 'Info',
      status: 'Live',
      description: 'Info en continu et analyses.',
      tagline: 'L’actualité en direct',
      color: 0xFF10B981,
      schedule: [
        const ProgramSlot(title: 'Actualités', time: '19:00', description: 'Le monde aujourd’hui'),
      ],
    ),
    Channel(
      id: 3,
      name: 'Mood TV',
      category: 'Divertissement',
      status: 'Hors ligne',
      description: 'Culture et divertissement.',
      tagline: 'Les meilleurs divertissements',
      color: 0xFFF59E0B,
      schedule: [
        const ProgramSlot(title: 'Mieux vivre', time: '21:00', description: 'Le talk de la semaine'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'StreamHub',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundColor: const Color(0xFFEEF2FF),
                  child: Icon(Icons.notifications_none, color: Theme.of(context).primaryColor),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Chaînes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _channels.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final channel = _channels[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(channel.color),
                        child: Text(
                          channel.name.substring(0, 1),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(channel.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(channel.category),
                          const SizedBox(height: 6),
                          Text(channel.description),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: channel.status == 'Live' ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          channel.status,
                          style: TextStyle(
                            color: channel.status == 'Live' ? const Color(0xFF166534) : const Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChannelDetailScreen(channel: channel),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChannelDetailScreen extends StatelessWidget {
  const ChannelDetailScreen({super.key, required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channel.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(channel.color).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(channel.tagline, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(channel.description),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Regarder le flux'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Programme', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: channel.schedule.length,
                itemBuilder: (context, index) {
                  final slot = channel.schedule[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(slot.time, style: const TextStyle(fontWeight: FontWeight.w700))),
                      ),
                      title: Text(slot.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(slot.description),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GuideTab extends StatelessWidget {
  const GuideTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'time': '18:00', 'title': 'Match du jour', 'channel': 'Sport Live'},
      {'time': '19:00', 'title': 'Actualités', 'channel': 'News 24'},
      {'time': '20:00', 'title': 'Le journal', 'channel': 'Sport Live'},
      {'time': '21:00', 'title': 'Mieux vivre', 'channel': 'Mood TV'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Guide des programmes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEEF2FF),
                        child: Text(item['time']!.substring(0, 2)),
                      ),
                      title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(item['channel']!),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    const favorites = ['Sport Live', 'News 24'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mes chaînes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: favorites
                    .map(
                      (favorite) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text(favorite),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  static const user = AppUser(
    name: 'Alice Martin',
    email: 'alice@streamhub.app',
    lang: 'Français',
    avatar: 'AM',
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: const Color(0xFF4F46E5),
                child: Text(user.avatar, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Nom'),
              subtitle: Text(user.name),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user.email),
            ),
            ListTile(
              title: const Text('Langue'),
              subtitle: Text(user.lang),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
