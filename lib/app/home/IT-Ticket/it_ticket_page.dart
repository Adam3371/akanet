import 'package:akanet/app/home/IT-Ticket/edit_it_ticket_page.dart';
import 'package:akanet/app/home_2/jobs/list_items_builder.dart';
import 'package:akanet/app/home_2/models/it_ticket.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class ItTicketPage extends StatelessWidget {
  const ItTicketPage({Key key, this.database}) : super(key: key);

  final Database database;

  static Future<void> show(
    BuildContext context, {
    Database database,
    // Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ItTicketPage(
          database: database,
          // job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('IT Tickets'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              EditItTicketPage.show(context, database: database);
            },
            //  => EditJobPage.show(
            //   context,
            //   database: Provider.of<Database>(context, listen: false),

            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildContents(context, screenSize),
    );
  }

  _buildContents(BuildContext context, Size screenSize) {
    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/mue31.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.withOpacity(0.7),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.black54,
                ),
                height: screenSize.height / 10,
              ),
              _listBuilder(context),
            ],
          ),
        ),
      ),
    );
  }

  _listBuilder(BuildContext context) {
    return StreamBuilder<List<ItTicket>>(
      stream: database.itTicketsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<ItTicket>(
          snapshot: snapshot,
          itemBuilder: (context, itTicket) => Dismissible(
            key: Key('job-${itTicket.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            // onDismissed: (direction) => _delete(context, job),
            child: ListTile(
              onTap: () {
                EditItTicketPage.show(
                  context,
                  database: database,
                  itTicket: itTicket,
                );
              },
              title: Text(itTicket.ticketName),
              subtitle: Text(itTicket.category),
              // leading: Text("itTicket.priority.toString()"),
              trailing: Text(
                itTicket.openingDateTime == null
                    ? "00:00:00"
                    : itTicket.openingDateTime,
              ),
            ),
          ),
        );
      },
    );
  }
}
