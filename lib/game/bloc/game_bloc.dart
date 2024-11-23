import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cargo_quest_tycoon/data/models/map_tile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.dart';
part 'game_event.dart';

part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<GameLevelUp>(_onLevelUp);
    on<GameGainExp>(_onGainExp);
    on<GameGainCoins>(_onGainCoins);
    on<GameGainRoadStars>(_onGainRoadStars);
    on<GameGainCrates>(_onGainCrates);
    on<GameGainPremiumCrates>(_onGainPremiumCrates);
    on<GameUnlockTile>(_onUnlockTile);
  }

  void _onLevelUp(GameLevelUp event, Emitter<GameState> emit) {
    emit(state.copyWith(level: state.level + 1));
  }

  void _onGainExp(GameGainExp event, Emitter<GameState> emit) {
    emit(state.copyWith(exp: state.exp + event.exp));
  }

  void _onGainCoins(GameGainCoins event, Emitter<GameState> emit) {
    emit(state.copyWith(coins: state.coins + event.coins));
  }

  void _onGainRoadStars(GameGainRoadStars event, Emitter<GameState> emit) {
    emit(state.copyWith(roadStars: state.roadStars + event.roadStars));
  }

  void _onGainCrates(GameGainCrates event, Emitter<GameState> emit) {
    emit(state.copyWith(crates: state.crates + event.crates));
  }

  void _onGainPremiumCrates(
      GameGainPremiumCrates event, Emitter<GameState> emit) {
    emit(state.copyWith(
        premiumCrates: state.premiumCrates + event.premiumCrates));
  }

  void _onUnlockTile(GameUnlockTile event, Emitter<GameState> emit) {
    emit(state.copyWith(unlockedTiles: [...state.unlockedTiles, event.tile]));
  }
}
