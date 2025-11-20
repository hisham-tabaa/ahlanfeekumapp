class CreateTicketRequest {
  final String firstName;
  final String lastName;
  final String description;

  const CreateTicketRequest({
    required this.firstName,
    required this.lastName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'description': description,
    };
  }
}