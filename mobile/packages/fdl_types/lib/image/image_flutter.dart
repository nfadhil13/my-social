import 'dart:io';

import 'package:fdl_types/image/image.dart';
import 'package:flutter/material.dart';

extension FDLImageProviderExtension on FDLImage {
  ImageProvider get provider {
    return switch (this) {
      FDLImageAsset(assetPath: final assetPath) => AssetImage(assetPath),
      FDLImageNetwork(url: final url) => NetworkImage(url),
      FDLImageFile(filePath: final filePath) => FileImage(File(filePath)),
      FDLImageBytes(bytes: final bytes) => MemoryImage(bytes),
    };
  }
}
