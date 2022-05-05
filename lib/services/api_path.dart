
class APIPath {
  static String aircrafts() => 'aircrafts';
  static String aircraft(String aircraftId) => 'aircrafts/$aircraftId';
  static String aircraftTickets(String aircraftId) => 'aircrafts/$aircraftId/tickets';
  static String aircraftTicket(String aircraftId, String aircraftTicketId) => 'aircrafts/$aircraftId/tickets/$aircraftTicketId';
  static String user(String uid) => 'users/$uid';
  static String users() => 'users';
  static String job(String uid, String year, String month, String jobId) => 'users/$uid/years/$year/months/$month/jobs/$jobId';
  static String jobs(String uid, String year, String month) => 'users/$uid/years/$year/months/$month/jobs';
  static String jobYears(String uid) => 'users/$uid/';
  static String jobMonthUpdate(String uid, String year, String month) => 'users/$uid/years/$year/months/$month';
  static String jobYearUpdate(String uid, String year) => 'users/$uid/years/$year';
  static String itTicket(String ticketId) => 'itTickets/$ticketId';
  static String itTickets() => 'itTickets';
  static String itTicketsCategory() => 'itTicketCategory';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String project() => 'projects';
  static String subproject(String pid) => 'projects/$pid/subproject';
}
