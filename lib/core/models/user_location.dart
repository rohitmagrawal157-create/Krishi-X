class UserLocation {
  const UserLocation({
    required this.displayName,
    this.latitude,
    this.longitude,
    this.permissionGranted = false,
  });

  final String displayName;
  final double? latitude;
  final double? longitude;
  final bool permissionGranted;

  static const defaultLocation = UserLocation(
    displayName: 'Aurangabad, Maharashtra',
    permissionGranted: false,
  );

  String get regionKey {
    final parts = displayName.split(',');
    return parts.length > 1 ? parts.last.trim() : displayName;
  }
}
