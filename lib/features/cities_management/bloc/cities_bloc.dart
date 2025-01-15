import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/cargo.dart';
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
    on<RemoveCargoFromCity>(_onRemoveCargoFromCity);
    on<AssignCargoToVehicle>(_onAssignCargoToVehicle);
    on<UnassignCargoFromVehicle>(_onUnassignCargoFromVehicle);
  }

  void _onRemoveCargoFromCity(
      RemoveCargoFromCity event, Emitter<CitiesState> emit) {
    final List<City> cities = List.of(state.cities);
    final int cityIndex =
        state.cities.indexWhere((City element) => element.id == event.cityId);
    if (cityIndex == -1) {
      return;
    }
    final List<Cargo> cargos = List.of(cities[cityIndex].cargos);
    cargos.removeWhere((Cargo element) => element.id == event.cargoId);
    final City city = cities[cityIndex].copyWith(cargos: cargos);
    cities[cityIndex] = city;
    emit(state.copyWith(cities: cities));
  }

  void _onUnassignCargoFromVehicle(
      UnassignCargoFromVehicle event, Emitter<CitiesState> emit) {
    _assignVehicleIdToCargo(
      cityId: event.cityId,
      vehicleId: null,
      cargoId: event.cargoId,
    );
  }

  void _onAssignCargoToVehicle(
      AssignCargoToVehicle event, Emitter<CitiesState> emit) {
    _assignVehicleIdToCargo(
      cityId: event.cityId,
      vehicleId: event.vehicleId,
      cargoId: event.cargoId,
    );
  }

  void _assignVehicleIdToCargo(
      {required String cityId,
      required String? vehicleId,
      required String cargoId}) {
    final List<City> cities = List.of(state.cities);
    final int cityIndex =
        state.cities.indexWhere((City element) => element.id == cityId);
    if (cityIndex == -1) {
      return;
    }
    final List<Cargo> cargos = List.of(cities[cityIndex].cargos);
    final int cargoIndex =
        cargos.indexWhere((Cargo element) => element.id == cargoId);
    if (cargoIndex == -1) {
      return;
    }
    final Cargo cargo = cargos[cargoIndex].copyWith(vehicleId: vehicleId);
    cargos[cargoIndex] = cargo;
    final City city = cities[cityIndex].copyWith(cargos: cargos);
    cities[cityIndex] = city;
    emit(state.copyWith(cities: cities));
  }

  void _onRefreshCityCargos(
      RefreshCityCargos event, Emitter<CitiesState> emit) {
    final List<City> cities = List.of(state.cities);
    if (cities.length < 2) {
      return;
    }
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
    if (city == null) {
      emit(state.copyWith(
        currentCityId: null,
        lockedCity: City(
          id: const Uuid().v4(),
          position: event.position,
          name: event.cityName,
        ),
      ));
    } else {
      emit(state.copyWith(
        currentCityId: city.id,
        lockedCity: null,
      ));
    }
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
      name: event.cityName,
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
    emit(state.copyWith(
      cities: cities,
      currentCityId: id,
    ));
  }
}
