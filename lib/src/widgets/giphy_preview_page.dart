import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giphy_picker/src/widgets/giphy_image.dart';

import '../../giphy_picker.dart';

/// Presents a Giphy preview image.
class GiphyPreviewPage extends StatelessWidget {
  final GiphyGif gif;
  final Widget? title;
  final ValueChanged<GiphyGif>? onSelected;
  final Color color;
  final Brightness brightness;

  const GiphyPreviewPage(
      {required this.gif, this.onSelected, this.title,required this.color,required this.brightness});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
            brightness: brightness,
            leading: !Platform.isIOS
                ? IconButton(
              onPressed: () => Navigator.pop(context, false),
              icon: Icon(
                const IconData(
                  0xe900,
                  fontFamily: 'backarrow',
                ),
                size: 20.0,
              ),
              color: brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            )
                : RotatedBox(
              quarterTurns: 2,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                onTap: () => Navigator.pop(context, false),
                child: Padding(
                  padding: EdgeInsets.all(17),
                  child: SvgPicture.asset(
                    "assets/svg/next.svg",
                    color: brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          backgroundColor: color,
            title: title, actions: <Widget>[
          Container(
            width: 50,
            height: 50,
            child: RawMaterialButton(
              onPressed: () => onSelected?.call(gif),
              elevation: 2.0,
              child: SvgPicture.asset("assets/svg/tick.svg",
                  color: brightness == Brightness.dark ? Colors.white : Colors.black ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          )
        ]),
        body: SafeArea(
            child: Center(
                child: GiphyImage.original(
              gif: gif,
              width: media.orientation == Orientation.portrait
                  ? double.maxFinite
                  : null,
              height: media.orientation == Orientation.landscape
                  ? double.maxFinite
                  : null,
              fit: BoxFit.contain,
            )),
            bottom: false));
  }
}
