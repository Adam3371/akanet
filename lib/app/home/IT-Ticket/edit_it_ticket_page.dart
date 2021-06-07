import 'package:akanet/app/home_2/models/it_ticket.dart';
import 'package:akanet/app/home_2/models/it_ticket_category.dart';
import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditItTicketPage extends StatefulWidget {
  const EditItTicketPage({Key key, this.database, this.itTicket})
      : super(key: key);

  final Database database;
  final ItTicket itTicket;

  static Future<void> show(
    BuildContext context, {
    Database database,
    ItTicket itTicket,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditItTicketPage(
          database: database,
          itTicket: itTicket,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditItTicketPageState createState() => _EditItTicketPageState();
}

class _EditItTicketPageState extends State<EditItTicketPage> {
  final _formKey = GlobalKey<FormState>();

  String _id;
  String _ticketName;
  String _ticketDescription;
  String _customerId;
  String _customerName;
  String _category;
  String _openingDateTime;
  String _workingDateTime;
  String _closingDateTime;
  int _priority;
  int _status;

  @override
  void initState() {
    super.initState();
    if (widget.itTicket != null) {
      _id = widget.itTicket.id;
      _ticketName = widget.itTicket.ticketName;
      _ticketDescription = widget.itTicket.ticketDescription;
      _customerId = widget.itTicket.customerId;
      _customerName = widget.itTicket.customerName;
      _category = widget.itTicket.category;
      _openingDateTime = widget.itTicket.openingDateTime;
      _workingDateTime = widget.itTicket.workingDateTime;
      _closingDateTime = widget.itTicket.closingDateTime;
      _priority = widget.itTicket.priority;
      _status = widget.itTicket.status;
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
      print("Entering here");
      try {
        final itTickets = await widget.database.itTicketsStream().first;
        final allNames = itTickets.map((ticket) => ticket.ticketName).toList();
        if (widget.itTicket != null) {
          allNames.remove(widget.itTicket.ticketName);
        }
        if (allNames.contains(itTickets)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        }
        else {
          final id = widget.itTicket?.id ?? documentIdFromCurrentDate();
          final ticket = ItTicket(
            id: id,
            ticketName: _ticketName,
            ticketDescription: _ticketDescription,
            category: _category,
            customerId: _customerId,
            customerName: _customerName,
            openingDateTime: _openingDateTime,
            workingDateTime: _workingDateTime,
            closingDateTime: _closingDateTime,
            priority: _priority,
            status: _status,
          );
          await widget.database.setItTicket(ticket);
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
        title: Text(
          widget.itTicket == null ? "New It Ticket" : "Edit It Ticket",
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  _buildFormChildren() {
    return [
      Text("id = $_id"),
      TextFormField(
        decoration: InputDecoration(labelText: 'Name'),
        initialValue: _ticketName,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _ticketName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Description'),
        initialValue: _ticketDescription,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _ticketDescription = value,
      ),
      Row(
        children: [
          StreamBuilder<List<ItTicketCategory>>(
            stream: widget.database.itTicketCategoties(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final List<ItTicketCategory> items = snapshot.data;
              for (int i = 0; i < items.length; i++) {
                print("${items[i].name}");
              }
              return DropdownButton(
                onChanged: (valueSelectedByUser) {
                  setState(
                    () {
                      print("--------" + valueSelectedByUser);
                      _category = valueSelectedByUser;
                    },
                  );
                },
                value: _category,
                hint: Text('Choose project'),
                isDense: true,
                items: items.map(
                  (item) {
                    return DropdownMenuItem<String>(
                      child: Text(item.name),
                      value: item.name,
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
