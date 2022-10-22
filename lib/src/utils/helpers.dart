import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testing/src/utils/extentions.dart';

import '../prediction_response.dart';
import '../values/constants.dart';
import '../values/strings.dart';
import 'package:http/http.dart' as http;

Future<Place> getPlaceDetailFromId(String placeId, BuildContext context) async {
  final place = Place();
  try {
    final apiKey = Platform.isIOS
        ? AppConstants.placeApiKeyIos
        : AppConstants.placeApiKeyAndroid;
    final request =
        '${AppConstants.placeApiBaseUrlFromId}?place_id=$placeId&fields=address_component,name&key=$apiKey&sessiontoken=null';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result[AppStrings.statusKey] == AppStrings.txtOK) {
        final name = result[AppStrings.resultKey][AppStrings.addressNameKey];
        place.street = name;
        final components = result[AppStrings.resultKey]
            [AppStrings.addressComponentKey] as List<dynamic>;
        var tempLocality = '';
        for (final component in components) {
          final List type = component[AppStrings.typesKey];
          if (type.contains(AppStrings.streetNumberKey)) {
            place.streetNumber = component[AppStrings.longNameKey];
          }
          if (type.contains(AppStrings.routKey) &&
              !component[AppStrings.longNameKey].contains(name)) {
            place.street =
                "${place.street ?? ''}, ${component[AppStrings.longNameKey]}";
          }
          if ((type.contains(AppStrings.neighborhoodKey) &&
                  component[AppStrings.longNameKey] != place.street) ||
              type.contains(AppStrings.subLocality1Key) ||
              type.contains(AppStrings.subLocality2Key) ||
              type.contains(AppStrings.subLocality3Key)) {
            place.postalAddress = getAddress(place, component);
          }
          if (type.contains(AppStrings.adminArea2Key)) {
            place.city = component[AppStrings.longNameKey];
          }
          if (type.contains(AppStrings.localityKey)) {
            if (place.postalAddress != null &&
                place.postalAddress?.isNotEmpty == true) {
              if (place.postalAddress
                          ?.contains(component[AppStrings.longNameKey]) !=
                      true &&
                  component[AppStrings.longNameKey] != place.city) {
                tempLocality = component[AppStrings.longNameKey];
              }
            } else {
              place.postalAddress = component[AppStrings.longNameKey];
            }
          }
          if (type.contains(AppStrings.stateKey)) {
            place.state = component[AppStrings.longNameKey];
          }
          if (type.contains(AppStrings.countryKey)) {
            place.country = component[AppStrings.longNameKey];
          }
          if (type.contains(AppStrings.postalCodeKey)) {
            place.zipCode = component[AppStrings.longNameKey];
          }
        }
        if (tempLocality.isNotEmpty && tempLocality != place.city) {
          place.postalAddress = '${place.postalAddress ?? ''}, $tempLocality';
        }
        if (!(place.street?.contains(place.postalAddress ?? '') ?? false)) {
          place.street = '${place.street ?? ''}, ${place.postalAddress ?? ''}';
        }
      }
    }
  } catch (error) {
    context.showSnackBar(error.toString());
  }
  return place;
}

String? getAddress(Place place, dynamic component) {
  if (place.postalAddress != null &&
      place.postalAddress?.isNotEmpty == true &&
      !component[AppStrings.longNameKey].contains(place.postalAddress)) {
    return "${place.postalAddress ?? ''}, ${component[AppStrings.longNameKey]}";
  } else {
    return component[AppStrings.longNameKey];
  }
}
