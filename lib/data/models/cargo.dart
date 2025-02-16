import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/cargo_type.dart';

part 'cargo.freezed.dart';
part 'cargo.g.dart';

@freezed
class Cargo with _$Cargo {
  const factory Cargo({
    required String id,
    required CargoType type,
    required String sourceId,
    required String targetId,
    required double weight,
    required DateTime createdAt,
    required DateTime expiresAt,

    /// id of vehicle that is assigned to this cargo
    String? vehicleId,
    @Default(1.0) double experienceFactor,
    double? premiumValue,
    double? coins,
    int? standardCrate,
    int? premiumCrate,
  }) = _Cargo;

  factory Cargo.fromJson(Map<String, dynamic> json) => _$CargoFromJson(json);
}
