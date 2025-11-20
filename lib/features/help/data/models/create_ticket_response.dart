class CreateTicketResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String description;
  final bool isFixed;
  final String userProfileId;
  final String? concurrencyStamp;
  final bool isDeleted;
  final String? deleterId;
  final String? deletionTime;
  final String? lastModificationTime;
  final String? lastModifierId;
  final String creationTime;
  final String creatorId;

  const CreateTicketResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.isFixed,
    required this.userProfileId,
    this.concurrencyStamp,
    required this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.lastModificationTime,
    this.lastModifierId,
    required this.creationTime,
    required this.creatorId,
  });

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    return CreateTicketResponse(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isFixed: json['isFixed'] as bool? ?? false,
      userProfileId: json['userProfileId'] as String? ?? '',
      concurrencyStamp: json['concurrencyStamp'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deleterId: json['deleterId'] as String?,
      deletionTime: json['deletionTime'] as String?,
      lastModificationTime: json['lastModificationTime'] as String?,
      lastModifierId: json['lastModifierId'] as String?,
      creationTime: json['creationTime'] as String? ?? '',
      creatorId: json['creatorId'] as String? ?? '',
    );
  }
}