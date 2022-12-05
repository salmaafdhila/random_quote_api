import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';

class ListQuote extends StatelessWidget {
  final String apiUrl = "https://quote-api.dicoding.dev/list";

  const ListQuote({super.key});

  Future<List<dynamic>> _fecthListQuotes() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Quotes'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fecthListQuotes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        snapshot.data[index]['en'],
                        textAlign: TextAlign.justify,
                      ),
                      subtitle: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "\n~ " + snapshot.data[index]['author'],
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      trailing: Flexible(
                        child: SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              RatingBar.builder(
                                minRating: 1,
                                itemCount: 1,
                                allowHalfRating: true,
                                onRatingUpdate: (double value) {},
                                initialRating: 4.7,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Text(snapshot.data[index]['rating'].toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
