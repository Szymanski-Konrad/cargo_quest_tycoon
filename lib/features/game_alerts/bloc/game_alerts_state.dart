import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_alert_model.dart';

part 'game_alerts_state.freezed.dart';
part 'game_alerts_state.g.dart';

@freezed
class GameAlertsState with _$GameAlertsState {
  factory GameAlertsState({
    GameAlertModel? gameAlert,
  }) = _GameAlertsState;

  factory GameAlertsState.fromJson(Map<String, dynamic> json) =>
      _$GameAlertsStateFromJson(json);
}
