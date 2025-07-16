import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return an error
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, return an error
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  Future<String> getCityFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? 'Unknown City';
    } else {
      throw Exception('No placemarks found for the given coordinates.');
    }
  }

  Future<String> getCountryFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      return placemarks.first.country ?? 'Unknown Country';
    } else {
      throw Exception('No placemarks found for the given coordinates.');
    }
  }
}

// This class provides methods to get the current position and city name from the device's location services.
