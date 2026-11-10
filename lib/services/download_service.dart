
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 10),
      sendTimeout: const Duration(seconds: 30),
      followRedirects: true,
      maxRedirects: 5,
      headers: {
        'Accept': 'video/mp4, video/*, application/octet-stream, */*',
      },
    ),
  );

  Future<String> downloadDirectMp4(
    String url, {
    String? fileName,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      throw Exception('Invalid download URL');
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final downloadDirectory = Directory(
      '${directory.path}/Downloads',
    );

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    String safeName = fileName ??
        'video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    safeName = safeName.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );

    if (safeName.isEmpty) {
      safeName =
          'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    }

    if (!safeName.toLowerCase().endsWith('.mp4')) {
      safeName = '$safeName.mp4';
    }

    final savePath =
        '${downloadDirectory.path}/$safeName';

    final file = File(savePath);

    try {
      final response = await _dio.download(
        uri.toString(),
        savePath,
        cancelToken: cancelToken,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          onProgress?.call(received, total);
        },
        options: Options(
          followRedirects: true,
          maxRedirects: 5,
          receiveTimeout: const Duration(minutes: 10),
          headers: {
            'Accept':
                'video/mp4, video/*, application/octet-stream, */*',
          },
        ),
      );

      final statusCode = response.statusCode;

      if (statusCode == null ||
          statusCode < 200 ||
          statusCode >= 300) {
        throw Exception(
          'Server returned status code: $statusCode',
        );
      }

      final contentType = response.headers
          .value(Headers.contentTypeHeader)
          ?.toLowerCase();

      if (contentType != null &&
          (contentType.contains('text/html') ||
           contentType.contains('application/json') ||
           contentType.contains('text/plain'))) {
        throw Exception(
          'This URL does not provide a direct video file.',
        );
      }

      if (!await file.exists()) {
        throw Exception('Downloaded file was not found');
      }

      final fileSize = await file.length();

      if (fileSize == 0) {
        throw Exception('Downloaded file is empty');
      }

      return savePath;

    } catch (e) {
      if (await file.exists()) {
        await file.delete();
      }

      rethrow;
    }
  }

  void cancelDownload(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel('Download cancelled by user');
    }
  }
}
