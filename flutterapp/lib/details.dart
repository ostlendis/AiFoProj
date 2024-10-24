import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_tags/textfield_tags.dart';

class DetailsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  Gender? _recGender = Gender.male;
  final _stringTagController = StringTagController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          // Gender Section
          Column(
            children: [
              Text("Gender"),
              RadioListTile(
                title: const Text('Male'),
                value: Gender.male,
                groupValue: _recGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _recGender = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Female'),
                value: Gender.female,
                groupValue: _recGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _recGender = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Other'),
                value: Gender.other,
                groupValue: _recGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _recGender = value;
                  });
                },
              ),
            ],
          ),
          Divider(),
          // Age Section
          Column(
            children: [
              TextField(
                decoration:
                    new InputDecoration(labelText: "Age of the Recipient"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              )
            ],
          ),
          Divider(),
          // Interests
          Column(
            children: [
              TextFieldTags<String>( // TODO klappet ned
                  textSeparators: const [' ', ','],
                  validator: (String tag){
                    return null;
                  },
                  textfieldTagsController: _stringTagController,
                  inputFieldBuilder: (context, inputFieldValues) {
                    return TextField(
                      controller: inputFieldValues.textEditingController,
                      focusNode: inputFieldValues.focusNode,
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

enum Gender { male, female, other }
