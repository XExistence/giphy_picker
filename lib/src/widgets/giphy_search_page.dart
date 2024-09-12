import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

import 'giphy_context.dart';

class GiphySearchPage extends StatelessWidget {
  final Widget title;
  final Color color;
  final Brightness brightness;
  final Color backgroundColor;
  Widget logo;

  GiphySearchPage(
      {required this.title,
      required this.color,
      required this.brightness,
      required this.backgroundColor,
      required this.logo});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final giphyDecorator = GiphyContext.of(context).decorator;
      return Theme(
        data: giphyDecorator.giphyTheme ?? Theme.of(context),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: this.backgroundColor,
            statusBarIconBrightness: this.brightness,
          ),
          child: Scaffold(
            body: SafeArea(
              child: GiphySearchView(
                color: this.color,
                backgroundColor: this.backgroundColor,
                brightness: this.brightness,
                logo: logo,
              ),
              bottom: false,
            ),
          ),
        ),
      );
    });
  }
}
