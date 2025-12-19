import 'dart:typed_data';

import 'package:equatable/equatable.dart';

sealed class FDLImage extends Equatable {}

class FDLImageAsset extends FDLImage {
  final String assetPath;

  FDLImageAsset({required this.assetPath});
  @override
  List<Object?> get props => [assetPath];
}

class FDLImageNetwork extends FDLImage {
  final String url;
  FDLImageNetwork({required this.url});
  @override
  List<Object?> get props => [url];
}

class FDLImageFile extends FDLImage {
  final String filePath;
  FDLImageFile({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}

class FDLImageBytes extends FDLImage {
  final Uint8List bytes;
  FDLImageBytes({required this.bytes});
  @override
  List<Object?> get props => [bytes];
}
