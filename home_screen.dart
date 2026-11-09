
import 'package:flutter/material.dart';
import '../services/platform_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController linkController =
      TextEditingController();

  String? detectedPlatform;
  String message = 'Paste your video link here';

  void detectLink() {
    final link = linkController.text.trim();

    final platform = PlatformDetector.detect(link);

    setState(() {
      detectedPlatform = platform;
      message = platform == null
          ? 'Invalid or unsupported link'
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
      appBar: AppBar(
        title: const Text(
          'ALL VIDEO DOWNLOADER',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1769FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 25),
          const Icon(
            Icons.cloud_download,
            size: 90,
            color: Color(0xFF1769FF),
          ),
          const SizedBox(height: 20),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: linkController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Paste video URL',
              prefixIcon: const Icon(Icons.link),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: detectLink,
              icon: const Icon(Icons.search),
              label: const Text('DETECT PLATFORM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1769FF),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 35,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  Text(message),
                  if (detectedPlatform != null)
                    Text(
                      detectedPlatform!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: PlatformDetector.supportedPlatforms
                .map((name) => Chip(
                      avatar: const Icon(
                        Icons.play_circle_outline,
                        color: Colors.blue,
                      ),
                      label: Text(name),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
