import 'package:akanet/app/home/models/job_month_overview.dart';
import 'package:akanet/app/home/models/job_year_overview.dart';
import 'package:akanet/app/home/models/project.dart';
import 'package:akanet/app/home/models/sub_project.dart';
import 'package:akanet/common_widgets/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:numberpicker/numberpicker.dart';

class WorkTimeEntryPage extends StatefulWidget {
  const WorkTimeEntryPage({Key key, @required this.database, this.job})
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
        builder: (context) => WorkTimeEntryPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _WorkTimeEntryPageState createState() => _WorkTimeEntryPageState();
}

class _WorkTimeEntryPageState extends State<WorkTimeEntryPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  double _workingHours;
  String _project;
  String _projectId;
  String _subProject;
  String _subProjectId;
  String _subItemId;
  bool _isWerk;

  DateTime _workDate;
  int _currentHourValue = 0;
  int _currentMinutesValue = 0;

  @override
  void initState() {
    super.initState();
    final start = DateTime.now();
    _workDate = DateTime(start.year, start.month, start.day);

    if (widget.job != null) {
      _name = widget.job.description;
      _workingHours = widget.job.workingHours;
      _workDate = widget.job.workDate;
      _project = widget.job.project;
      _subProject = widget.job.subproject;
      _projectId = widget.job.projectId;
      _subProjectId = widget.job.subprojectId;
      _subItemId = widget.job.projectId;
      _isWerk = widget.job.isWerk;

      double value = widget.job.workingHours;
      // if (value < 0) return 'Invalid Value';
      int flooredValue = value.floor();
      double decimalValue = value - flooredValue;
      _currentHourValue = flooredValue;
      _currentMinutesValue = (decimalValue * 60).toInt().round();
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate() && _project != null) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        // final jobs = await widget.database
        //     .jobsQuery(_workDate.year.toString(), _workDate.month.toString());

        // final jobList = jobs.docs
        //     .map((DocumentSnapshot e) => Job.fromMap(e.data(), null))
        //     .toList();
        // for (Job j in jobList) {
        //   print(" _ " + j.workingHours.toString());
        // }
        JobMonthOverview jobMonthStat;
        JobYearOverview jobYearStat;

        final jobMonthStatusReq = await widget.database.jobsMonthQuery(
            _workDate.year.toString(), _workDate.month.toString());
        if (jobMonthStatusReq != null) {
          jobMonthStat =
              JobMonthOverview.fromMap(jobMonthStatusReq.data(), null);
        } else {
          print("1 Error in finding overview");
          jobMonthStat = JobMonthOverview(
            totalHours: 0,
            approvedHours: 0,
            totWerkHours: 0,
            appWerkHours: 0,
          );
        }

        final jobYearStausReq =
            await widget.database.jobsYearQuery(_workDate.year.toString());
        if (jobYearStausReq != null) {
          jobYearStat = JobYearOverview.fromMap(jobYearStausReq.data(), null);
        } else {
          print("2 Error in finding overview");
          jobYearStat = JobYearOverview(
            totalHours: 0,
            approvedHours: 0,
            totWerkHours: 0,
            appWerkHours: 0,
          );
        }

        _workingHours = _currentHourValue + (_currentMinutesValue / 60);

        final id = widget.job?.id ?? documentIdFromCurrentDate();
        final job = Job(
          id: id,
          project: _project,
          projectId: _projectId,
          subproject: _subProject,
          subprojectId: _subProjectId,
          approveStatus: "open",
          description: _name,
          workingHours: _workingHours,
          workDate: _workDate,
          isWerk: _isWerk,
        );

        jobMonthStat.totalHours += job.workingHours;
        jobYearStat.totalHours += job.workingHours;

        if (job.isWerk) {
          jobMonthStat.totWerkHours += job.workingHours;
          jobYearStat.totWerkHours += job.workingHours;
        }

        await widget.database.setBatchJob(job, jobMonthStat, jobYearStat);

        Navigator.of(context).pop();
        // }
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

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _workDate,
      // selectedTime: _startTime,
      selectDate: (date) => setState(() => _workDate = date),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      _buildStartDate(),
      SizedBox(
        height: 30,
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
              return DropdownButton(
                onChanged: (valueSelectedByUser) {
                  setState(
                    () {
                      _isWerk = items
                          .firstWhere(
                              (element) => element.id == valueSelectedByUser)
                          .isWerkstatt;
                      print("--------" +
                          items
                              .firstWhere((element) =>
                                  element.id == valueSelectedByUser)
                              .name);
                      _projectId = valueSelectedByUser;
                      _project = items
                          .firstWhere(
                              (element) => element.id == valueSelectedByUser)
                          .name;
                      _subProject = null;
                      _subProjectId = null;
                      _subItemId = valueSelectedByUser;
                    },
                  );
                },
                value: _projectId,
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

              return DropdownButton(
                onChanged: (valueSelectedByUser) {
                  setState(
                    () {
                      print("--------" + valueSelectedByUser);
                      _subProjectId = valueSelectedByUser;
                      _subProject = subItems
                          .firstWhere(
                              (element) => element.id == valueSelectedByUser)
                          .name;
                    },
                  );
                },
                value: _subProjectId,
                hint: subItems.length == 0
                    ? Text("No sub project")
                    : Text('Choose sub project'),
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
          Checkbox(
            value: _isWerk == null ? false : _isWerk,
            onChanged: (checkt) {
              setState(() {
                _isWerk = checkt;
              });
            },
          ),
          Text("Is Werkstatt"),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Description'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      Row(
        children: [
          Text(
            "Hours",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          NumberPicker(
            value: _currentHourValue,
            minValue: 0,
            maxValue: 24,
            step: 1,
            haptics: true,
            onChanged: (value) => setState(() => _currentHourValue = value),
          ),
          Text(
            "Minutes",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          NumberPicker(
            value: _currentMinutesValue,
            minValue: 0,
            maxValue: 45,
            step: 15,
            haptics: true,
            onChanged: (value) => setState(() => _currentMinutesValue = value),
          ),
        ],
      ),
      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Number of hours (30min = 0,5)'),
      //   initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
      //   keyboardType: TextInputType.numberWithOptions(
      //     signed: false,
      //     decimal: false,
      //   ),
      //   onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      // ),
      SizedBox(
        height: 40,
      ),
    ];
  }
}
