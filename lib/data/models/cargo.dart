import 'package:cargo_quest_tycoon/data/enums/cargo_type.dart';
import 'package:cargo_quest_tycoon/data/models/city.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cargo.freezed.dart';
part 'cargo.g.dart';

@freezed
class Cargo with _$Cargo {
  const factory Cargo({
    required String id,
    required CargoType type,
    required City source,
    required City destination,
    required String name,
    required double weight,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default(1.0) double experienceFactor,
    double? coins,
    double? premiumValue,
    int? standardCrate,
    int? premiumCrate,
  }) = _Cargo;

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);
}
