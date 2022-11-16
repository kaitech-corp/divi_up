import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class CreateItemEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class ItemTypeChange extends CreateItemEvent {

  ItemTypeChange({this.type});
  final String? type;

  @override
  List<Object> get props => <Object>[type!];
}

class ItemNameChanged extends CreateItemEvent {

  ItemNameChanged({required this.name});
  final String? name;

  @override
  List<Object> get props => <Object>[name!];
}

class ItemLocationChanged extends CreateItemEvent {

  ItemLocationChanged({this.location,});
  final String? location;

  @override
  List<Object> get props => <Object>[location!,];
}

class ItemTotalChanged extends CreateItemEvent {
  ItemTotalChanged({this.total});
final double? total;


  @override
  List<Object> get props => <Object>[total!];
}

class ItemAccessUsersChanged extends CreateItemEvent {

  ItemAccessUsersChanged({this.accessUsers});
  final List<String>? accessUsers;

  @override
  List<Object> get props => <Object>[accessUsers!];
}

class ItemGeoPointChanged extends CreateItemEvent {

  ItemGeoPointChanged({this.geoPoint});
  final GeoPoint? geoPoint;

  @override
  List<Object> get props => <Object>[geoPoint!];
}

class ItemEvenSplitChanged extends CreateItemEvent {

  ItemEvenSplitChanged({this.evenSplit});
  final bool? evenSplit;

  @override
  List<Object> get props => <Object>[evenSplit!];
}
class CreateItemButtonPressed extends CreateItemEvent {

  CreateItemButtonPressed();
  @override
  List<Object> get props => <Object>[];
}