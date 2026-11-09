
class PlatformDetector {
  static const Map<String, List<String>> platforms = {
    'Facebook': [
      'facebook.com',
      'fb.watch',
    ],
    'TikTok': [
      'tiktok.com',
    ],
    'Instagram': [
      'instagram.com',
    ],
    'Telegram': [
      't.me',
      'telegram.me',
    ],
    'X (Twitter)': [
      'x.com',
      'twitter.com',
    ],
    'YouTube': [
      'youtube.com',
      'youtu.be',
      'youtube-nocookie.com',
    ],
  };

  static String? detect(String input) {
    final url = Uri.tryParse(input.trim());

    if (url == null ||
        !url.hasAuthority ||
        !['http', 'https'].contains(url.scheme)) {
      return null;
    }

    final host = url.host.toLowerCase();

    for (final entry in platforms.entries) {
      for (final domain in entry.value) {
        if (host == domain || host.endsWith('.$domain')) {
          return entry.key;
        }
      }
    }

    return null;
  }

  static bool isSupported(String input) {
    return detect(input) != null;
  }

  static List<String> get supportedPlatforms {
    return platforms.keys.toList();
  }
}
