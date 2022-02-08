import 'package:akanet/app/home/models/project.dart';
import 'package:akanet/app/home/models/sub_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  double _ratePerHour;
  String _project;
  String _subProject;
  String _subItemId;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.description;
      _ratePerHour = widget.job.workingHours;
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
        final jobs = await widget.database.jobsStream("2021", "10").first;
        final allNames = jobs.map((job) => job.description).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.description);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, description: _name, workingHours: _ratePerHour);
          await widget.database.setJob(job);
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
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
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
        decoration: InputDecoration(labelText: 'Description'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
      SizedBox(
        height: 40,
      ),
      Row(
        children: [
          StreamBuilder<List<Project>>(
            stream: widget.database.projectsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final List<Project> items = snapshot.data;
              for (int i = 0; i < items.length; i++) {
                print("${items[i].name}");
              }
              return DropdownButton(
                onChanged: (valueSelectedByUser) {
                  setState(
                    () {
                      print("--------" + valueSelectedByUser);
                      _project = valueSelectedByUser;
                      _subProject = null;
                      _subItemId = valueSelectedByUser;
                    },
                  );
                },
                value: _project,
                hint: Text('Choose project'),
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
          StreamBuilder<List<SubProject>>(
            stream: widget.database.subProjectStream(_subItemId),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final List<SubProject> subItems = snapshot.data;
              for (int i = 0; i < subItems.length; i++) {
                print("${subItems[i].name}");
              }

              return DropdownButton(
                onChanged: (valueSelectedByUser) {
                  setState(
                    () {
                      print("--------" + valueSelectedByUser);
                      _subProject = valueSelectedByUser;
                    },
                  );
                },
                value: _subProject,
                hint: Text('Choose project'),
                isDense: true,
                items: subItems.map(
                  (subItem) {
                    return DropdownMenuItem<String>(
                      child: Text(subItem.name),
                      value: subItem.id,
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    ];
  }
}
