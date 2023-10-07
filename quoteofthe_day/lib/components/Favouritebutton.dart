import 'package:flutter/material.dart';
import 'package:quoteofthe_day/model/quotes.dart';

class FavoriteButton extends StatefulWidget {
  final Quote quote;
  final Function() onLiked;

  const FavoriteButton({super.key, required this.quote, required this.onLiked});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.quote.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.quote.isLiked ? Colors.red : Colors.white,
      ),
      onPressed: () {
        setState(() {
          widget.quote.isLiked = !widget.quote.isLiked;
        });
        widget
            .onLiked(); // Notify the parent widget that the liked status has changed
      },
    );
  }
}
