import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'models.dart';

void main() {
  runApp(const LiveStreamApp());
}

class LiveStreamApp extends StatefulWidget {
  const LiveStreamApp({super.key});

  @override
  State<LiveStreamApp> createState() => _LiveStreamAppState();
}

class _LiveStreamAppState extends State<LiveStreamApp> {
  bool _isAuthenticated = true;

  void _login() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

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
      home: _isAuthenticated
          ? HomeScreen(onLogout: _logout)
          : AuthScreen(onLoginSuccess: _login),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController(text: 'alice@streamhub.app');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isRegistering = false;
  bool _rememberMe = true;
  String? _errorMessage;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage = 'Saisissez une adresse e-mail valide.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Le mot de passe doit contenir au moins 6 caractères.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _loading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });

    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isRegistering ? 'Créer un compte' : 'Connexion';
    final actionLabel = _isRegistering ? 'S’inscrire' : 'Se connecter';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'StreamHub',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text('Live', style: TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Accédez à vos chaînes et à votre guide de programmes.'),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ToggleButtons(
                          isSelected: [_isRegistering == false, _isRegistering == true],
                          onPressed: (index) {
                            setState(() {
                              _isRegistering = index == 1;
                              _errorMessage = null;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: Colors.white,
                          fillColor: const Color(0xFF4F46E5),
                          constraints: const BoxConstraints(minHeight: 48, minWidth: 120),
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text('Connexion'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text('Inscription'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text('Se souvenir de moi'),
                        ],
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Color(0xFFB91C1C)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _submit,
                          icon: _loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.arrow_forward_rounded),
                          label: Text(actionLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeTab(),
      const GuideTab(),
      const FavoritesTab(),
      ProfileTab(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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
      schedule: const [
        ProgramSlot(title: 'Match du jour', time: '18:00', description: 'Match de coupe'),
        ProgramSlot(title: 'Le journal', time: '20:00', description: 'Informations sportives'),
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
      schedule: const [
        ProgramSlot(title: 'Actualités', time: '19:00', description: 'Le monde aujourd’hui'),
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
      schedule: const [
        ProgramSlot(title: 'Mieux vivre', time: '21:00', description: 'Le talk de la semaine'),
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerScreen(channel: channel),
                        ),
                      );
                    },
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

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.channel});

  final Channel channel;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;
  String _quality = '720p';
  bool _playerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _playerReady = true;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _playerReady = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.channel.name} live'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _playerReady
                ? VideoPlayer(_controller)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam_off, color: Colors.white70, size: 40),
                          SizedBox(height: 8),
                          Text('Flux vidéo indisponible', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _playerReady
                      ? () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        }
                      : null,
                  icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_controller.value.isPlaying ? 'Pause' : 'Lecture'),
                ),
                DropdownButton<String>(
                  value: _quality,
                  items: const [
                    DropdownMenuItem(value: '240p', child: Text('240p')),
                    DropdownMenuItem(value: '480p', child: Text('480p')),
                    DropdownMenuItem(value: '720p', child: Text('720p')),
                    DropdownMenuItem(value: '1080p', child: Text('1080p')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _quality = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
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
  const ProfileTab({super.key, required this.onLogout});

  final VoidCallback onLogout;

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
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
