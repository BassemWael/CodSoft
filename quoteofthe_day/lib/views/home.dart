import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quoteofthe_day/components/Favouritebutton.dart';
import 'package:quoteofthe_day/model/quotes.dart';
import 'liked_quotes.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final List<Quote> quotes;
  int currentDay;
  int quoteIndex;

  HomePage({
    super.key,
    required this.quotes,
    required this.currentDay,
    required this.quoteIndex,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _quoteTimer;

  @override
  void initState() {
    super.initState();
    _loadLikedQuotes();
    _loadCurrentDayAndQuoteIndex();

    // Schedule the timer to change the quote every 24 hours
    _quoteTimer = Timer.periodic(Duration(hours: 24), (timer) {
      _changeQuote();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer to prevent memory leaks
    _quoteTimer.cancel();
  }

  Future<void> _loadLikedQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedQuoteIds = prefs.getStringList('liked_quotes') ?? [];

      setState(() {
        for (final quote in widget.quotes) {
          quote.isLiked = likedQuoteIds.contains(quote.id.toString());
        }
      });
    } catch (e) {
      // Handle error loading liked quotes
      print("Error loading liked quotes: $e");
    }
  }

  Future<void> saveLikedQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedQuoteIds = widget.quotes
          .where((quote) => quote.isLiked)
          .map((quote) => quote.id.toString())
          .toList();
      prefs.setStringList('liked_quotes', likedQuoteIds);
    } catch (e) {
      // Handle error saving liked quotes
      print("Error saving liked quotes: $e");
    }
  }

  Future<void> _saveCurrentDayAndQuoteIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('current_day', widget.currentDay);
      prefs.setInt('quote_index', widget.quoteIndex);
    } catch (e) {
      // Handle error saving current day and quote index
      print("Error saving current day and quote index: $e");
    }
  }

  Future<void> _loadCurrentDayAndQuoteIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        widget.currentDay = prefs.getInt('current_day') ?? 1;
        widget.quoteIndex = prefs.getInt('quote_index') ?? 0;
      });
    } catch (e) {
      // Handle error loading current day and quote index
      print("Error loading current day and quote index: $e");
    }
  }

  void _changeQuote() {
    setState(() {
      // Generate a new random quote index
      final random = Random();
      int newQuoteIndex;
      do {
        newQuoteIndex = random.nextInt(widget.quotes.length);
      } while (newQuoteIndex ==
          widget.quoteIndex); // Ensure it's not the same as the current quote
      widget.quoteIndex = newQuoteIndex;

      // Increment the current day
      widget.currentDay++;

      // Save the updated values
      _saveCurrentDayAndQuoteIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Quote quote = widget.quotes[widget.quoteIndex];

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
          body: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LikedQuotes(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 8,
              ),
              Center(
                child: Text(
                  'Day #${widget.currentDay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  quote.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FavoriteButton(
                    quote: quote,
                    onLiked: () {
                      saveLikedQuotes();
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      Share.share(quote.text); // Share the quote text.
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
