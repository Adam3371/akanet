import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/aircraft_ticket.dart';
import 'package:akanet/app/home/models/job_month_overview.dart';
import 'package:akanet/app/home/models/my_user.dart';
import 'package:akanet/app/home/models/it_ticket.dart';
import 'package:akanet/app/home/models/it_ticket_category.dart';
import 'package:akanet/app/home/models/project.dart';
import 'package:akanet/app/home/models/sub_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:akanet/app/home/models/entry.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/services/api_path.dart';
import 'package:akanet/services/firestore_service.dart';

abstract class Database {
  Stream<AircraftTicket> aircraftTicketStream(
      {@required String aircraftId, @required String aircraftTicketId});
  Stream<List<AircraftTicket>> aircraftTicketsStream(
      {@required String aircraftId});
  Future<void> setAircraftTicket(
      {@required String aircraftId, AircraftTicket aircraftTicket});

  Stream<Aircraft> aircraftStream({@required String aircraftId});
  Stream<List<Aircraft>> aircraftsStream();
  Future<void> setAircraft({@required Aircraft aircraft});

  Stream<ItTicket> itTicketStream({@required String itTicketId});
  Stream<List<ItTicket>> itTicketsStream();
  Future<void> setItTicket(ItTicket itTicket);

  Stream<List<Project>> projectsStream();
  Stream<List<SubProject>> subProjectStream(String pid);

  Stream<List<ItTicketCategory>> itTicketCategoties();

  Stream<Job> jobStream({@required Job job});
  Stream<List<String>> jobYearsStream();
  Stream<List<Job>> jobsStream(String year, String month);
  Stream<List<Job>> jobsToApproveStream(String uid, String year, String month);

  Future<void> setJob(Job job);
  Future<void> approveJob({String id, Job job, String approveStatus});
  Future<void> deleteJob(Job job);

  Stream<List<Entry>> entriesStream({Job job});
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);

  Future<void> setUser(MyUser myUser);
  Stream<MyUser> userStream();
  Stream<List<MyUser>> usersStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Stream<AircraftTicket> aircraftTicketStream(
          {@required String aircraftId, String aircraftTicketId}) =>
      _service.documentStream(
        path: APIPath.aircraftTicket(aircraftId, aircraftTicketId),
        builder: (data, documentId) => AircraftTicket.fromMap(data, documentId),
      );

  @override
  Stream<List<AircraftTicket>> aircraftTicketsStream(
          {@required String aircraftId}) =>
      _service.collectionStream(
        path: APIPath.aircraftTickets(aircraftId),
        builder: (data, documentId) => AircraftTicket.fromMap(data, documentId),
      );

  @override
  Future<void> setAircraftTicket(
          {String aircraftId, AircraftTicket aircraftTicket}) =>
      _service.setData(
        path: APIPath.aircraftTicket(aircraftId, aircraftTicket.id),
        data: aircraftTicket.toMap(),
      );

  @override
  Stream<Aircraft> aircraftStream({@required String aircraftId}) =>
      _service.documentStream(
        path: APIPath.aircraft(aircraftId),
        builder: (data, documentId) => Aircraft.fromMap(data, documentId),
      );

  @override
  Stream<List<Aircraft>> aircraftsStream() => _service.collectionStream(
        path: APIPath.aircrafts(),
        builder: (data, documentId) => Aircraft.fromMap(data, documentId),
      );

  @override
  Future<void> setAircraft({@required Aircraft aircraft}) => _service.setData(
        path: APIPath.aircraft(aircraft.id),
        data: aircraft.toMap(),
      );

  @override
  Stream<ItTicket> itTicketStream({@required String itTicketId}) =>
      _service.documentStream(
        path: APIPath.itTicket(itTicketId),
        builder: (data, documentId) => ItTicket.fromMap(data, documentId),
      );

  Stream<List<ItTicket>> itTicketsStream() => _service.collectionStream(
        path: APIPath.itTickets(),
        builder: (data, documentId) => ItTicket.fromMap(data, documentId),
      );

  @override
  Future<void> setItTicket(ItTicket itTicket) => _service.setData(
        path: APIPath.itTicket(itTicket.id),
        data: itTicket.toMap(),
      );

  @override
  Stream<List<String>> jobYearsStream() {
    var querySnapshot =
        FirebaseFirestore.instance.collection("users/$uid/years").snapshots();
    return querySnapshot.map((snapshot) {
      final result = snapshot.docs.map((e) => e.id).toList();
      print("resuld " + result.toString());
      return result;
    });
    // var snapshots = querySnapshot;
    // return querySnapshot;

    // return years.docs.map(years => years.data());
  }

  @override
  Stream<List<Project>> projectsStream() => _service.collectionStream(
        path: APIPath.project(),
        builder: (data, documentId) => Project.fromMap(data, documentId),
      );

  @override
  Stream<List<SubProject>> subProjectStream(String pid) =>
      _service.collectionStream(
        path: APIPath.subproject(pid),
        builder: (data, documentId) => SubProject.fromMap(data, documentId),
      );

  @override
  Stream<List<ItTicketCategory>> itTicketCategoties() =>
      _service.collectionStream(
        path: APIPath.itTicketsCategory(),
        builder: (data, documentId) =>
            ItTicketCategory.fromMap(data, documentId),
      );

  @override
  Stream<Job> jobStream({@required Job job}) => _service.documentStream(
        path: APIPath.job(
          uid,
          job.workDate.year.toString(),
          job.workDate.month.toString(),
          job.id,
        ),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream(String year, String month) =>
      _service.collectionStream(
          path: APIPath.jobs(uid, year, month),
          builder: (data, documentId) => Job.fromMap(data, documentId),
          sort: (lhs, rhs) => lhs.workDate.compareTo(rhs.workDate));

  @override
  Stream<List<Job>> jobsToApproveStream(String id, String year, String month) =>
      _service.collectionStream(
        path: APIPath.jobs(id, year, month),
        builder: (data, documentId) => Job.fromMap(data, documentId),
        sort: (lhd, rhd) => lhd.workDate.compareTo(rhd.workDate),
      );

  //---------------------Update totals------------------------

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(
          uid,
          job.workDate.year.toString(),
          job.workDate.month.toString(),
          job.id,
        ),
        data: job.toMap(),
      );

  @override
  Future<void> approveJob({String id, Job job, String approveStatus}) =>
      _service.setField(
        path: APIPath.job(
          id,
          job.workDate.year.toString(),
          job.workDate.month.toString(),
          job.id,
        ),
        field: "approveStatus",
        value: approveStatus,
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(
      path: APIPath.job(
        uid,
        job.workDate.year.toString(),
        job.workDate.month.toString(),
        job.id,
      ),
    );
  }

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Future<void> setUser(MyUser myUser) => _service.setData(
        path: APIPath.user(uid),
        data: myUser.toMap(),
      );

  @override
  Stream<MyUser> userStream() => _service.documentStream(
        path: APIPath.user(uid),
        builder: (data, documentId) => MyUser.fromMap(data, documentId),
      );

  @override
  Stream<List<MyUser>> usersStream() => _service.collectionStream(
      path: APIPath.users(),
      builder: (data, documentId) => MyUser.fromMap(data, documentId),
      sort: (lhs, rhs) =>
          lhs.nickname.toLowerCase().compareTo(rhs.nickname.toLowerCase()));
}
