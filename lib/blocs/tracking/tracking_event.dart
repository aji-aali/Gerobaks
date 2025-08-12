import 'package:latlong2/latlong.dart';

abstract class TrackingEvent {}

class FetchRoute extends TrackingEvent {}

class UpdateTruckLocation extends TrackingEvent {
  final LatLng position;
  UpdateTruckLocation(this.position);
}
