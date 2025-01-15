part of 'cities_bloc.dart';

@freezed
class CitiesState with _$CitiesState {
  const factory CitiesState({
    @Default([]) List<City> cities,
    String? currentCityId,
    City? lockedCity,
  }) = _CitiesState;
  const CitiesState._();

  City? get currentCity =>
      cities.firstWhereOrNull((City element) => element.id == currentCityId);
}
