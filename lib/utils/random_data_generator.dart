import 'dart:math';

import 'package:uuid/uuid.dart';

import '../data/enums/cargo_type.dart';
import '../data/models/cargo.dart';

abstract class RandomDataGenerator {
  static List<Cargo> generateRandomCargos(
      String currentCityId, List<String> cityIds) {
    final Random random = Random();
    final int cargoCount =
        5 + random.nextInt(5); // Generates a number between 5 and 10
    final List<Cargo> cargos = List<Cargo>.generate(
      cargoCount,
      (int index) {
        final extraExpProbability = random.nextDouble();
        final probability = random.nextDouble();
        final weight = 1 + random.nextInt(9).toDouble();
        double? coins;
        int? standardCrate;
        int? premiumCrate;
        double expFactor = 1.0;

        if (probability < 0.85) {
          // 85% chance for coins (10-30 per kg)
          coins = (1 + random.nextInt(30)) * weight;
        } else if (probability < 0.95) {
          // 10% chance for standard crate
          standardCrate = 1;
        } else {
          // 5% chance for premium crate
          premiumCrate = 1;
        }

        if (extraExpProbability < 0.7) {
          expFactor = 1.0;
        } else if (extraExpProbability < 0.8) {
          expFactor = 1.5;
        } else {
          expFactor = 2.0;
        }

        return Cargo(
          id: const Uuid().v4(),
          type: CargoType.values[randomIndex(CargoType.values.length)],
          sourceId: currentCityId,
          targetId: cityIds[randomIndex(cityIds.length)],
          weight: weight,
          coins: coins,
          standardCrate: standardCrate,
          premiumCrate: premiumCrate,
          experienceFactor: expFactor,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        );
      },
    );
    return cargos;
  }

  static bool _drawBoolWithProbability(double probability) {
    final Random random = Random();
    return random.nextDouble() < probability;
  }

  static int randomIndex(int length) {
    return Random().nextInt(length);
  }
}
