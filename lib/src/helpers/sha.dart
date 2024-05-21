import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

abstract class SHA {
  static String getSHA256Str(String str) {
    final bytes = utf8.encode(str); // Convert string to bytes
    final digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return byte2Hex(Uint8List.fromList(digest.bytes)); // Convert bytes to hex string
  }

  static String byte2Hex(Uint8List bytes) {
    final stringBuffer = StringBuffer();
    for (int byte in bytes) {
      final hex = byte.toRadixString(16).padLeft(2, '0');
      stringBuffer.write(hex);
    }
    return stringBuffer.toString();
  }
}
