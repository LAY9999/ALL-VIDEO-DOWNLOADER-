
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<String> downloadDirectMp4(
    String url, {
    String? fileName,
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme)) {
      throw Exception('Invalid download URL');
    }

    final directory = await getApplicationDocumentsDirectory();

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

    if (!safeName.toLowerCase().endsWith('.mp4')) {
      safeName = '$safeName.mp4';
    }

    final savePath =
        '${downloadDirectory.path}/$safeName';

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
          receiveTimeout: const Duration(minutes: 10),
          headers: {
            'Accept': 'video/mp4, video/*, */*',
          },
        ),
      );

      final contentType = response.headers
          .value(Headers.contentTypeHeader)
          ?.toLowerCase();

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw Exception('Download failed');
      }

      if (contentType != null &&
          (contentType.contains('text/html') ||
           contentType.contains('application/json'))) {
        await File(savePath).delete();
        throw Exception('The URL does not provide a video file');
      }

      final file = File(savePath);

      if (!await file.exists() || await file.length() == 0) {
        throw Exception('Downloaded file is empty');
      }

      return savePath;
    } catch (error) {
      final file = File(savePath);

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
