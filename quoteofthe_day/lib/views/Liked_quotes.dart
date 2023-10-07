import 'package:flutter/material.dart';
import 'package:quoteofthe_day/model/quotes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedQuotes extends StatefulWidget {
  const LikedQuotes({super.key});

  @override
  _LikedQuotesState createState() => _LikedQuotesState();
}

class _LikedQuotesState extends State<LikedQuotes> {
  List<Quote> likedQuotes = [];

  @override
  void initState() {
    super.initState();
    loadLikedQuotes();
  }

  // Load liked quotes from SharedPreferences
  Future<void> loadLikedQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final likedQuoteIds = prefs.getStringList('liked_quotes') ?? [];

    setState(() {
      likedQuotes = likedQuoteIds
          .map((id) => quotes.firstWhere((quote) => quote.id == int.parse(id)))
          .toList();
    });
  }

  // Save liked quotes to SharedPreferences
  Future<void> saveLikedQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final likedQuoteIds =
        likedQuotes.map((quote) => quote.id.toString()).toList();
    prefs.setStringList('liked_quotes', likedQuoteIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Liked quotes'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              itemCount: likedQuotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    likedQuotes[index].text,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
