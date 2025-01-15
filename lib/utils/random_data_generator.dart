import 'dart:math';

import 'package:uuid/uuid.dart';

import '../data/enums/cargo_type.dart';
import '../data/models/cargo.dart';

abstract class RandomDataGenerator {
  static List<Cargo> generateRandomCargos(
      String currentCityId, List<String> cityIds) {
    final Random random = Random();
    final int cargoCount =
        3 + random.nextInt(8); // Generates a number between 3 and 10
    final List<Cargo> cargos = List<Cargo>.generate(
      cargoCount,
      (int index) => Cargo(
        id: const Uuid().v4(),
        type: CargoType.values[randomIndex(CargoType.values.length)],
        sourceId: currentCityId,
        targetId: cityIds[randomIndex(cityIds.length)],
        weight: 1 + random.nextInt(5).toDouble(),
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        coins: (10 + random.nextInt(150)).toDouble(),
      ),
    );
    return cargos;
  }

  static int randomIndex(int length) {
    return Random().nextInt(length);
  }
}
