import 'cargo_license.dart';

enum CargoType {
  container(CargoLicense.largeI), // Kontener
  food(CargoLicense.foodI), // Żywność
  frozen(CargoLicense.foodII), // Mrożonki
  oil(CargoLicense.foodI), // Olej
  liquid(CargoLicense.standardI), // Ciecz
  gas(CargoLicense.dangerousII), // Gaz
  chemicals(CargoLicense.dangerousIII), // Chemikalia
  electronics(CargoLicense.luxuryI), // Elektronika
  machinery(CargoLicense.largeI), // Maszyny
  automobiles(CargoLicense.largeII), // Samochody
  textiles(CargoLicense.standardI), // Tekstylia
  furniture(CargoLicense.largeII), // Meble
  constructionMaterials(CargoLicense.largeIII), // Materiały budowlane
  metals(CargoLicense.luxuryI), // Metale
  wood(CargoLicense.standardII), // Drewno
  paper(CargoLicense.standardII), // Papier
  glass(CargoLicense.fragileI), // Szkło
  pharmaceuticals(CargoLicense.standardIII), // Farmaceutyki
  livestock(CargoLicense.fooodIII), // Żywy inwentarz
  toys(CargoLicense.standardII), // Zabawki
  clothing(CargoLicense.standardIII), // Odzież
  footwear(CargoLicense.standardII), // Obuwie
  books(CargoLicense.luxuryII), // Książki
  cosmetics(CargoLicense.standardII), // Kosmetyki
  beverages(CargoLicense.foodI), // Napoje
  alcohol(CargoLicense.dangerousI), // Alkohol
  tobacco(CargoLicense.dangerousII), // Tytoń
  householdGoods(CargoLicense.standardI), // Artykuły gospodarstwa domowego
  officeSupplies(CargoLicense.standardI), // Artykuły biurowe
  sportingGoods(CargoLicense.standardI), // Artykuły sportowe
  musicalInstruments(CargoLicense.standardIII), // Instrumenty muzyczne
  art(CargoLicense.luxuryII), // Sztuka
  jewelry(CargoLicense.luxuryIII), // Biżuteria
  medicalEquipment(CargoLicense.fragileIII), // Sprzęt medyczny
  industrialEquipment(CargoLicense.largeIII), // Sprzęt przemysłowy
  agriculturalProducts(CargoLicense.dangerousII), // Produkty rolne
  petroleumProducts(CargoLicense.dangerousII), // Produkty naftowe
  coal(CargoLicense.rawI), // Węgiel
  minerals(CargoLicense.rawI), // Minerały
  plasticProducts(CargoLicense.standardII), // Produkty z tworzyw sztucznych
  rubberProducts(CargoLicense.standardI), // Produkty gumowe
  ceramics(CargoLicense.fragileII), // Ceramika
  cement(CargoLicense.rawII), // Cement
  sand(CargoLicense.rawI), // Piasek
  gravel(CargoLicense.rawII), // Żwir
  salt(CargoLicense.standardII), // Sól
  sugar(CargoLicense.standardIII), // Cukier
  coffee(CargoLicense.standardIII), // Kawa
  tea(CargoLicense.standardII); // Herbata

  const CargoType(this.license);
  final CargoLicense license;
}

extension CargoTypeExtension on CargoType {
  String get name {
    return toString().split('.').last;
  }
}

extension CargoTypeListExtension on List<CargoType> {
  List<CargoType> supportedByLicense(CargoLicense license) {
    return where((CargoType type) => type.license.index <= license.index)
        .toList();
  }
}
