import '../../data/models/property_rating_request.dart';

abstract class PropertyDetailEvent {
  const PropertyDetailEvent();
}

class LoadPropertyDetailEvent extends PropertyDetailEvent {
  final String propertyId;

  const LoadPropertyDetailEvent(this.propertyId);
}

class LoadPropertyAvailabilityEvent extends PropertyDetailEvent {
  final String propertyId;

  const LoadPropertyAvailabilityEvent(this.propertyId);
}

class ToggleFavoriteEvent extends PropertyDetailEvent {
  final String propertyId;
  final bool isFavorite;

  const ToggleFavoriteEvent({
    required this.propertyId,
    required this.isFavorite,
  });
}

class RatePropertyEvent extends PropertyDetailEvent {
  final PropertyRatingRequest request;

  const RatePropertyEvent(this.request);
}
