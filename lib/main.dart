import 'dart:math';
import 'dart:ui' as ui;

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/core/constants/predefined_cities.dart';
import 'package:cargo_quest_tycoon/data/models/city.dart';
import 'package:cargo_quest_tycoon/widgets/two_dimensional_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: ui.PointerDeviceKind.values.toSet(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page XD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ui.Image? image;

  Future<void> loadImage() async {
    const keyName = 'assets/custom_map.jpeg';
    // const keyName = 'assets/island.png';
    // const keyName = 'assets/other_map.jpeg';
    final data = (await rootBundle.load(keyName));
    final bytes = data.buffer.asUint8List();
    image = await decodeImageFromList(bytes);
    setState(() {});
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TwoDimensionalGridView(
        diagonalDragBehavior: DiagonalDragBehavior.free,
        itemHeight: GameConstants.mapTileSizeX,
        itemWidth: GameConstants.mapTileSizeY,
        delegate: TwoDimensionalChildBuilderDelegate(
          maxXIndex: GameConstants.mapXSize - 1,
          maxYIndex: GameConstants.mapYSize - 1,
          builder: (context, vicinity) {
            final city = defaultMapTiles.where((element) {
              return element.position.x == vicinity.xIndex &&
                  element.position.y == vicinity.yIndex;
            }).firstOrNull;
            return Container(
              height: GameConstants.mapTileSizeY,
              width: GameConstants.mapTileSizeX,
              color: city?.type.color,
              child: Center(
                child: Text(
                  '${city?.type.name}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    //   body: InteractiveViewer(
    //     maxScale: 2.0,
    //     minScale: 0.1,
    //     constrained: false,
    //     // alignment: Alignment.center,
    //     child: GestureDetector(
    //       onTapUp: (details) {
    //         for (final place in predefinedCities) {
    //           if (place.isTapped(details.globalPosition)) {
    //             print('Is tapped with global position');
    //           }
    //           if (place.isTapped(details.localPosition)) {
    //             print('Is tapped with local position');
    //           }
    //         }
    //       },
    //       child: CustomPaint(
    //         size: Size.square(2048),
    //         painter: MapPainter(predefinedCities, image),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MapPainter extends CustomPainter {
  final List<City> places;
  final ui.Image? image;

  MapPainter(this.places, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final _image = image;
    if (_image != null) {
      canvas.drawImage(
        _image,
        Offset.zero,
        Paint(),
      );
    }

    for (final city in places) {
      canvas.drawCircle(
        Offset(city.position.x, city.position.y),
        20,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
