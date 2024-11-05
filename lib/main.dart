import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page XD'),
    );
  }
}

class Place {
  final double x;
  final double y;
  final double radius;
  final Color color;

  Place({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
  });

  bool isTapped(Offset tapPoint) {
    if (tapPoint.dx > x - radius &&
        tapPoint.dx < x + radius &&
        tapPoint.dy > y - radius &&
        tapPoint.dy < y + radius) {
      return true;
    }

    return false;
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

  List<Place> places = [];

  Future<void> loadImage() async {
    print('Load image');
    // const keyName = 'assets/custom_map.jpeg';
    // const keyName = 'assets/island.png';
    const keyName = 'assets/other_map.jpeg';
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
      body: InteractiveViewer(
        maxScale: 2.0,
        minScale: 0.1,
        constrained: false,
        // alignment: Alignment.center,
        child: GestureDetector(
          onTapUp: (details) {
            print('Global: ${details.globalPosition}');
            print('Local: ${details.localPosition}');
            for (final place in places) {
              if (place.isTapped(details.globalPosition)) {
                print('Is tapped with global position');
              }
              if (place.isTapped(details.localPosition)) {
                print('Is tapped with local position');
              }
            }
          },
          child: CustomPaint(
            size: Size.square(4096),
            painter: MapPainter(places, image),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          places.add(
            Place(
              x: Random().nextInt(2048).toDouble(),
              y: Random().nextInt(2048).toDouble(),
              color: Colors.black,
              radius: Random().nextInt(50).toDouble(),
            ),
          );
        },
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final List<Place> places;
  final ui.Image? image;

  MapPainter(this.places, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final _image = image;
    print(_image != null);
    if (_image != null) {
      print('${_image.height} - ${_image.width}');

      canvas.drawImage(
        _image,
        Offset.zero,
        Paint(),
      );
    }

    for (final place in places) {
      print('${place.x} - ${place.y}');

      canvas.drawCircle(
        Offset(place.x, place.y),
        place.radius,
        Paint()..color = place.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
