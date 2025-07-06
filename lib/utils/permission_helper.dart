import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final OnAudioQuery _audioQuery = OnAudioQuery();

  static Future<bool> requestAudioPermission() async {
    if (!await _audioQuery.permissionsStatus()) {
      await _audioQuery.permissionsRequest();
    }

    return await Permission.audio.isGranted;
  }
}
