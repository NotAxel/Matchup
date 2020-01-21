import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class TestAssetBundle extends CachingAssetBundle {
  TestAssetBundle(Map<String, List<String>> assets) : _assets = assets {
    for (String assetList in assets.keys) {
      for (String asset in assets[assetList]) {
        _assetMap[asset] = bytesForFile(asset);
      }
    }
  }

  final Map<String, ByteData> _assetMap = <String, ByteData>{};
  final Map<String, List<String>> _assets;

  @override
  Future<ByteData> load(String key) {
    if (key == 'AssetManifest.json') {
      return Future<ByteData>.value(bytesForJsonLike(_assets));
    }
    return Future<ByteData>.value(_assetMap[key]);
  }
}

ByteData bytesForJsonLike(Map<String, dynamic> jsonLike) => ByteData.view(
    Uint8List.fromList(const Utf8Encoder().convert(json.encode(jsonLike)))
        .buffer);

ByteData bytesForFile(String path) => ByteData.view(
    Uint8List.fromList(File(path).readAsBytesSync()).buffer);