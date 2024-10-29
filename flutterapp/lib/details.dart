import 'package:ai_client/model/RecDetails.dart';
import 'package:ai_client/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_tags/textfield_tags.dart';

class DetailsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  String _recGender = "male";
  final _stringTagController = StringTagController();
  TextEditingController _textEditingController = TextEditingController();

  RecDetails fetchDetails() {
    return RecDetails(_recGender, _stringTagController.getTags!.join(", "),
        _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.help_outline_sharp),
                  title: Text('Welcome to the Gift Generator'),
                  subtitle:
                      Text('Please enter the following Information so we can find the perfect Gift for the recipient.'),
                ),

              ],
            ),
          ),
          // Gender Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Gender"),
              RadioListTile(
                title: const Text('Male'),
                value: "male",
                groupValue: _recGender,
                onChanged: (String? value) {
                  setState(() {
                    _recGender = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Female'),
                value: "female",
                groupValue: _recGender,
                onChanged: (String? value) {
                  setState(() {
                    _recGender = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Other'),
                value: "other",
                groupValue: _recGender,
                onChanged: (String? value) {
                  setState(() {
                    _recGender = value!;
                  });
                },
              ),
            ],
          ),
          Divider(),
          // Age Section
          Column(
            children: [
              Text("Age"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Age of the recipient",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 74, 137, 92),
                        width: 3.0,
                      ),
                    ),
                    helperStyle: TextStyle(
                      color: Color.fromARGB(255, 74, 137, 92),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: TextEditingController(),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Divider(),
          // Interests
          Column(
            children: [
              Text("Hobbies"),
              TextFieldTags<String>(
                textfieldTagsController: _stringTagController,
                textSeparators: const [' ', ','],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  if (_stringTagController.getTags!.contains(tag)) {
                    return 'You\'ve already entered that';
                  }
                  return null;
                },
                inputFieldBuilder: (context, inputFieldValues) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      onTap: () {
                        _stringTagController.getFocusNode?.requestFocus();
                      },
                      controller: inputFieldValues.textEditingController,
                      focusNode: inputFieldValues.focusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        helperStyle: const TextStyle(
                          color: Color.fromARGB(255, 74, 137, 92),
                        ),
                        hintText: inputFieldValues.tags.isNotEmpty
                            ? ''
                            : "Enter hobbies",
                        labelText: "Hobbies of the recipient",
                        errorText: inputFieldValues.error,
                        prefixIcon: inputFieldValues.tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller:
                                    inputFieldValues.tagScrollController,
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 8,
                                  ),
                                  child: Wrap(
                                      runSpacing: 4.0,
                                      spacing: 4.0,
                                      children: inputFieldValues.tags
                                          .map((String tag) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color: Color.fromARGB(
                                                255, 74, 137, 92),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onTap: () {
                                                  //print("$tag selected");
                                                },
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: const Icon(
                                                  Icons.cancel,
                                                  size: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                ),
                                                onTap: () {
                                                  inputFieldValues
                                                      .onTagRemoved(tag);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                ),
                              )
                            : null,
                      ),
                      onChanged: inputFieldValues.onTagChanged,
                      onSubmitted: inputFieldValues.onTagSubmitted,
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultsWidget(recDetails: fetchDetails())));
              },
              child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: const Text("Generate Ideas")))
        ],
      ),
    );
  }
}
