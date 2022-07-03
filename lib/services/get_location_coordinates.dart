// ignore_for_file: avoid_print

import 'package:gasbay/keys/globay_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetLocationCoordinates {
  static String key = googleAPIKkey;

  static Future<String> getPlaceId(String destination) async {
    Future<String> placeId = Future.value('null');
    var url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$destination&inputtype=textquery&key=$key';
  
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['candidates'];
      if(results !=null){
        if (results.length > 0) {
        var placeId = results[0]['place_id'];
        return placeId;
      }
      }
    } else {
      print('Error: ${response.statusCode}');
    }

    return placeId;
  }

  static Future<Map<String, dynamic>> getPlaceDetails(
      String destination) async {
    String placeId = await getPlaceId(destination);
    Future<Map<String, dynamic>> result = Future.value({});

    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      
      var result = jsonResponse['result'] as Map<String, dynamic>;
      return result; 
    } else {
      print('Error: ${response.statusCode}');
  
    }

    return result;
  }

  static Future<List<double>> getLatLong(String destination) async {
    List<double> latLon = [];
    var result = await getPlaceDetails(destination);
    var lat = result['geometry']['location']['lat'];
    var lon = result['geometry']['location']['lng'];
    latLon.add(lat);
    latLon.add(lon);
    return latLon;
  }
}
