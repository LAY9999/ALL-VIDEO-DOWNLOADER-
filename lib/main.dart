
import 'package:flutter/material.dart';

void main() {
  runApp(const AllVideoDownloader());
}

class AllVideoDownloader extends StatelessWidget {
  const AllVideoDownloader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALL VIDEO DOWNLOADER',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1769FF),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController linkController =
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
    final input = linkController.text.trim();
    final uri = Uri.tryParse(input);

    if (uri == null ||
        !uri.hasAuthority ||
        !['https', 'http'].contains(uri.scheme)) {
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
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1769FF),
        foregroundColor: Colors.white,
        title: const Text('ALL VIDEO DOWNLOADER'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.cloud_download_rounded,
                size: 85,
                color: Color(0xFF1769FF),
              ),
              const SizedBox(height: 15),
              const Text(
                'ALL VIDEO DOWNLOADER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Paste Video Link',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://example.com/video',
                  prefixIcon: const Icon(Icons.link),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 52,
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
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(message),
                      if (platform.isNotEmpty)
                        Text(
                          platform,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'SUPPORTED PLATFORMS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
              const SizedBox(height: 30),
              const Text(
                '© 2026 ALL VIDEO DOWNLOADER',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
