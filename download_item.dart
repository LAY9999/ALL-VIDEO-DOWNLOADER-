
class DownloadItem {
  final String id;
  final String title;
  final String url;
  final String platform;
  final String filePath;
  final String status;
  final double progress;
  final DateTime createdAt;

  const DownloadItem({
    required this.id,
    required this.title,
    required this.url,
    required this.platform,
    this.filePath = '',
    this.status = 'pending',
    this.progress = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'platform': platform,
      'filePath': filePath,
      'status': status,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DownloadItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return DownloadItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      filePath: json['filePath'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(
        json['createdAt'] as String? ?? '',
      ) ?? DateTime.now(),
    );
  }

  DownloadItem copyWith({
    String? title,
    String? filePath,
    String? status,
    double? progress,
  }) {
    return DownloadItem(
      id: id,
      title: title ?? this.title,
      url: url,
      platform: platform,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt,
    );
  }
}
