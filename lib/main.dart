
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'services/download_service.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AllVideoDownloader());
}

class AllVideoDownloader extends StatelessWidget {
  const AllVideoDownloader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALL VIDEO DOWNLOADER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1769FF),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    DownloadScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download),
            label: 'Downloads',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller =
      TextEditingController();

  String platform = '';
  String message = 'Paste your video link here';

  final Map<String, List<String>> platforms = {
    'Facebook': ['facebook.com', 'fb.watch'],
    'TikTok': ['tiktok.com'],
    'Instagram': ['instagram.com'],
    'Telegram': ['t.me', 'telegram.me'],
    'X (Twitter)': ['x.com', 'twitter.com'],
    'YouTube': ['youtube.com', 'youtu.be'],
  };

  void detectPlatform() {
    final input = controller.text.trim();
    final uri = Uri.tryParse(input);

    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme)) {
      setState(() {
        platform = '';
        message = 'Please enter a valid video URL';
      });
      return;
    }

    final host = uri.host.toLowerCase();
    String detected = '';

    for (final entry in platforms.entries) {
      if (entry.value.any((domain) =>
          host == domain || host.endsWith('.$domain'))) {
        detected = entry.key;
        break;
      }
    }

    setState(() {
      platform = detected;
      message = detected.isEmpty
          ? 'Unsupported platform'
          : 'Platform detected successfully';
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1769FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'ALL VIDEO DOWNLOADER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 25),
          const Icon(
            Icons.cloud_download_rounded,
            size: 100,
            color: Color(0xFF1769FF),
          ),
          const SizedBox(height: 15),
          const Text(
            'Download Your Videos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Paste Video Link',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'https://example.com/video.mp4',
              prefixIcon: const Icon(Icons.link),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: detectPlatform,
              icon: const Icon(Icons.search),
              label: const Text('DETECT PLATFORM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1769FF),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 32,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(message),
                  if (platform.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        platform,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'SUPPORTED PLATFORMS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Facebook',
              'TikTok',
              'Instagram',
              'Telegram',
              'X (Twitter)',
              'YouTube',
            ].map((name) {
              return Chip(
                avatar: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.blue,
                ),
                label: Text(name),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          const Text(
            'Only download content you are authorized to save.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Downloads',
      icon: Icons.download,
      description: 'Your active downloads will appear here.',
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Download History',
      icon: Icons.history,
      description: 'Your downloaded video history will appear here.',
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Settings',
      icon: Icons.settings,
      description: 'Manage your application settings.',
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const SimplePage({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1769FF),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 75, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
