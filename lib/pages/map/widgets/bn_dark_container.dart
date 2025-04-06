import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

typedef TileBuilder = Widget Function(
    BuildContext context, Widget tileWidget, TileImage tile);

/// Applies inversion color matrix on Tiles container which may simulate Dark mode.
Widget bnDarkModeTilesContainerBuilder(
  BuildContext context,
  Widget tilesContainer,
) {
  if (kIsWeb) {
    return ColorFiltered(
      /*
      Construct a color filter that transforms a color by a 5x5 matrix, where the fifth row is implicitly added in an identity configuration.
Every pixel's color value, represented as an <code>R, G, B, A</code>, is matrix multiplied to create a new color:
    | R' |   | a00 a01 a02 a03 a04 |   | R |
    | G' |   | a10 a11 a22 a33 a44 |   | G |
    | B' | = | a20 a21 a22 a33 a44 | * | B |
    | A' |   | a30 a31 a22 a33 a44 |   | A |
    | 1  |   |  0   0   0   0   1  |   | 1 |
The matrix is in row-major order and the translation column is specified in unnormalized, 0...255, space. For example, the identity matrix is:
       */

      colorFilter: const ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tilesContainer,
    );
  }

  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      //Colors get Inverted and then Hue Rotated by 180 degrees
      0.5740000009536743, -1.4299999475479126, -0.14399999380111694, 0, 255, //R
      -0.4259999990463257, -0.429999977350235, -0.14399999380111694, 0, 255, //G
      -0.4259999990463257, -1.4299999475479126, 0.8559999465942383, 0, 255, //B
      0, 0, 0, 1, 0, //A
    ]),
    child: tilesContainer,
  );
}

/// Applies inversion color matrix on Tiles which may simulate Dark mode.
/// [darkModeTilesContainerBuilder] is better at performance because it applies color matrix on the container instead of on every Tile
Widget darkModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ]),
    child: tileWidget,
  );
}

/// Shows coordinates over Tiles
Widget coordinateDebugTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  final coordinates = tile.coordinates;
  final readableKey =
      '${coordinates.x.floor()} : ${coordinates.y.floor()} : ${coordinates.z.floor()}';

  return Container(
    decoration: BoxDecoration(
      border: Border.all(),
    ),
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        tileWidget,
        Center(
          child: Text(
            readableKey,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    ),
  );
}

/// Shows the Tile loading time in ms
Widget loadingTimeDebugTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  final loadStarted = tile.loadStarted;
  final loaded = tile.loadFinishedAt;

  final time = loaded == null
      ? 'Loading'
      : '${(loaded.millisecond - loadStarted!.millisecond).abs()} ms';

  return Container(
    decoration: BoxDecoration(
      border: Border.all(),
    ),
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        tileWidget,
        Center(
          child: Text(
            time,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    ),
  );
}
