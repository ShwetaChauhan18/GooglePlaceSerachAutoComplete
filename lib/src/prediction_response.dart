class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;
  String? postalAddress;
  String? state;
  String? country;

  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
    this.postalAddress,
    this.state,
    this.country,
  });
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);
}
