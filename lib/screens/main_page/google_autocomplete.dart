import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'main_page.dart';



/// Google places API
class GooglePlaces extends StatefulWidget {
  const GooglePlaces(
      {super.key,
        required this.controller, required this.child});

  final TextEditingController controller;
  final Widget child;

  @override
  State<GooglePlaces> createState() => _GooglePlacesState();
}

class _GooglePlacesState extends State<GooglePlaces> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handlePressButton(context, widget.controller);
      },
      child: widget.child,
    );
  }
}

Future<void> _handlePressButton(BuildContext context, TextEditingController controller) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          title: const Text(
            'Google Search',
            textScaleFactor: 1.5,
          ),
          content: GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: dotenv.env['GoogleAPIKey']!,
              debounceTime: 800, // default 600 ms,
              // countries: const <String>[
              //   'us',
              //   'fr',
              //   'mx',
              //   'ca',
              //   'es'
              // ], // optional by default null is set
              getPlaceDetailWithLatLng: (Prediction prediction) {
                final double lat = double.parse(prediction.lat!);
                final double lng = double.parse(prediction.lng!);
                // itemData.geoPoint = GeoPoint(lat, lng);
              }, // this callback is called when isLatLngRequired is true
              itmClick: (Prediction prediction) {
                if (prediction != null) {
                  controller.text = prediction.description!;
                  // itemData.location = prediction.description!;
                  // itemData.itemName = prediction.description!.split(',')[0];
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length));
                }
                navigationService.pop();
              }
              ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  navigationService.pop();
                },
                child: const Text('Done')),
            TextButton(
                onPressed: () {
                  controller.text = '';
                },
                child: const Text('Clear'))
          ],
        );
      });
}
