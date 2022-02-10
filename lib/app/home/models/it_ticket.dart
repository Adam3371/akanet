import 'package:meta/meta.dart';

class ItTicket {
  ItTicket({
    @required this.id,
    @required this.priority,
    @required this.status,
    this.category,
    @required this.customerId,
    this.customerName,
    @required this.ticketName,
    this.ticketDescription,
    @required this.openingDateTime,
    this.workingDateTime,
    this.closingDateTime,
  });
  final String id;
  final int priority;
  final int status;
  final String category;
  final String customerId;
  final String customerName;
  final String ticketName;
  final String ticketDescription;
  final String openingDateTime;
  final String workingDateTime;
  final String closingDateTime;

  factory ItTicket.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int priority = data["priority"];
    final int status = data["status"];
    final String category = data["category"];
    final String customerId = data["customerId"];
    final String customerName = data["customerName"];
    final String ticketName = data["ticketName"];
    final String ticketDescription = data["ticketDescription"];
    final String openingDateTime = data["openingDateTime"];
    final String workingDateTime = data["workingDateTime"];
    final String closingDateTime = data["closingDateTime"];
    return ItTicket(
      id: documentId,
      priority: priority,
      status: status,
      category: category,
      customerId: customerId,
      customerName: customerName,
      ticketName: ticketName,
      ticketDescription: ticketDescription,
      openingDateTime: openingDateTime,
      workingDateTime: workingDateTime,
      closingDateTime: closingDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "priority": priority,
      "status": status,
      "category": category,
      "customerId": customerId,
      "customerName": customerName,
      "ticketName": ticketName,
      "ticketDescription": ticketDescription,
      "openingDateTime": openingDateTime,
      "workingDateTime": workingDateTime,
      "closingDateTime": closingDateTime,
    };
  }
}
