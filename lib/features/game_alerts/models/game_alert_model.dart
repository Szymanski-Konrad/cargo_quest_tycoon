import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_alert_type.dart';

part 'game_alert_model.freezed.dart';
part 'game_alert_model.g.dart';

@freezed
class GameAlertModel with _$GameAlertModel {
  factory GameAlertModel({
    required GameAlertType type,
    required String message,
    String? uuid,
  }) = _GameAlertModel;

  const GameAlertModel._();

  factory GameAlertModel.fromJson(Map<String, dynamic> json) =>
      _$GameAlertModelFromJson(json);
}
