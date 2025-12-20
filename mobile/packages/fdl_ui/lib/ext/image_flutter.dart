import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fdl_types/fdl_types.dart';

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
