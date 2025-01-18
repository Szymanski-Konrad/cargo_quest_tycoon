enum VehicleStatus {
  idle,
  loading,
  inTransit,
  unloading,
  maintenance;

  const VehicleStatus();

  bool get isIdle => this == VehicleStatus.idle;
  bool get isLoading => this == VehicleStatus.loading;
  bool get isInTransit => this == VehicleStatus.inTransit;
  bool get isUnloading => this == VehicleStatus.unloading;
  bool get isMaintenance => this == VehicleStatus.maintenance;
}
