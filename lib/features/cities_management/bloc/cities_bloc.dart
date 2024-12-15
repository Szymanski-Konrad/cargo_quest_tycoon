import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/city.dart';
import '../../../data/models/map_tile_position.dart';
import '../../../utils/random_data_generator.dart';

part 'cities_bloc.freezed.dart';
part 'cities_event.dart';
part 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc() : super(const CitiesState()) {
    on<ChangeCity>(_onChangeCity);
    on<CloseCity>(_onCloseCity);
    on<BuyNewCity>(_onBuyNewCity);
    on<RefreshCityCargos>(_onRefreshCityCargos);
  }

  void _onRefreshCityCargos(
      RefreshCityCargos event, Emitter<CitiesState> emit) {
    final List<City> cities = List.of(state.cities);
    final int cityIndex =
        state.cities.indexWhere((City element) => element.id == event.cityId);
    if (cityIndex == -1) {
      return;
    }
    final City city = cities[cityIndex].copyWith(
        cargos: RandomDataGenerator.generateRandomCargos(
      event.cityId,
      state.cities.map((item) => item.id).toList()..remove(event.cityId),
    ));
    cities[cityIndex] = city;
    emit(state.copyWith(cities: cities));
  }

  void _onChangeCity(ChangeCity event, Emitter<CitiesState> emit) {
    final List<City> cities = List.of(state.cities);
    final City? city = cities.firstWhereOrNull(
      (City element) => element.position == event.position,
    );
    emit(state.copyWith(currentCityId: city?.id));
  }

  void _onCloseCity(CloseCity event, Emitter<CitiesState> emit) {
    emit(state.copyWith(currentCityId: null));
  }

  void _onBuyNewCity(BuyNewCity event, Emitter<CitiesState> emit) {
    final id = const Uuid().v4();
    final cities = List.of(state.cities);

    final City newCity = City(
      id: id,
      position: event.cityPosition,
      name: 'City ${state.cities.length + 1}',
      cargos: cities.length > 1
          ? RandomDataGenerator.generateRandomCargos(
              id,
              state.cities.map((item) => item.id).toList()..remove(id),
            )
          : [],
      refreshInterval: 5,
      level: 1,
    );

    cities.add(newCity);
    print('New city added: ${newCity.name}');
    print('Cities counter: ${cities.length}');
    emit(state.copyWith(cities: cities));
  }
}
