import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

import 'model/GiftResponse.dart';
import 'model/RecDetails.dart';

// TODO idee für doku:
/*
  Ersti Version ui und ohni titel
  zweiti version unter improvements oder so
 */

// TODO link zu galaxus für geschenkideen

class ResultsWidget extends StatefulWidget {
  final RecDetails recDetails;

  const ResultsWidget({super.key, required this.recDetails});

  @override
  State<ResultsWidget> createState() => _ResultsState();
}

class _ResultsState extends State<ResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Your Ideas"),
      ),
      body: FutureBuilder(
        future: giftResponse(this.widget.recDetails),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(0),
              child: ListView(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: snapshot.data!.cards(),
              )
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text("An Error has occured:"),
                  Text('${snapshot.error}')
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<GiftResponse> giftResponse(RecDetails details) async {
  final systemMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        """You will return 5 Christmas present ideas based on your input.

        The input will consist of certain constraints, separated by a newline.

        Constraint number one will be the persons gender: the options are male, female, or custom.
        Tailor the ideas according to the given gender.

        Constraint number two is the persons age.
        Tailor the ideas with the age in mind.

        Constraint number three will be the persons interest: it is a comma separated list.
        Tailor the ideas around the given interests, however, they do not have to be strictly in correlation with the interests
        
        Here is the json schema we would like the answers to be in. Output valid json which uses the following schema as a schema:
        {
        "name": "present_response_schema",
        "strict": true,
        "schema": {
          "properties": {
            "presents": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "title": {
                    "type": "string",
                    "description": "A short title of the present."
                  }
                  "description": {
                    "type": "string",
                    "description": "A detailed description of the present."
                  }
                },
                "required": [
                  "description"
                ],
                "additionalProperties": false
              }
            }
          },
          "additionalProperties": false,
          "required": [
            "presents"
          ],
          "type": "object"
        }
      }
          """, // TODO
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );

  // the user message that will be sent to the request.
  final userMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "${details.gender}\n${details.age}\n${details.hobbies}",
      ),
    ],
    role: OpenAIChatMessageRole.user,
  );

  final requestMessages = [
    systemMessage,
    userMessage,
  ];

  // the actual request.
  OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
    model: "gpt-4o",
    responseFormat: {"type": "json_object"},
    seed: 6,
    messages: requestMessages,
    temperature: 0.2,
    maxTokens: 500,
  );

  final json =
      jsonDecode(chatCompletion.choices.first.message.content!.first.text!);
  return GiftResponse.fromJson(json);
}
