import 'dart:convert';

import 'package:flutter/cupertino.dart';

Future<List<String>> listAssets(BuildContext context) async {
  final manifestContent =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Filter by path
  final filtered = manifestMap.keys
      .where(
          (path) => path.startsWith('assets/maptiles') && path.endsWith('jpg'))
      .toList();
  return filtered;
}
