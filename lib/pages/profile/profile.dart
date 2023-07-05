import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:developer' as developer;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../main.dart';
import '../../utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    _nameController.text = context.read<MyAppState>().name;
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    var appState = context.watch<MyAppState>();

    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: ListView(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter your name...',
                labelText: 'Name',
              ),
              onChanged: (value) {
                // setState(() {
                //   appState.name = value;
                // });
                context.read<MyAppState>().changeName(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter your email...',
                labelText: 'Email',
              ),
              onChanged: (value) {
                setState(() {
                  appState.email = value;
                });
              },
            ),
            _FormDatePicker(
              date: appState.date,
              onChanged: (value) {
                setState(() {
                  appState.date = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    //update UI
                  });
                },
                child: Text("Pick Image")),
            image == null ? Container() : Image.file(File(image!.path))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              dialogBuilder(context, context.read<MyAppState>().name),
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.add_rounded),
        ));
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        ),
      ],
    );
  }
}
