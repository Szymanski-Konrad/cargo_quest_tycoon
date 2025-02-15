import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/game_stats.dart';
import '../../data/models/map_tile.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<LevelUp>(_onLevelUp);
    on<GainExp>(_onGainExp);
    on<GainCoins>(_onGainCoins);
    on<SpendCoins>(_onSpendCoins);
    on<GainRoadStars>(_onGainRoadStars);
    on<GainCrates>(_onGainCrates);
    on<GainPremiumCrates>(_onGainPremiumCrates);
    on<UnlockTile>(_onUnlockTile);
  }

  void _onLevelUp(LevelUp event, Emitter<GameState> emit) {
    final nextLvl = state.gameStats.level + 1;
    final expToNextLevel = nextLvl * 2000;
    final leftExp = state.gameStats.exp - state.gameStats.expToNextLevel;

    final newGameStats = state.gameStats.copyWith(
      level: nextLvl,
      exp: leftExp,
      expToNextLevel: expToNextLevel,
    );

    emit(
      state.copyWith(
        gameStats: newGameStats,
      ),
    );
  }

  void _onGainExp(GainExp event, Emitter<GameState> emit) {
    final newStats =
        state.gameStats.copyWith(exp: state.gameStats.exp + event.exp);
    if (newStats.exp >= newStats.expToNextLevel) {
      add(const LevelUp());
    } else {
      emit(state.copyWith(gameStats: newStats));
    }
  }

  void _onGainCoins(GainCoins event, Emitter<GameState> emit) {
    final newStats =
        state.gameStats.copyWith(coins: state.gameStats.coins + event.coins);
    emit(state.copyWith(gameStats: newStats));
  }

  void _onGainRoadStars(GainRoadStars event, Emitter<GameState> emit) {
    final newStats = state.gameStats.copyWith(
      roadStars: state.gameStats.roadStars + event.roadStars,
    );
    emit(state.copyWith(gameStats: newStats));
  }

  void _onGainCrates(GainCrates event, Emitter<GameState> emit) {
    final newStats = state.gameStats.copyWith(
      crates: state.gameStats.crates + event.crates,
    );
    emit(state.copyWith(gameStats: newStats));
  }

  void _onGainPremiumCrates(GainPremiumCrates event, Emitter<GameState> emit) {
    final newStats = state.gameStats.copyWith(
      premiumCrates: state.gameStats.premiumCrates + event.premiumCrates,
    );
    emit(state.copyWith(gameStats: newStats));
  }

  void _onUnlockTile(UnlockTile event, Emitter<GameState> emit) {
    if (state.gameStats.coins >= event.cost) {
      emit(state.copyWith(
        unlockedTiles: <MapTile>[...state.unlockedTiles, event.tile],
      ));

      add(SpendCoins(event.cost));
      event.onUnlock();
    }
  }

  FutureOr<void> _onSpendCoins(SpendCoins event, Emitter<GameState> emit) {
    final newStats = state.gameStats.copyWith(
      coins: state.gameStats.coins - event.coins,
    );
    emit(state.copyWith(gameStats: newStats));
  }
}
