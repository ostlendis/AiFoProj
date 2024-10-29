import 'package:flutter/material.dart';

import 'Idea.dart';

class GiftResponse {
  Set<Idea> ideas = <Idea>{};

  GiftResponse();

  factory GiftResponse.fromJson(Map<String, dynamic> data) {
    GiftResponse gr = GiftResponse();
    for (Map<String, dynamic> idea in data['presents']) {
      gr.ideas.add(Idea(idea["title"], idea['description']));
    }
    return gr;
  }

  List<Widget> cards() {
    List<Widget> cards = List.empty(growable: true);
    for (Idea idea in ideas) {
      cards.add(Card(
        child: ListTile(
            title: Text(idea.title),
            subtitle: Text(idea.description),
            trailing: IconButton(
                onPressed: () {
                  _launchUrl(
                      "https://www.galaxus.ch/de/search?searchSectors=0&q=${idea.title}");
                },
                icon: Icon(Icons.shopping_bag_outlined, color: Colors.green,))),
      ));
    }
    return cards;
  }

  Future<void> _launchUrl(String url) async {
    // final Uri _url = Uri.parse(url);
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }
}
