import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/cities_management/bloc/cities_bloc.dart';
import 'features/fuel_stations/bloc/fuel_stations_bloc.dart';
import 'features/garage/garage_bloc.dart';
import 'features/vehicles_management/bloc/vehicles_management_bloc.dart';
import 'game/bloc/game_bloc.dart';
import 'game_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => GameBloc()),
        BlocProvider(create: (BuildContext context) => FuelStationsBloc()),
        BlocProvider(
            create: (BuildContext context) => VehiclesManagementBloc()),
        BlocProvider(create: (BuildContext context) => CitiesBloc()),
        BlocProvider(create: (BuildContext context) => GarageBloc()),
      ],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate>[
          ...AppLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
        ],
        title: 'Cargo Quest Tycoon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: ui.PointerDeviceKind.values.toSet(),
        ),
        home: const CargoQuestGame(),
      ),
    );
  }
}
