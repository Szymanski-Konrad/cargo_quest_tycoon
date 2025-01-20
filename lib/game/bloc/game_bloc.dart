import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/map_tile.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<LevelUp>(_onLevelUp);
    on<GainExp>(_onGainExp);
    on<GainCoins>(_onGainCoins);
    on<GainRoadStars>(_onGainRoadStars);
    on<GainCrates>(_onGainCrates);
    on<GainPremiumCrates>(_onGainPremiumCrates);
    on<UnlockTile>(_onUnlockTile);
    on<ShowBuyTruckDialog>(_onShowBuyTruckDialog);
    on<HideBuyTruckDialog>(_onHideBuyTruckDialog);
  }

  void _onHideBuyTruckDialog(
      HideBuyTruckDialog event, Emitter<GameState> emit) {
    emit(state.copyWith(showBuyTruckDialog: false));
  }

  void _onShowBuyTruckDialog(
      ShowBuyTruckDialog event, Emitter<GameState> emit) {
    emit(state.copyWith(showBuyTruckDialog: true));
  }

  void _onLevelUp(LevelUp event, Emitter<GameState> emit) {
    emit(state.copyWith(level: state.level + 1));
  }

  void _onGainExp(GainExp event, Emitter<GameState> emit) {
    emit(state.copyWith(exp: state.exp + event.exp));
  }

  void _onGainCoins(GainCoins event, Emitter<GameState> emit) {
    emit(state.copyWith(coins: state.coins + event.coins));
  }

  void _onGainRoadStars(GainRoadStars event, Emitter<GameState> emit) {
    emit(state.copyWith(roadStars: state.roadStars + event.roadStars));
  }

  void _onGainCrates(GainCrates event, Emitter<GameState> emit) {
    emit(state.copyWith(crates: state.crates + event.crates));
  }

  void _onGainPremiumCrates(GainPremiumCrates event, Emitter<GameState> emit) {
    emit(state.copyWith(
        premiumCrates: state.premiumCrates + event.premiumCrates));
  }

  void _onUnlockTile(UnlockTile event, Emitter<GameState> emit) {
    if (state.coins >= 1) {
      emit(state.copyWith(
        unlockedTiles: <MapTile>[...state.unlockedTiles, event.tile],
      ));

      add(const GainCoins(1));
    }
  }
}
