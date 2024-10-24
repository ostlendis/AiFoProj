import 'package:flutter/material.dart';

class ResultsWidget extends StatefulWidget {
  const ResultsWidget({ super.key });

  @override
  State<ResultsWidget> createState() => _YellowBirdState();
}

class _YellowBirdState extends State<ResultsWidget> {
  late Future responseFuture;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: responseFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },

    );
  }
}

class GiftResponse {
  String? placeholder;

  GiftResponse fetchResponse() {
    final response = await http.get()
    return GiftResponse();
  }
}