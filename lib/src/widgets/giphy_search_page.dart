import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget title;
  final Color color;
  final Brightness brightness;
  final Color backgroundColor;

  const GiphySearchPage({this.title,this.color, this.brightness,this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GiphySearchView(color: color,brightness: brightness,backgroundColor: backgroundColor,);
  }
}
