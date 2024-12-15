import 'package:freezed_annotation/freezed_annotation.dart';

import 'cargo.dart';

part 'garage.freezed.dart';
part 'garage.g.dart';

@freezed
class Garage with _$Garage {
  const factory Garage({
    required String id,
    required String cityId,
    required int slots,
    @Default(<String>[]) List<String> vehicles,
    @Default(<Cargo>[]) List<Cargo> cargos,
    required double storageLimit,
  }) = _Garage;

  factory Garage.fromJson(Map<String, dynamic> json) => _$GarageFromJson(json);
}
