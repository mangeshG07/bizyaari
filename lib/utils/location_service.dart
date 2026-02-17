import 'dart:convert';
import 'package:businessbuddy/network/all_url.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> updateUserLocation() async {
  String userLocation = '';

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      return '${placemark.subLocality}, ${placemark.locality}';
    }
  } catch (e) {
    return 'Pune, Maharashtra';
  }
  return userLocation;
}

Future<List<Map<String, dynamic>>> getPlaces(String search) async {
  String baseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String apiKey = googleMapsApi;
  String request = '$baseURL?input=$search&components=country:in&key=$apiKey';

  var response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    List<Map<String, dynamic>> results = [];

    for (var place in data['predictions']) {
      final placeId = place['place_id'];
      final description = place['description'];

      // ✅ fetch structured details
      final details = await getPlaceDetails(placeId);
      results.add({
        "place_id": placeId,
        "description": description,
        "country": details["country"],
        "state": details["state"],
        "city": details["city"],
        "area": details["area"],
        "lat": details["lat"],
        "lng": details["lng"],
      });
    }

    return results;
  }
  return [];
}

// Future<List<Map<String, dynamic>>> getPlaces(String search) async {
//   String baseURL =
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//   String apiKey = googleMapsApi;
//   String request = '$baseURL?input=$search&key=$apiKey';
//
//   var response = await http.get(Uri.parse(request));
//
//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
//     print(data);
//     log(data.toString(),name: 'getPlaces result');
//     var places = List<Map<String, dynamic>>.from(data['predictions']
//         .map((place) => {
//               'place_id': place['place_id'],
//               'description': place['description'],
//             })
//         .toList());
//
//     return places;
//   }
//   return [];
// }

// // for more attributes you can check the results of https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJ3T8F3fDhDDkRnxNgWBpc2Zc&key=AIzaSyD9CpE_30XcnsmEO-V5VcinyrEWUhpflBw
//   Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
//     String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
//     String apiKey = googleMapsApi;
//     String request = '$baseURL?place_id=$placeId&key=$apiKey';
//     var response = await http.get(Uri.parse(request));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       var location = data['result']['geometry']['location'];
//
//       return {
//         'lat': location['lat'],
//         'lng': location['lng'],
//       };
//     }
//     return {};
//   }

Future<Map<String, String>> getPlaceDetails(String placeId) async {
  const apiKey = googleMapsApi;
  final url =
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final components = data["result"]["address_components"] as List;
    final location = data["result"]["geometry"]["location"];
    // print('location=========>$location');
    String country = "";
    String state = "";
    String city = "";
    String area = "";

    for (var comp in components) {
      final types = comp["types"] as List;

      if (types.contains("country")) {
        country = comp["long_name"];
      } else if (types.contains("administrative_area_level_1")) {
        state = comp["long_name"];
      } else if (types.contains("locality")) {
        city = comp["long_name"];
      } else if (types.contains("sublocality") ||
          types.contains("sublocality_level_1") ||
          types.contains("neighborhood")) {
        area = comp["long_name"];
      }
    }

    return {
      "country": country,
      "state": state,
      "city": city,
      "area": area,
      "lat": location["lat"].toString(),
      "lng": location["lng"].toString(),
    };
  }

  return {};
}
