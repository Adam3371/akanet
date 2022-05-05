import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/aircraft_ticket.dart';
import 'package:akanet/app/home/models/my_user.dart';
import 'package:akanet/app/home/models/it_ticket.dart';
import 'package:akanet/app/home/models/it_ticket_category.dart';
import 'package:akanet/app/home/models/project.dart';
import 'package:akanet/app/home/models/sub_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  Stream jobMonthStream(String year);
  Stream<List<Job>> jobsStream(String year, String month);
  Future<QuerySnapshot> jobsQuery(String year, String month);
  // Future<DocumentSnapshot> jobsMonthQuery(String year, String month);
  // Future<DocumentSnapshot> jobsYearQuery(String year);
  Stream<List<Job>> jobsToApproveStream(String uid, String year, String month);

  Future<void> setMonthUpdate(String id, String year, String month);

  Future<void> setJob(Job job);
  Future<void> setBatchJob(Job job);
  Future<void> approveJob({String id, Job job, String approveStatus});
  Future<void> deleteJob(Job job);

  Stream<List<Entry>> entriesStream({Job job});
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);

  Future<void> setUser(MyUser myUser);
  Stream<MyUser> userStream();
  Stream<List<MyUser>> usersStream();

  String getMyUid();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  String getMyUid() => uid;

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
    final reference = FirebaseFirestore.instance
        .collection("users/$uid/years"); //users/$uid/years
    final x = reference.snapshots().map((querySnap) => querySnap
        .docs //Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
        .map((doc) => doc
            .id) //Getting each document ID from the data property of QueryDocumentSnapshot
        .toList());
    return x;
    // return reference.snapshots();
  }

  @override
  Stream jobMonthStream(String year) {
    final reference = FirebaseFirestore.instance
        .collection("users/$uid/years/$year/months"); //users/$uid/years
    final x = reference.snapshots().map((querySnap) => querySnap
        .docs //Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
        .map((doc) => doc
            .id) //Getting each document ID from the data property of QueryDocumentSnapshot
        .toList());
    return x;
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
  Future<QuerySnapshot> jobsQuery(String year, String month) {
    final reference = FirebaseFirestore.instance.collection(
        "users/$uid/years/$year/months/$month/jobs"); //users/$uid/years
    final jobs = reference.get();
    return jobs;
  }

  // @override
  // Future<DocumentSnapshot> jobsMonthQuery(String year, String month) {
  //   try {
  //     var toTest = FirebaseFirestore.instance
  //         .doc("users/$uid/years/$year/months/$month")
  //         .get();
  //     return toTest;
  //   } catch (e) {
  //     print("Collection not find 1: " + e.toString());
  //     return null;
  //   }
  // }

  // @override
  // Future<DocumentSnapshot> jobsYearQuery(String year) {
  //   try {
  //     var toTest =
  //         FirebaseFirestore.instance.doc("users/$uid/years/$year").get();
  //   } catch (e) {
  //     print("Collection not find 2: " + e.toString());
  //     return null;
  //   }

  //   final reference = FirebaseFirestore.instance
  //       .doc("users/$uid/years/$year"); //users/$uid/years

  //   try {
  //     final jobs = reference.get();
  //     return jobs;
  //   } on FirebaseException catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  @override
  Stream<List<Job>> jobsToApproveStream(String id, String year, String month) =>
      _service.collectionStream(
        path: APIPath.jobs(id, year, month),
        builder: (data, documentId) => Job.fromMap(data, documentId),
        sort: (lhd, rhd) => lhd.workDate.compareTo(rhd.workDate),
      );

  //---------------------Update totals------------------------

  @override
  Future<void> setMonthUpdate(
    String id,
    String year,
    String month,
  ) =>
      _service.setData(
        path: APIPath.jobMonthUpdate(
          id,
          year,
          month,
        ),
        data: {null: null},
      );

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
  Future<void> setBatchJob(Job job) {
    var batch = FirebaseFirestore.instance.batch();

    var jobToSet = FirebaseFirestore.instance.doc(APIPath.job(
      uid,
      job.workDate.year.toString(),
      job.workDate.month.toString(),
      job.id,
    ));
    batch.set(jobToSet, job.toMap());

    var monthUpdateToSet =
        FirebaseFirestore.instance.doc(APIPath.jobMonthUpdate(
      uid,
      job.workDate.year.toString(),
      job.workDate.month.toString(),
    ));
    batch.set(monthUpdateToSet, {null: null});

    var yearUpdateToSet = FirebaseFirestore.instance.doc(APIPath.jobYearUpdate(
      uid,
      job.workDate.year.toString(),
    ));
    batch.set(yearUpdateToSet, {null: null});

    batch.commit();
    return null;
  }
  //  _service.setBatch(
  //       path: APIPath.job(
  //         uid,
  //         job.workDate.year.toString(),
  //         job.workDate.month.toString(),
  //         job.id,
  //       ),
  //       data: job.toMap(),
  //     );

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
