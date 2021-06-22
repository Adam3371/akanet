import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/aircraft_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';

class EditAircraftTicketPage extends StatefulWidget {
  const EditAircraftTicketPage({
    Key key,
    @required this.database,
    @required this.aircraft,
    this.aircraftTicket,
  }) : super(key: key);
  final Database database;
  final AircraftTicket aircraftTicket;
  final Aircraft aircraft;

  static Future<void> show(
    BuildContext context, {
    Database database,
    AircraftTicket aircraftTicket,
    Aircraft aircraft,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditAircraftTicketPage(
          database: database,
          aircraftTicket: aircraftTicket,
          aircraft: aircraft,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditAircraftTicketPageState createState() => _EditAircraftTicketPageState();
}

class _EditAircraftTicketPageState extends State<EditAircraftTicketPage> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  String _creator;
  String _mantainerId;

  //Prio
  List<String> _prio = ['Low', 'Middle', 'High', 'Immediatly']; // Option 2
  String _selectedPrio; // Option 2
  //Status
  List<String> _status = ['Open', 'Working', 'Holding', 'Done'];
  String _selectedStatus; // Option 2

  @override
  void initState() {
    super.initState();
    if (widget.aircraftTicket != null) {
      _title = widget.aircraftTicket.title;
      _creator = widget.aircraftTicket.creator;
      _mantainerId = widget.aircraftTicket.dateCreate;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    print("------ ");
    if (_validateAndSaveForm()) {
      try {
        print("------ " + widget.aircraft.id);
        final aircraftTickets = await widget.database
            .aircraftTicketsStream(aircraftId: widget.aircraft.id)
            .first;
        final allTitles = aircraftTickets
            .map((aircraftTicket) => aircraftTicket.title)
            .toList();
        if (widget.aircraftTicket != null) {
          allTitles.remove(widget.aircraftTicket.title);
        }
        if (allTitles.contains(_title)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Error: Please Contact Rötlich',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.aircraftTicket?.id ?? documentIdFromCurrentDate();
          final aircraftTicket = AircraftTicket(
              id: id,
              title: _title,
              creator: _creator,
              dateCreate: _mantainerId);
          await widget.database.setAircraftTicket(
              aircraftId: widget.aircraft.id, aircraftTicket: aircraftTicket);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        print("+++++++++++");
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title:
            Text(widget.aircraftTicket == null ? 'New Ticket' : 'Edit Ticket'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              print("-----# " + widget.aircraft.id);
              _submit();
              },
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Ticket Title'),
        initialValue: _title,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Ticket Description'),
        initialValue: _title,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      Row(
        children: [
          DropdownButton(
            hint: Text('Priority'), // Not necessary for Option 1
            value: _selectedPrio,
            onChanged: (newValue) {
              setState(() {
                _selectedPrio = newValue;
              });
            },
            items: _prio.map((prio) {
              return DropdownMenuItem(
                child: new Text(prio),
                value: prio,
              );
            }).toList(),
          ),
          DropdownButton(
            hint: Text('Status'), // Not necessary for Option 1
            value: _selectedStatus,
            onChanged: (newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
            items: _status.map((status) {
              return DropdownMenuItem(
                child: new Text(status),
                value: status,
              );
            }).toList(),
          ),
        ],
      )
    ];
  }
}
