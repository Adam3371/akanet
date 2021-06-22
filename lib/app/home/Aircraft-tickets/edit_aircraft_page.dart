import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';

class EditAircraftPage extends StatefulWidget {
  const EditAircraftPage({Key key, @required this.database, this.aircraft})
      : super(key: key);
  final Database database;
  final Aircraft aircraft;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Aircraft aircraft,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditAircraftPage(
          database: database,
          aircraft: aircraft,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditAircraftPageState createState() => _EditAircraftPageState();
}

class _EditAircraftPageState extends State<EditAircraftPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _mantainer;
  String _mantainerId;

  @override
  void initState() {
    super.initState();
    if (widget.aircraft != null) {
      _name = widget.aircraft.name;
      _mantainer = widget.aircraft.mantainer;
      _mantainerId = widget.aircraft.mantainerId;
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
    if (_validateAndSaveForm()) {
      try {
        final aircrafts = await widget.database.aircraftsStream().first;
        final allNames = aircrafts.map((aircraft) => aircraft.name).toList();
        if (widget.aircraft != null) {
          allNames.remove(widget.aircraft.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.aircraft?.id ?? documentIdFromCurrentDate();
          final aircraft = Aircraft(
              id: id,
              name: _name,
              mantainer: _mantainer,
              mantainerId: _mantainerId);
          await widget.database.setAircraft(aircraft: aircraft);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
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
        title: Text(widget.aircraft == null ? 'New Aircraft' : 'Edit Aircraft'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
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
        decoration: InputDecoration(labelText: 'Aircraft Name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      StreamBuilder<List<User>>(
        stream: widget.database.usersStream(),
        builder: (context, snapshot) {
          // print(snapshot.data);
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          final List<User> items = snapshot.data;
          // print(items.length);
          for (int i = 0; i < items.length; i++) {
            print("${items[i].name}");
          }
          return DropdownButton(
            onChanged: (valueSelectedByUser) {
              setState(
                () {
                  _mantainerId = valueSelectedByUser;
                  _mantainer = items[items.indexWhere((element) => element.id == _mantainerId)].name;                  
                },
              );
            },
            value: _mantainerId,
            hint: Text('Mantainer'),
            isDense: true,
            items: items.map(
              (item) {
                return DropdownMenuItem<String>(
                  child: Text(item.name),
                  value: item.id,
                );
              },
            ).toList(),
          );
        },
      ),
    ];
  }
}
