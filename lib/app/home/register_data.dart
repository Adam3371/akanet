import 'package:akanet/app/home/models/my_user.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterData extends StatefulWidget {
  const RegisterData({Key key, this.database}) : super(key: key);
  @required
  final Database database;

  @override
  State<RegisterData> createState() => _RegisterDataState();
}

class _RegisterDataState extends State<RegisterData> {
  bool error = true;
  String _id;
  String _name;
  String _surname;
  String _nickname;
  String _email;
  String _rank = "Anwärter";
  DateTime _createDateTime = DateTime.now();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> _submit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _email = auth.currentUser.email;
    _id = auth.currentUser.uid;
    try {
      _name = _nameController.text;
      _surname = _surnameController.text;
      if (_nicknameController.text.isEmpty) {
        _nickname = _nameController.text;
      } else {
        _nickname = _nicknameController.text;
      }

      final myUser = MyUser(
        id: _id,
        name: _name,
        surname: _surname,
        nickname: _nickname,
        rank: _rank,
        role: "",
        email: _email,
        phoneNum: "",
        hourPerYear: 300,
        totHours: 0,
        apprHours: 0,
        flugberechtigung: false,
        // fb: [],
        createDateTime: _createDateTime,
      );
      await widget.database.setUser(myUser);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background_desktop.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: screenSize.width > screenSize.height
          ? _buildDesktop(screenSize)
          : _buildMobile(screenSize),
    );
  }

  Widget _buildMobile(Size screenSize) {
    return _contentContainer(screenSize);
  }

  Widget _buildDesktop(Size screenSize) {
    return Row(
      children: [
        SizedBox(
          width: screenSize.width / 2 - 300,
        ),
        Container(
          width: 600,
          child: _contentContainer(screenSize),
        ),
        SizedBox(
          width: screenSize.width / 2 - 300,
        ),
      ],
    );
  }

  Widget _contentContainer(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Please register your basic data",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize.width > screenSize.height ? 25 : 15,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Max",
                    errorText: _nameController.text.isEmpty
                        ? "Can\'t be empty!"
                        : null),
                onChanged: (_) {
                  setState(() {
                    if (_nameController.text.isEmpty ||
                        _surnameController.text.isEmpty) {
                      error = true;
                    } else {
                      error = false;
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                    labelText: "Surname",
                    hintText: "Mustermann",
                    errorText: _surnameController.text.isEmpty
                        ? "Can\'t be empty!"
                        : null),
                onChanged: (_) {
                  setState(() {
                    if (_nameController.text.isEmpty ||
                        _surnameController.text.isEmpty) {
                      error = true;
                    } else {
                      error = false;
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: "Nickname (Can be empty)",
                  hintText: "Nicky",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                value: _rank,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _rank = newValue;
                  });
                },
                items: <String>[
                  'Anwärter',
                  'Junggruppler', //todelete
                  'Alter Herr',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: error ? null : _submit,
                  child: Text("Submit"),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
        color: Colors.grey[300].withOpacity(0.8),
      ),
    );
  }
}
