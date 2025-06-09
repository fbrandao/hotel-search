import 'dart:io';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class TestPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    final tempDir = Directory.systemTemp.createTempSync('hotel_booking_test');
    return tempDir.path;
  }

  static Future<void> cleanUp() async {
    final tempDir = await PathProviderPlatform.instance.getApplicationDocumentsPath();
    if (tempDir != null) {
      final dir = Directory(tempDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }
  }
}
